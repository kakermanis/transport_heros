public with sharing class ReturnToWorkController {

    public class RTWResponseWrapper {
      @AuraEnabled
      public Integer daysLeft;

      @AuraEnabled
      public Integer percentComplete;

    }

    @AuraEnabled(Cacheable=true)
    public static RTWResponseWrapper getReturnToWorkDays(ID userId, ID recordID, String objectName) {
        RTWResponseWrapper responseWrapper = new RTWResponseWrapper();
        Contact worker = null;

        System.debug('ReturnToWorkController - inside getReturnToWorkDays');

        // If record ID is populated check if it's a contact or Person Account
        //Contact =
        //Account = 001
        if (objectName != null) {
            System.debug('ReturnToWorkController - objectname was provided - this is a record page');
          if (objectName == 'Account') {
            worker = [SELECT Estimated_Return_to_Work_Date__c, Work_Stop_Date__c FROM Contact where accountId = :recordID];
          } else if (objectName == 'Contact'){
            worker = [SELECT Estimated_Return_to_Work_Date__c, Work_Stop_Date__c FROM Contact where ID = :recordID];
          } else {
            System.debug('Was expecting either a contact or account so I cannot process this record');
          }
        } else {
          //This is likely in a community page so look up based on contact linked to current User
          System.debug('ReturnToWorkController - This is a community page - finding contact based on currently logged in user...');
          worker = getWorkerForUser(userID);
        }

        responseWrapper = createResponseWrapper(worker);
        return responseWrapper;
    }



    @AuraEnabled(Cacheable=true)
    public static RTWResponseWrapper getReturnToWorkDaysCommunities(ID userId) {
        RTWResponseWrapper responseWrapper = new RTWResponseWrapper();
        Contact worker = null;
        User curUser = null;

        System.debug('ReturnToWorkController - inside getReturnToWorkDaysCommunities');

        worker = getWorkerForUser(userID);

        if (worker != null) {
            responseWrapper = createResponseWrapper(worker);
        }

        return responseWrapper;
    }


    private static Contact getWorkerForUser(ID userId) {
      Contact worker = null;
      User curUser = null;
      /* Three cases
        1. External Community User - user.ContactID populated
        2. Internal User - Person Account - Account.user__pc = userID
        3. Internal User - Contact - Contact.user__c = userID
      */

      try {
        curUser = [SELECT ContactID from User where ID = :userId];
        worker = [SELECT Estimated_Return_to_Work_Date__c, Work_Stop_Date__c FROM Contact where ID = :curUser.ContactID];
      } catch (Exception ex) {
        System.debug('The ContactID field on the user record either was not there or nothing found. Likely an internal user');
        curUser = null;
      }

      if (curUser == null) {
          System.debug('First query to find a user contact is null so this likey an internal user');
          worker = [SELECT Estimated_Return_to_Work_Date__c, Work_Stop_Date__c FROM Contact where User__c = :userId];
      }

      return worker;
    }

    private static RTWResponseWrapper createResponseWrapper (Contact worker) {
      RTWResponseWrapper responseWrapper = new RTWResponseWrapper();
      Date todaysDate = system.today();
      Integer daysLeft;
      Integer percentageComplete;

      //find out how many days left between today and return to work date...
      daysLeft = todaysDate.daysBetween(worker.Estimated_Return_to_Work_Date__c);
      if (daysLeft < 0) {
          responseWrapper.daysLeft = 0;
          responseWrapper.percentComplete = 100;
      } else {
        //
        responseWrapper.daysLeft = daysLeft;
        Integer totalDays = worker.Work_Stop_Date__c.daysBetween(worker.Estimated_Return_to_Work_Date__c);
        Integer elapsedDays = totalDays - daysLeft;
        Decimal percentComplete = (Decimal.valueOf(elapsedDays) / Decimal.valueOf(totalDays)) * 100;

        System.debug('getReturnToWorkDaysCommunities - elapsedDays: ' + elapsedDays + ' Total days: ' + totalDays + ' percentComplete: ' + percentComplete);

        responseWrapper.percentComplete = Integer.valueOf(percentComplete);
      }

      return responseWrapper;
    }


}