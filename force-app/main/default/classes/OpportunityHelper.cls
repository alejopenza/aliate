public class OpportunityHelper {
    public static void handleEndoso(Map<Id, Opportunity> oldMap, List<Opportunity> newMap){
        
        Id endosoRT = [
            SELECT ID
            FROM RecordType
            WHERE DeveloperName = 'Endoso'
            AND SobjectType = 'Opportunity'
        ].Id;
        
        List<Opportunity> endosoOpps = new List<Opportunity>();
        for(Opportunity opp : newMap){
            
        }
    }
}