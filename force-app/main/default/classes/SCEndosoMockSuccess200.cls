@isTest
global with sharing class SCEndosoMockSuccess200 implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        //TODO el body siguiente habría que reemplazarlo por una response 200 REAL
        res.setBody('{"SummaryDetail":{"AddressDescription":null,"AddressType":null,"ChangeInCost":null,"CommissionBroker":null,"CommissionOrg":null,"CommissionProd":null,"EffectiveDate":"0001-01-01T00:00:00Z","Error":null,"Insured":null,"JobNumberLabel":null,"JobRenewalNumber":null,"NetPremium":null,"OverrideCommissionBroker":null,"OverrideCommissionOrg":null,"OverrideCommissionProd":null,"PaymentDate":"0001-01-01T00:00:00Z","PaymentFees":0,"PaymentMethod":null,"PeriodEnd":"0001-01-01T00:00:00Z","PeriodStart":"0001-01-01T00:00:00Z","PolicyPeriodId":null,"PolicyTerm":null,"Taxes":null,"TotalCommission":null,"TotalCommissionOrg":null,"TotalCost":null,"TotalPremium":null,"TransactionDescription":null,"UWCompany":null,"Validity":null,"BranchNumber":0,"ProductOfferingCALine":null,"DeductibleType":null,"DirectDeductible":null,"DeductiblePercentage":null,"TelefonoFijo":null,"TelefonoCelular":null,"Email":null,"DireccionPapeleria":null,"InstallmentPlan":null},"HasError":false,"HasWarning":false,"HasInformation":true,"Messages":[{"NombreServicio":"","VersionServicio":"","Description":"Ok","MessageBeautiful":"Información de pago actualizada","StackTrace":null,"ErrorLevel":0}]}');
        res.setStatusCode(200);
        return res;
    }
}