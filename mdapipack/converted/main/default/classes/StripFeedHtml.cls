global class StripFeedHtml {

    @InvocableMethod (label='Strip Feed Html' description='Strip Html from Feed Item and store it in custom field on Case')
    global static void StripFeedHtml(List <Request> req) {
        List <FeedItem> f = [SELECT Id, Body, ParentId from FeedItem WHERE Id = :req[0].Id ];
        System.debug ('Strip Feed Html about to try to load case for Chatter Post ID ' + req[0].Id);
        try {
            Case c = [SELECT LastFeedItemPlain__c, Id from Case WHERE Id = :f[0].ParentId ];
			String plainBody = f[0].body.stripHtmlTags();
    	    System.debug ('Strip Feed Html figures plain body as ' + plainBody);
            c.LastFeedItemPlain__c = plainBody;
	        update c;
            System.debug('Case should be updated');
        } catch (Exception ex) {
            System.debug (ex);
        }
    }
    
    global class Request {
        @invocableVariable (required=true)
        global String Id;
    }
}