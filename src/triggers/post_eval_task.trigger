trigger post_eval_task on Task (before insert) {
    
    RecordType r_type = [SELECT id, Name FROM RecordType WHERE Name = 'Idea Re-evaluation'];
    
    for(Task t :Trigger.new){
        
        if(t.Subject == 'Post Evaluation'){
            t.RecordTypeId = r_type.Id;
        }
    
    }
}