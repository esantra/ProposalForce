/**
 * Copyright (c) 2018, salesforce.com, inc., 
 *  All rights reserved. 
 * SPDX-License-Identifier: BSD-3-Clause 
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

({
  scriptsLoaded: function(component, event, helper) {
    helper.component = component
    helper.removeClass('spinner', 'slds-hide')
    const recordId = component.get('v.recordId')
    helper
      .fireApex('c.getNamespacePrefix', {})
      .then(namespacePrefix => {
        const template = $A.get(
          `$Resource.${namespacePrefix}RFP_Output_Template`
        )
        if (!template) {
          component.set(
            'v.error',
            "Please upload a .docx template file to static resources with the name 'RFP_Output_Template'. See documentation for more on formatting."
          )
          helper.addClass('spinner', 'slds-hide')
          return
        }
        helper
          .fireApex('c.getQuestions', { selectedRfpId: recordId })
          .then(questions => {
            const responses = questions.map(q => ({
              question: q.RFP_Question_Text__c || '',
              response:
                q.RFP_Response__r &&
                q.RFP_Response__r.Response_Text__c
                  ? q.RFP_Response__r.Response_Text__c.replace(
                      /<[^>]*>/g,
                      ''
                    )
                  : false,
              hasResponse: !!q.RFP_Response__r,
              compliance: q.Compliance_Response__c
                ? q.Compliance_Response__c
                : false,
              hasCompliance: !!q.Compliance_Response__c
            }))

            function loadFile(url, callback) {
              JSZipUtils.getBinaryContent(url, callback)
            }

            loadFile(template, (error, content) => {
              if (error) {
                throw error
              }
              const zip = new JSZip(content)
              const doc = new Docxtemplater().loadZip(zip)
              doc.setData({
                responses
              })

              try {
                // render the document (replace all occurences of {first_name} by John, {last_name} by Doe, ...)
                doc.render()
              } catch (err) {
                const e = {
                  message: err.message,
                  name: err.name,
                  stack: err.stack,
                  properties: err.properties
                }
                // The err thrown here contains additional information when logged with JSON.stringify (it contains a property object).
                helper.addClass('spinner', 'slds-hide')
                throw err
              }

              const out = doc.getZip().generate({
                type: 'base64',
                mimeType:
                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
              }) // Output the document using Data-URI

              helper
                .fireApex('c.generateWordDoc', {
                  doc: out,
                  rfpId: recordId,
                  rfpName: questions[0].RFP__r.Name
                })
                .then(fileId => {
                  component.set('v.fileId', fileId)
                  helper.addClass('spinner', 'slds-hide')
                })
                .catch(err => {
                  component.set(
                    'v.error',
                    "Please upload a .docx template file to static resources with the name 'RFP_Output_Template'. See documentation for more on formatting."
                  )
                  helper.addClass('spinner', 'slds-hide')
                })
            })
          })
      })
      .catch(err => {
        component.set(
          'v.error',
          "Please upload a .docx template file to static resources with the name 'RFP_Output_Template'. See documentation for more on formatting."
        )
        helper.addClass('spinner', 'slds-hide')
      })
  }
})