global class CampfireFindLiveContact {
    @InvocableMethod(label='Campfire - Find Contact By Session Id' description='Returns a Contact for the specified Session Id')
    global static List<Contact> findLiveChatTranscriptFromSessionId(List<String> requests) 
    {
        List<Contact> results = new List<Contact>();
        for (string request : requests)
        {
            if (String.IsNotBlank(request))
            {
                LiveChatTranscript newLiveChatTranscript = findLiveChatTranscriptFromSessionId(request);
                if (newLiveChatTranscript != null && string.isNotBlank(newLiveChatTranscript.Id) && string.isNotBlank(newLiveChatTranscript.ContactId))
                {
					results = [SELECT ID, FirstName, LastName FROM CONTACT Where ID = :newLiveChatTranscript.ContactId];                    
                }
            }      
        }
        if (results.size() == 0) 
        {
            return new List<Contact>{new Contact()};
        }
        return results;
    }
    
    public static LiveChatTranscript findLiveChatTranscriptFromSessionId(string request) 
    {
        LIST<LiveChatTranscript> newLiveChatTranscript = [SELECT Id, ContactId FROM LiveChatTranscript WHERE ChatKey =: request LIMIT 1];      
        
        if (newLiveChatTranscript != null && newLiveChatTranscript.size() > 0) {
            return newLiveChatTranscript[0];
        } else {
            return new LiveChatTranscript();
        }
    }
}