public with sharing class DriverCareSettingsHelper {

    private static DriverCareSettingsHelper instance = null;
    private static final String defaultRecordName = 'default';
    public Driver_Care_Settings__mdt customMetadata {get; private set;}


    private DriverCareSettingsHelper() {
      // TODO - query and get the custom metadata type and all it's fields...
      customMetadata = [SELECT Default_Return_to_work_days__c, SMS_Validation_RegEx__c FROM Driver_Care_Settings__mdt WHERE DeveloperName = :defaultRecordName];
    }

    public static DriverCareSettingsHelper getInstance() {
      if (instance == null) {
        instance = new DriverCareSettingsHelper();
      }

      return instance;
    }
}