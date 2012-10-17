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

global class FeedbackReplyEmailHandler implements Messaging.InboundEmailHandler
{
    global Messaging.InboundEmailResult handleInboundEmail (Messaging.inboundEmail email, Messaging.inboundEnvelope env)
    {
        // Initialise the Attachement list
        List <Attachment> attachments = new List <Attachment> ();
        Attachment attach;

        // Create an inboundEmailResult object for returning the result of the Apex Email Service
        Messaging.inboundEmailResult result = new Messaging.inboundEmailResult ();
        
        // Get the Feedback number from the end of the subject Line
        Feedback__c FB = null;
        String FBName  = 'invalid';  // This won't be found in the SOQL below if the split fails
        Boolean addPlainNote = false;
        String email_source = 'Email';
        String email_subject = '';
        Boolean isFax = false;
        
        if ((email.subject != null) && (email.subject.trim().length() > 0)) {
            
            system.debug('******* SUBJECT IS NOT EMPTY ***************');
            
            email_subject = email.subject;
            isFax = email_subject.toUpperCase().contains('FAX RECEIVED');
    
            List <String> SubjectSplit = email_subject.toUpperCase().split (' ', 0);
            if (SubjectSplit.size () != 0) {
                for (Integer i = 0; i < SubjectSplit.size (); i++) {
                    Boolean isFB = SubjectSplit[i].contains('FB-');
                    if (isFB == true) {
                        FBName = SubjectSplit[i];
                        integer pos = FBName.Indexof('FB-');
                        if (pos > -1) {
                            FBName = FBName.SubString(pos, pos + 9);
                        }
                    }
                }
                
            }
        }
        else {
            system.debug('******* SUBJECT IS EMPTY ***************');
            email_subject = 'No Subject';
        }
            
        system.debug ('subject FB number is ' + FBName);
        
        // Try to lookup the Feedback based on the email subject
        try
        {
            FB = [select Id, Name, OwnerId, Customer_Comments__c, Status__c from Feedback__c where Name = :FBName limit 1];
        }
        catch (QueryException e)  // No feedback record found
        {
        }
               
        // If there is a feedback record found
        if (FB != null)
        {
            // Record this in the activity history
            Task T = new Task (Status = 'Completed', Type = 'Email', WhatId = FB.Id, Priority = 'Normal', Subject = 'Reply Email received', ActivityDate = Date.Today ());
            try
            {
                insert T;
            }
            catch (Exception e)
            {
                system.debug ('Task Creation failed for Completed: ' + e);
            }
            
            // Add another one for the Owner to check this
            T = new Task (Status = 'Not Started', WhatId = FB.Id, Priority = 'High', Subject = 'Check new Customer Comments', OwnerId = FB.OwnerID, ActivityDate = Date.Today ());
            try
            {
                insert T;
            }
            catch (Exception e)
            {
                system.debug ('Task Creation failed for "check this": ' + e);
            }
                        
            // Add a note to the feedback comments to check the email in the attachments
            //String comments = FB.Customer_Comments__c;
            //FB.Customer_Comments__c = 'Email Received @ ' + String.valueOf (DateTime.now ()) + 
            //                          ' - See attachments for content\n\n------------\n\n' +
            //                          FB.Customer_Comments__c;
                         
            //if (email.plainTextBody != null && comments != null) {
            //    if (comments.length() + email.plainTextBody.length() < 32000) {
            //        FB.Customer_Comments__c  = comments + '\n' + email.plainTextBody;
            //    }
            //    else {
            //        addPlainNote = true;
            //    }
            //}  
            addPlainNote = true;
            
            Group queue = [Select g.Id From Group g where g.Name = 'Customer Experience Inbox' limit 1];
                                      
            // If it is a completed feedback, then mark it as reopened
            if (FB.Status__c == 'Completed')
            {
                FB.Status__c = 'ReOpened';
                FB.OwnerId   = queue.Id;  // Id of the Queue
            }
        }
        else
        // No feedback record found
        {
            
            // email_subject = 'Email - No FB';
            // email_subject = email.subject;
            if (email_subject.length() > 250) {
                email_subject = email_subject.substring(0, 250);
            }
            //String customer_comments = '';
            if (isFax) {
                email_source = 'Fax';
                email_subject = 'Fax Received';
            }
            String customer_comments = email_source + ' Received @ ' + String.valueOf (DateTime.now ()) + 
                                                         ' - See attachments for content';
            if (email.plainTextBody != null)
            {
                customer_comments = email.plainTextBody;
                if (customer_comments.length() > 32000) {
                    customer_comments = customer_comments.substring(0, 32000);
                    addPlainNote = true;
                }
            }
            
            List <String> EmailName = email.fromAddress.split ('@', 0);
            system.debug ('Email from address: ' + email.fromAddress);
            system.debug ('Email Name: ' + EmailName);
            FB = new Feedback__c (First_Name__c        = EmailName [0],
                                  Last_Name__c         = EmailName [0],
                                  eMail__c             = email.fromAddress,
                                  Source__c            = email_source,
                                  Subject__c           = email_subject,
                                  Customer_Comments__c = customer_comments);
        }

        
        // Save the Feedback record
        try
        {
            upsert FB;
        }
        catch (Exception e)
        {
            System.debug ('DML error with upsert FB: ' + e);
            result.success = false;
            return result;        
        }

        // Text Email Body
        if (email.plainTextBody != null)
        {
            String email_body = email.subject + '\n\n' + email.plainTextBody;
            if (addPlainNote || (email_body.length() > 32000)) {
                attach          = new Attachment();
                attach.parentId = FB.id;
                attach.body     = blob.valueOf (email_body);
                attach.name     = email_source + '-received.txt'; 
                attachments.add (attach);
           }
        }
        
        // HTML Email Body
        if (email.htmlBody != null)
        {
            attach          = new Attachment();
            attach.parentId = FB.id;
            attach.body     = blob.valueOf (email.subject + '\n' + email.htmlBody);
            attach.name     = 'HTML Email Body.html'; 
            attachments.add (attach);
        }
       
        // Add any attachments (text or binary) to the Feedback record
        if (email.binaryAttachments != null)
        {
            for (Messaging.InboundEmail.BinaryAttachment emailAttachment : email.binaryAttachments)
            {
                attach          = new Attachment();
                attach.parentId = FB.id;
                attach.body     = emailAttachment.body;
                attach.name     = emailAttachment.fileName; 
                attachments.add (attach);
            }
        }
        
        if (email.textAttachments != null)
        {
            for (Messaging.InboundEmail.TextAttachment emailAttachment : email.textAttachments)
            {
                attach          = new Attachment();
                attach.parentId = FB.id;
                attach.body     = blob.valueOf (emailAttachment.body);
                attach.name     = emailAttachment.fileName; 
                attachments.add (attach);
            }
        }
        
        // insert the attachments
        if (attachments.size () > 0)
        {
            try
            {
                insert attachments;
            }
            catch (DMLException e)
            {
                System.debug ('DML error with attachments: ' + e);
                result.success = false;
                return result;
            }    
        }

        // 
        // Set the result to true for the original inbound email and ...
        result.success = true;
        
        // ... return the result for the Apex Email Service
        return result;
    }
}