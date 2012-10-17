public with sharing class QuestionnaireExtension 
{
        private ApexPages.StandardController controller;
        private string c;
        private string id;
        private DmlException a;                                   
    
    public QuestionnaireExtension(ApexPages.StandardController controller) 
    {
        this.controller = controller;
    }
    //Previous Methods are as follows:
    public PageReference Previous_on_page1to2() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage1.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    } 
    public PageReference Previous_on_page2() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage1to2.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    } 
    public PageReference Previous_on_page3() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage2.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference Previous_on_page4() 
    {    
        controller.save();       
        PageReference pageRef = new PageReference(Page.QuestionnairePage3.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }    
    public PageReference Previous_on_page5() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage4.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }   
    public PageReference Previous_on_page6() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage5.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }   
    public PageReference Previous_on_page7() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage6.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }  
    public PageReference Previous_on_page8() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage7.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }  
    public PageReference Previous_on_page9() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage8.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }  
    public PageReference Previous_on_page10() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage9.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }     

    //Save Methods are as follows:
    public PageReference save() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage1to2.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference savepage1to2() 
    {
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage2.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference savePage2() 
    {    
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage3.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference savePage3() 
    {    
        controller.save();  
        PageReference pageRef = new PageReference(Page.QuestionnairePage4.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference savePage4() 
    {
        controller.save();
        PageReference pageRef = new PageReference(Page.QuestionnairePage5.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
     }           
    public PageReference savePage5() 
    {
        controller.save();   
        PageReference pageRef = new PageReference(Page.QuestionnairePage6.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference savePage6() 
    {              
        controller.save();        
        PageReference pageRef = new PageReference(Page.QuestionnairePage7.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;    
    }         
    public PageReference savePage7() 
    {
        controller.save();   
        PageReference pageRef = new PageReference(Page.QuestionnairePage8.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }    
    public PageReference savePage8() 
    {
        controller.save();   
        PageReference pageRef = new PageReference(Page.QuestionnairePage9.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference savePage9() 
    {
        controller.save();
        PageReference pageRef = new PageReference(Page.QuestionnairePage10.getURL() );
        pageRef.getParameters().put('id',controller.getid());
        pageRef.setRedirect(true);
        return pageRef;  
    }
 }