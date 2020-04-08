public with sharing class TestApexController {



    public class JunkResponseWrapper {
      @AuraEnabled
      public Integer daysLeft;

      @AuraEnabled
      public Integer percentComplete;

    }

    @AuraEnabled(Cacheable=true)
    //public static JunkResponseWrapper getReturnToWorkDays(ID userId, ID recordID, String objectName) {
    public static JunkResponseWrapper getReturnToWorkDays(ID userId, String objectName) {
        JunkResponseWrapper responseWrapper = new JunkResponseWrapper();

        System.debug('TestApexController - inside getReturnToWorkDays');

        responseWrapper.daysLeft=100;
        responseWrapper.percentComplete=100;

        return responseWrapper;
    }

}