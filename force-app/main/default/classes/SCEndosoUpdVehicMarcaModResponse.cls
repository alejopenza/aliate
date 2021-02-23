public class SCEndosoUpdVehicMarcaModResponse {

	public class SummaryDetail {
		public String AddressDescription {get;set;} 
		public AddressType AddressType {get;set;} 
		public ChangeInCost ChangeInCost {get;set;} 
		public ChangeInCost CommissionBroker {get;set;} 
		public ChangeInCost CommissionOrg {get;set;} 
		public ChangeInCost CommissionProd {get;set;} 
		public String EffectiveDate {get;set;} 
		public Object Error {get;set;} 
		public String Insured {get;set;} 
		public String JobNumberLabel {get;set;} 
		public String JobRenewalNumber {get;set;} 
		public NetPremium NetPremium {get;set;} 
		public ChangeInCost OverrideCommissionBroker {get;set;} 
		public ChangeInCost OverrideCommissionOrg {get;set;} 
		public ChangeInCost OverrideCommissionProd {get;set;} 
		public String PaymentDate {get;set;} 
		public Integer PaymentFees {get;set;} 
		public AddressType PaymentMethod {get;set;} 
		public String PeriodEnd {get;set;} 
		public String PeriodStart {get;set;} 
		public String PolicyPeriodId {get;set;} 
		public PolicyTerm PolicyTerm {get;set;} 
		public NetPremium Taxes {get;set;} 
		public ChangeInCost TotalCommission {get;set;} 
		public ChangeInCost TotalCommissionOrg {get;set;} 
		public ChangeInCost TotalCost {get;set;} 
		public NetPremium TotalPremium {get;set;} 
		public Object TransactionDescription {get;set;} 
		public Object UWCompany {get;set;} 
		public String Validity {get;set;} 
		public Integer BranchNumber {get;set;} 
		public String ProductOfferingCALine {get;set;} 
		public String DeductibleType {get;set;} 
		public Object DirectDeductible {get;set;} 
		public Object DeductiblePercentage {get;set;} 

		public SummaryDetail(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AddressDescription') {
							AddressDescription = parser.getText();
						} else if (text == 'AddressType') {
							AddressType = new AddressType(parser);
						} else if (text == 'ChangeInCost') {
							ChangeInCost = new ChangeInCost(parser);
						} else if (text == 'CommissionBroker') {
							CommissionBroker = new ChangeInCost(parser);
						} else if (text == 'CommissionOrg') {
							CommissionOrg = new ChangeInCost(parser);
						} else if (text == 'CommissionProd') {
							CommissionProd = new ChangeInCost(parser);
						} else if (text == 'EffectiveDate') {
							EffectiveDate = parser.getText();
						} else if (text == 'Error') {
							Error = parser.readValueAs(Object.class);
						} else if (text == 'Insured') {
							Insured = parser.getText();
						} else if (text == 'JobNumberLabel') {
							JobNumberLabel = parser.getText();
						} else if (text == 'JobRenewalNumber') {
							JobRenewalNumber = parser.getText();
						} else if (text == 'NetPremium') {
							NetPremium = new NetPremium(parser);
						} else if (text == 'OverrideCommissionBroker') {
							OverrideCommissionBroker = new ChangeInCost(parser);
						} else if (text == 'OverrideCommissionOrg') {
							OverrideCommissionOrg = new ChangeInCost(parser);
						} else if (text == 'OverrideCommissionProd') {
							OverrideCommissionProd = new ChangeInCost(parser);
						} else if (text == 'PaymentDate') {
							PaymentDate = parser.getText();
						} else if (text == 'PaymentFees') {
							PaymentFees = parser.getIntegerValue();
						} else if (text == 'PaymentMethod') {
							PaymentMethod = new AddressType(parser);
						} else if (text == 'PeriodEnd') {
							PeriodEnd = parser.getText();
						} else if (text == 'PeriodStart') {
							PeriodStart = parser.getText();
						} else if (text == 'PolicyPeriodId') {
							PolicyPeriodId = parser.getText();
						} else if (text == 'PolicyTerm') {
							PolicyTerm = new PolicyTerm(parser);
						} else if (text == 'Taxes') {
							Taxes = new NetPremium(parser);
						} else if (text == 'TotalCommission') {
							TotalCommission = new ChangeInCost(parser);
						} else if (text == 'TotalCommissionOrg') {
							TotalCommissionOrg = new ChangeInCost(parser);
						} else if (text == 'TotalCost') {
							TotalCost = new ChangeInCost(parser);
						} else if (text == 'TotalPremium') {
							TotalPremium = new NetPremium(parser);
						} else if (text == 'TransactionDescription') {
							TransactionDescription = parser.readValueAs(Object.class);
						} else if (text == 'UWCompany') {
							UWCompany = parser.readValueAs(Object.class);
						} else if (text == 'Validity') {
							Validity = parser.getText();
						} else if (text == 'BranchNumber') {
							BranchNumber = parser.getIntegerValue();
						} else if (text == 'ProductOfferingCALine') {
							ProductOfferingCALine = parser.getText();
						} else if (text == 'DeductibleType') {
							DeductibleType = parser.getText();
						} else if (text == 'DirectDeductible') {
							DirectDeductible = parser.readValueAs(Object.class);
						} else if (text == 'DeductiblePercentage') {
							DeductiblePercentage = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'SummaryDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ChangeInCost {
		public Integer Amount {get;set;} 
		public String Currency2 {get;set;} 
		public String Description {get;set;} 

		public ChangeInCost(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Amount') {
							Amount = parser.getIntegerValue();
						} else if (text == 'Currency') {
							Currency2 = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ChangeInCost consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PolicyTerm {
		public String Description {get;set;} 
		public String IdentificationCode {get;set;} 
		public Boolean Selected {get;set;} 

		public PolicyTerm(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'IdentificationCode') {
							IdentificationCode = parser.getText();
						} else if (text == 'Selected') {
							Selected = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'PolicyTerm consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Messages {
		public String NombreServicio {get;set;} 
		public String VersionServicio {get;set;} 
		public String Description {get;set;} 
		public String MessageBeautiful {get;set;} 
		public Object StackTrace {get;set;} 
		public Integer ErrorLevel {get;set;} 

		public Messages(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'NombreServicio') {
							NombreServicio = parser.getText();
						} else if (text == 'VersionServicio') {
							VersionServicio = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'MessageBeautiful') {
							MessageBeautiful = parser.getText();
						} else if (text == 'StackTrace') {
							StackTrace = parser.readValueAs(Object.class);
						} else if (text == 'ErrorLevel') {
							ErrorLevel = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Messages consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class AddressType {
		public String Code {get;set;} 
		public String Description {get;set;} 

		public AddressType(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Code') {
							Code = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AddressType consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public SummaryDetail SummaryDetail {get;set;} 
	public Boolean HasError {get;set;} 
	public Boolean HasWarning {get;set;} 
	public Boolean HasInformation {get;set;} 
	public List<Messages> Messages {get;set;} 

	public SCEndosoUpdVehicMarcaModResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'SummaryDetail') {
						SummaryDetail = new SummaryDetail(parser);
					} else if (text == 'HasError') {
						HasError = parser.getBooleanValue();
					} else if (text == 'HasWarning') {
						HasWarning = parser.getBooleanValue();
					} else if (text == 'HasInformation') {
						HasInformation = parser.getBooleanValue();
					} else if (text == 'Messages') {
						Messages = arrayOfMessages(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SCEndosoUpdVehicMarcaModResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class NetPremium {
		public Double Amount {get;set;} 
		public String Currency2 {get;set;} 
		public String Description {get;set;} 

		public NetPremium(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Amount') {
							Amount = parser.getDoubleValue();
						} else if (text == 'Currency') {
							Currency2 = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'NetPremium consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static SCEndosoUpdVehicMarcaModResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCEndosoUpdVehicMarcaModResponse(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	

    private static List<Messages> arrayOfMessages(System.JSONParser p) {
        List<Messages> res = new List<Messages>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Messages(p));
        }
        return res;
    }
}