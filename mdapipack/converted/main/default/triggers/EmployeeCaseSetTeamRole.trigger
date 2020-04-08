trigger EmployeeCaseSetTeamRole on Case (after insert) {
    
    List<CaseTeamRole> roleList = [select Id from CaseTeamRole where Name = 'Employee' limit 1];
    for (Case c : Trigger.New){
        if (c.Origin == 'Web'){
            List<Contact> contactList = [Select Id from Contact where User__c = :UserInfo.getUserId()];
            if (contactList.size()>0){
                if (roleList.size()>0){
                    CaseTeamRole role = roleList[0];
                    CaseTeamMember ctm = new CaseTeamMember();
                    ctm.ParentId = c.Id;
                    ctm.MemberId = UserInfo.getUserId();
                    ctm.TeamRoleId = role.Id;
                    insert ctm;
                }           
            }                        
        }       
    }
}