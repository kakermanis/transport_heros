public class SetDefaultEntitlement {
    @InvocableMethod(label='Set Default Entitlement' description='Sets the Entitlement of a Case to the one named Default Entitlement')
    public static void setEntitlement(List<ID> caseIds) {
        Entitlement entitlementObj = [SELECT ID from Entitlement Where Name =:'Default Entitlement'];
        if (entitlementObj != null){
            List<Case> caseList = [SELECT Id, EntitlementId FROM Case WHERE Id in :caseIds];
            for (Case caseObj : caseList) {
				caseObj.EntitlementId = entitlementObj.Id;
            }
            update caseList;
        }
    }
}