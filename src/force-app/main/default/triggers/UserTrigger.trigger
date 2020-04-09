trigger UserTrigger on User (after delete, after insert, after undelete, after update) {
    
    //Handles all user triggers
    
    if ((trigger.isInsert || trigger.isUpdate) && trigger.isAfter){
        
        Set<Id> userIds = new Set<Id>();
        
        for (User u : trigger.new) {
            
            //Neils edits to discuss with Kathryn
            Profile p = [Select Id, Name FROM Profile Where ID =: u.ProfileId];
            System.debug('Profile is ' + p);
            if (p!=null && p.Name == 'Employee Standard User'){
                // Add the user id to the set of ids
                userIds.add(u.Id);
            }
			
            
            // Add the user id to the set of ids
            //userIds.add(u.Id);
        }
        if (!System.isFuture() && !System.isBatch()) {
            //upsert contact records with the changes in user records
            UpsertUserContact.execute(userIds);
        }
        
    }
}