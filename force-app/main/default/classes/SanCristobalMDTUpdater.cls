public with sharing class SanCristobalMDTUpdater {
    public SanCristobalMDTUpdater() {

    }

    public static HttpRequest setRequest(Credencial__mdt credencial, String method){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(credencial.Url__c);
        req.setMethod(method);
        req.setTimeout(16000);
        req.setHeader('content-type','application/Json');
        req.setHeader('USERNAME', credencial.User__c);
        req.setHeader('PASS', credencial.Clave__c);
        return req;
    }

    public static void updateTermType(){
        Http h = new Http();
        Credencial__mdt credencial = [
            SELECT Url__c, User__c, Clave__c
            FROM Credencial__mdt
            WHERE Label = 'GetTermType'
        ];
        HttpResponse res = h.send(setRequest(credencial, 'GET'));
        system.debug(res.getBody());

        GetTermTypeResponse response = GetTermTypeResponse.parse(res.getBody());
        system.debug(response);

        List<Term_Type__c> termTypes = new List<Term_Type__c>();
        for(GetTermTypeResponse.Values value : response.Values){
            Term_Type__c termType = new Term_Type__c();
            termType.Name = value.Name;
            termType.Name__c = value.Name;
            termType.Description__c = value.Description;
            termType.Code__c = value.Code;
            termType.Retired__c = value.Retired;
            termTypes.add(termType);
        }
        upsert termTypes Code__c;
    }

    public static void updateAccountPaymentMethod() {

        Http h = new Http();
        Credencial__mdt credencial = [
            SELECT Url__c, User__c, Clave__c
            FROM Credencial__mdt
            WHERE Label = 'AccountPaymentMethod'
        ];
        HttpResponse res = h.send(setRequest(credencial, 'GET'));
        system.debug(res.getBody());

        GetAccountPaymentMethod response = GetAccountPaymentMethod.parse(res.getBody());
        system.debug(response);

        List<PaymentMethodCodes__c> paymentMethods = new List<PaymentMethodCodes__c>();
        for(GetAccountPaymentMethod.Values value : response.Values){
            PaymentMethodCodes__c paymentMethod = new PaymentMethodCodes__c();
            paymentMethod.Name = value.Name;
            paymentMethod.Name__c = value.Name;
            paymentMethod.Description__c = value.Description;
            paymentMethod.Code__c = value.Code;
            paymentMethod.Retired__c = value.Retired;
            paymentMethods.add(paymentMethod);
        }
        upsert paymentMethods Code__c;
    }

    public static void updateUsage(){
        Http h = new Http();
        Credencial__mdt credencial = [
            SELECT Url__c, User__c, Clave__c
            FROM Credencial__mdt
            WHERE Label = 'Usage'
        ];
        HttpResponse res = h.send(setRequest(credencial, 'GET'));
        system.debug(res.getBody());

        GetUsageResponse response = GetUsageResponse.parse(res.getBody());
        system.debug(response);

        List<Usage__c> usages = new List<Usage__c>();
        Integer nameIndex = 0;
        for(GetUsageResponse.Values value : response.Values){
            Usage__c usage = new Usage__c();
            usage.Name = String.valueOf(nameIndex);
            usage.Name__c = value.Name;
            usage.Description__c = value.Description;
            usage.Code__c = value.Code;
            usage.Retired__c = value.Retired;
            usages.add(usage);
            nameIndex++;
        }
        upsert usages Code__c;
    }

    public static void updateAutomaticAdjust(){
        Http h = new Http();
        Credencial__mdt credencial = [
            SELECT Url__c, User__c, Clave__c
            FROM Credencial__mdt
            WHERE Label = 'GetAutomaticAdjust'
        ];
        HttpResponse res = h.send(setRequest(credencial, 'GET'));
        system.debug(res.getBody());

        GetAutomaticAdjustResponse response = GetAutomaticAdjustResponse.parse(res.getBody());
        system.debug(response);

        List<AutomaticAdjust__c> automaticAdjusts = new List<AutomaticAdjust__c>();
        for(GetAutomaticAdjustResponse.Values value : response.Values){
            AutomaticAdjust__c automaticAdjust = new AutomaticAdjust__c();
            automaticAdjust.Name = value.Name;
            automaticAdjust.Name__c = value.Name;
            automaticAdjust.Description__c = value.Description;
            automaticAdjust.Code__c = value.Code;
            automaticAdjust.Retired__c = value.Retired;
            automaticAdjusts.add(automaticAdjust);
        }
        upsert automaticAdjusts Code__c;
    }

    public static void updateCategory(){
        Http h = new Http();
        Credencial__mdt credencial = [
            SELECT Url__c, User__c, Clave__c
            FROM Credencial__mdt
            WHERE Label = 'GetCategory'
        ];
        HttpResponse res = h.send(setRequest(credencial, 'GET'));
        system.debug(res.getBody());

        GetCategoryResponse response = GetCategoryResponse.parse(res.getBody());
        system.debug(response);

        List<Category__c> categories = new List<Category__c>();
        for(GetCategoryResponse.Values value : response.Values){
            Category__c category = new Category__c();
            category.Name = value.Name;
            category.Name__c = value.Name;
            category.Description__c = value.Description;
            category.Code__c = value.Code;
            category.Retired__c = value.Retired;
            categories.add(category);
        }
        upsert categories Code__c;
    }

    public static void updateAllValidProductOffering(){
        Http h = new Http();
        Credencial__mdt credencial = [
            SELECT Url__c, User__c, Clave__c
            FROM Credencial__mdt
            WHERE Label = 'GetAllValidProductOffering'
        ];
        HttpResponse res = h.send(setRequest(credencial, 'GET'));
        system.debug(res.getBody());

        GetValidProductOfferingResponse response = GetValidProductOfferingResponse.parse(res.getBody());
        system.debug(response);

        List<AllValidProductOffering__c> allValidProductOfferings = new List<AllValidProductOffering__c>();
        for(GetValidProductOfferingResponse.Values value : response.Values){
            AllValidProductOffering__c validProductOffering = new AllValidProductOffering__c();
            validProductOffering.Name = value.Name;
            validProductOffering.Name__c = value.Name;
            validProductOffering.Description__c = value.Description;
            validProductOffering.Code__c = value.Code;
            validProductOffering.Retired__c = value.Retired;
            allValidProductOfferings.add(validProductOffering);
        }
        upsert allValidProductOfferings Code__c;
    }

}