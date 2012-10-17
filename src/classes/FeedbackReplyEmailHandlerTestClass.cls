// Copyright 2010, Doug Merrett - Sales Engineering, Salesforce.com Inc.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following
// conditions are met:
//
// - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
//   disclaimer in the documentation and/or other materials provided with the distribution.
// - Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived
//   from this software without specific prior written permission. 
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

@isTest
private class FeedbackReplyEmailHandlerTestClass
{
    static testMethod void testFeedbackReplyEmailHandler ()
    {
        // Create a new email and envelope object
        Messaging.InboundEmail                email = new Messaging.InboundEmail ();
        Messaging.InboundEnvelope             env   = new Messaging.InboundEnvelope ();
        Messaging.InboundEmail.TextAttachment att   = new Messaging.InboundEmail.TextAttachment ();
        
        // Create a new test feedback record and insert it in the Test Method        
        Feedback__c F = new Feedback__c (Subject__c           = 'test 1 2 3',
                                         Customer_Comments__c = 'test 1 2 3',
                                         First_Name__c        = 'test',
                                         Last_Name__c         = 'person',
                                         Email__c             = 'invalid@email.address',
                                         Source__c            = 'Web');
        insert F;
        F = [select Name, Subject__c from Feedback__c where Id = :F.Id];  // refind so the next line works...
        
        system.debug ('Feedback Name is ' + F.Name + ' -- Subject is ' + F.Subject__c);
        
        // Fill in the email details
        att.body              = 'This is a text attachment';
        att.fileName          = 'attachment.txt';
        email.subject         = 'Test Case ' + F.Name;  // Add the Feedback reference to the email subject
        email.fromName        = 'test person';
        email.fromAddress     = 'invalid@email.address';
        email.plainTextBody   = 'This is plain text';
        email.htmlBody        = '<b>This is html body</b>';
        email.textAttachments = new Messaging.InboundEmail.TextAttachment [] {att};  // Create a list of one element
        env.toAddress         = 'xxx@yyy.zzz';
        
        // call the class and test it with the data in the testMethod
        FeedbackReplyEmailHandler FREH = new FeedbackReplyEmailHandler ();
        FREH.handleInboundEmail (email, env);      
        
        // Change the email to not match a feedback record and go again
        email.subject         = 'Test Case does not match any';  // missing Feedback reference
        FREH.handleInboundEmail (email, env);      

                               
    }    
}