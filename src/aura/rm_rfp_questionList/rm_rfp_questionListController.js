/**
 * Copyright (c) 2018, salesforce.com, inc., 
 *  All rights reserved. 
 * SPDX-License-Identifier: BSD-3-Clause 
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

({
  init: function(component, event, helper) {
    helper.component = component
    helper.fireEvent('rm_rfp_action', { type: 'getRFPs', payload: {} })
    helper.fireEvent('rm_rfp_action', { type: 'getCurrentUserId', payload: {} })
  },

  render: function(component, event, helper) {
    const { selectedQuestionId, questions, userId } = component.get('v.state')
    // const { questions } = component.get('v.state')
    if (component.find('filter')) {
      const filters = component
        .find('filter')
        .map(f => (f.get('v.checked') ? f.get('v.name') : null))
        .filter(f => f)
      const accordionItems = component.find('accordionItemContainer')

      questions.forEach((q, i) => {
        if (filters.includes('myQuestions')) {
          // the 'or' status contiditions plus 'and' condition of ownership
          if (
            (filters.includes(q.Status__c) ||
              filters.length === 1) &&
            q.Assignee__c === userId
          ) {
            $A.util.removeClass(accordionItems[i], 'hidden')
          } else {
            $A.util.addClass(accordionItems[i], 'hidden')
          }
          // only the 'or' conditions
        } else if (
          filters.includes(q.Status__c) ||
          !filters.length
        ) {
          $A.util.removeClass(accordionItems[i], 'hidden')
        } else {
          $A.util.addClass(accordionItems[i], 'hidden')
        }
      })
    }
  },

  setSelectedRfp: function(component, event, helper) {
    const selectedRfpId = event.currentTarget.dataset.id
    const { RFPs } = component.get('v.state')
    let { Compliance_Responses__c } = RFPs.filter(
      rfp => rfp.Id === selectedRfpId
    )[0]
    Compliance_Responses__c =
      Compliance_Responses__c || ''
    const selectedComplianceResponses = Compliance_Responses__c.split(
      ';'
    )
    helper.fireEvent('rm_rfp_action', {
      type: 'getQuestions',
      payload: { selectedRfpId }
    })
    helper.fireEvent('rm_rfp_action', {
      type: 'updateState',
      payload: { selectedRfpId, selectedComplianceResponses }
    })
  },

  showSettingsModal: function(component, event, helper) {
    const settingsModal = component.find('settings-modal')
    settingsModal.openModal()
  },
  showSearch: function(component, event, helper) {
    event.stopPropagation()
    const searchModal = component.find('search-modal')
    searchModal.toggleOpen()
  },

  collapseList: function(component, event, helper) {
    helper.collapseList(component)
  },

  changeStatusFilter: function(component, event, helper) {
    const { questions, userId } = component.get('v.state')
    const filters = component
      .find('filter')
      .map(f => (f.get('v.checked') ? f.get('v.name') : null))
      .filter(f => f)
    const accordionItems = component.find('accordionItemContainer')

    questions.forEach((q, i) => {
      if (filters.includes('myQuestions')) {
        // the 'or' status contiditions plus 'and' condition of ownership
        if (
          (filters.includes(q.Status__c) ||
            filters.length === 1) &&
          q.Assignee__c === userId
        ) {
          $A.util.removeClass(accordionItems[i], 'hidden')
        } else {
          $A.util.addClass(accordionItems[i], 'hidden')
        }
        // only the 'or' conditions
      } else if (
        filters.includes(q.Status__c) ||
        !filters.length
      ) {
        $A.util.removeClass(accordionItems[i], 'hidden')
      } else {
        $A.util.addClass(accordionItems[i], 'hidden')
      }
    })
  }
})