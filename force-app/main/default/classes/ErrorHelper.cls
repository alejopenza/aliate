public with sharing class ErrorHelper {
    public static boolean LogError(Exception e) {
        try{
            Error__c error = new Error__c();
            error.Stack_Trace__c = e.getStackTraceString();
            insert error;
            return true;
        }catch(Exception ex){
            return false;
        }
    }
}