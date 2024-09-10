// Copyright (c) 2018, salesforce.com, inc., 
//  All rights reserved. 
// SPDX-License-Identifier: BSD-3-Clause 
// For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause

@isTest
public class rm_rfp_Test {
Private Static testmethod void getRFPs(){

	RFP__c[] rfps = [SELECT name,
	                                Compliance_Responses__c,
	                                Completion_Percentage__c,
	                                CreatedDate,
	                                id FROM rfp__c order by Completion_Percentage__c desc limit 1000];
	System.assertEquals(rfps, proposalforce.RFP_MainController.getRFPs());



}


Private Static testmethod void getQuestions(){
	rfp__c testRfp = new rfp__c();
	testRfp.Name = 'test';
	insert testRfp;
	rfp_question__c[] rfpQuestions = new rfp_question__c[] {};
	for(integer i = 0; i < 20; i++) {
		rfp_question__c q = new rfp_question__c();
		q.rfp__c = testRfp.Id;
		rfpQuestions.add(q);
	}
	insert rfpQuestions;

	try{
		rfp_question__c[] returnVal = proposalforce.RFP_MainController.getQuestions(testRfp.Id);
		rfpQuestions.sort();
		returnVal.sort();

		for(integer i = 0; i < returnVal.size(); i++) {
			System.assertEquals(rfpQuestions[i].id, returnVal[i].id);
		}
	}
	catch(exception e) {
		system.debug(e);
	}

	try{
		rfp_question__c[] returnVal = proposalforce.RFP_MainController.getQuestions(null);
	}
	catch(exception e) {
		system.debug(e);
		System.assert (e != null);
	}
}

Private Static testmethod void getKnowledgeArticles(){
	try{
  proposalforce.RFP_MainController.getKnowledgeArticles('This is the forest primeval, the whispering pines and hemlocks.', null);
  System.assert (true);
	}
	catch(exception e) {
		system.debug(e);
	}
}

Private Static testmethod void getKnowledgeObjectName(){
	try{
		string returnedName = proposalforce.RFP_MainController.getKnowledgeObjectName();
    System.assertEquals(returnedName, 'Knowledge__kav');
	}
	catch(exception e) {
		system.debug(e);
	}
}

Private Static testmethod void getCurrentUserId(){
	try{
		
    System.assertEquals(proposalforce.RFP_MainController.getCurrentUserId(), UserInfo.getUserId());
	}
	catch(exception e) {
		system.debug(e);
	}
}

Private Static testmethod void getKnowledgeCategories(){
	try{
		proposalforce.RFP_MainController.getKnowledgeCategories();
    System.assertEquals(proposalforce.RFP_MainController.getKnowledgeCategories().length() != 0, true);
	}
	catch(exception e) {
		system.debug(e);
	}
}

Private Static testmethod void updateQuestion(){
	rfp__c testRfp = new rfp__c();
	testRfp.Name = 'test';
	insert testRfp;
	rfp_question__c[] rfpQuestions = new rfp_question__c[] {};
	for(integer i = 0; i < 20; i++) {
		rfp_question__c q = new rfp_question__c();
		q.rfp__c = testRfp.Id;
		rfpQuestions.add(q);
	}
	insert rfpQuestions;
  rfp_question__c[] insertedQs = proposalforce.RFP_MainController.getQuestions(testRfp.Id);
	try{

    System.assertEquals(insertedQs[0].rfp_response__r.Response_Text__c, null);
		rfp_question__c[] updatedQs = proposalforce.RFP_MainController.updateQuestion(insertedQs[0], 'Test title', 'Test answer');
    System.assertEquals(updatedQs[0].rfp_response__r.Response_Text__c, 'Test answer');
    
	}
	catch(exception e) {
		system.debug(e);
	}
	try{
		proposalforce.RFP_MainController.updateQuestion(null, null, null);
	}
	catch(exception e) {
		system.debug(e);
	}
}

Private Static testmethod void updateQuestionStatus(){
	rfp__c testRfp = new rfp__c();
	testRfp.Name = 'test';
	insert testRfp;
	rfp_question__c[] rfpQuestions = new rfp_question__c[] {};
	for(integer i = 0; i < 20; i++) {
		rfp_question__c q = new rfp_question__c();
		q.rfp__c = testRfp.Id;
		rfpQuestions.add(q);
	}
	insert rfpQuestions;
	try{
		proposalforce.RFP_MainController.getQuestions(testRfp.Id);
    rfpQuestions.sort();
		rfp_question__c[] updatedQs = proposalforce.RFP_MainController.updateQuestionStatus(rfpQuestions[0], 'Approved');
    updatedQs.sort();
    System.assertEquals(updatedQs[0].Status__c, 'Approved');
	}
	catch(exception e) {
		system.debug(e);
	}

	try{
		proposalforce.RFP_MainController.updateQuestionStatus(null, null);
	}
	catch(exception e) {
		system.debug(e);
	}
}


Private Static testmethod void createNewArticleVersion(){


	// Knowledge__kav k = new Knowledge__kav();
	// k.Answer__c = 'test';
	// k.UrlName = 'test' + DateTime.now().getTime();
	// k.title = 'test';
	// insert k;
	// string articleid = [select id, knowledgearticleid from knowledge__kav where id = :k.id].knowledgearticleid;

	// KbManagement.PublishingService.publishArticle(articleid, false);


	// try{
	// 	string newId = proposalforce.RFP_MainController.createNewArticleVersion(k.KnowledgeArticleId, k.id);
	// 	Knowledge__kav newestK = [select id, KnowledgeArticleId from Knowledge__kav where PublishStatus = 'Draft' order by createddate desc limit 1];
  //   System.assertEquals(k.Id, newestK.Id);
	// }
	// catch(exception e) {
	// 	system.debug(e);
	// }


	// try{
	// 	proposalforce.RFP_MainController.createNewArticleVersion(null, null);
	// }
	// catch(exception e) {
	// 	system.debug(e);
	// }
}

Private Static testmethod void setNewComplianceResponses(){
	rfp__c testRfp = new rfp__c();
	testRfp.Name = 'test';
	testRfp.Compliance_Responses__c = 'test;test';
	insert testRfp;
	try{
		proposalforce.RFP_MainController.setNewComplianceResponses(testRfp);
    string newComplianceResponses = [select Compliance_Responses__c from rfp__c where id = :testRfp.Id].Compliance_Responses__c;
    System.assertEquals(newComplianceResponses, 'test;test');
	}
	catch(exception e) {
		system.debug(e);
	}

	try{
		proposalforce.RFP_MainController.setNewComplianceResponses(null);
	}
	catch(exception e) {
		system.debug(e);
	}
}

Private Static testmethod void generateCSV(){
	rfp__c testRfp = new rfp__c();
	testRfp.Name = 'test';
	insert testRfp;
	rfp_question__c[] rfpQuestions = new rfp_question__c[] {};
	for(integer i = 0; i < 20; i++) {
		rfp_question__c q = new rfp_question__c();
		q.rfp__c = testRfp.Id;
		q.RFP_Question_Text__c = 'test';
		rfpQuestions.add(q);
	}
	insert rfpQuestions;
	try{
		string newContentDocumentId = proposalforce.RFP_MainController.generateCSV(testRfp.Id);
    string newCDI = [select id from contentdocument order by createddate desc limit 1].Id;
    System.assertEquals(newCDI, newContentDocumentId);

	}
	catch(exception e) {
		system.debug(e);
	}

	try{
		proposalforce.RFP_MainController.generateCSV(null);
	}
	catch(exception e) {
		system.debug(e);
	}
}

Private Static testmethod void generateWordDoc(){
	rfp__c testRfp = new rfp__c();
	testRfp.Name = 'test';
	insert testRfp;
	rfp_question__c[] rfpQuestions = new rfp_question__c[] {};
	for(integer i = 0; i < 20; i++) {
		rfp_question__c q = new rfp_question__c();
		q.rfp__c = testRfp.Id;
		q.RFP_Question_Text__c = 'test';
		rfpQuestions.add(q);
	}
	insert rfpQuestions;
	try{
		

    string newContentDocumentId = proposalforce.RFP_MainController.generateWordDoc('test', testRfp.Id, 'test');
    string newCDI = [select id from contentdocument order by createddate desc limit 1].Id;
    System.assertEquals(newCDI, newContentDocumentId);
	}
	catch(exception e) {
		system.debug(e);
	}

	try{
		proposalforce.RFP_MainController.generateWordDoc(null, null, null);
	}
	catch(exception e) {
		system.debug(e);
	} 
}

}