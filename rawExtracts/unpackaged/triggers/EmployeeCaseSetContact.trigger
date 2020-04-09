trigger EmployeeCaseSetContact on Case (before insert) {
    for (Case c : Trigger.New){
        if (c.Origin == 'Web'){
            List<Contact> contactList = [Select Id from Contact where User__c = :UserInfo.getUserId()];
            if (contactList.size()>0){
                Contact userContact = contactList[0];
                c.ContactId = userContact.Id;               
            }                        
        }
    }
}