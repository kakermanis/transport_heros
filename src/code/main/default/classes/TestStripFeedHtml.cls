@isTest

global class TestStripFeedHtml {

    public static void validateStripFeedHtml() {
        
        Case c = new Case();
        insert c;
        
        FeedItem f = new FeedItem (Body = '<p>Hello World</p>', ParentId = c.Id);
        
        insert f;
        
        c = [SELECT Id, LastFeedItemPlain__c FROM CASE Where Id = :c.Id];
        
        System.Assert (c.LastFeedItemPlain__c == 'Hello World');
    }
}