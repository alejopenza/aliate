public class SanCristobalCotizacionResponse {

	public class Accesories {

		public Accesories(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Accesories consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ChangeInCost {
		public Double Amount {get;set;} 
		public String cCurrency {get;set;} 
		public String Description {get;set;} 

		public ChangeInCost(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Amount') {
							Amount = parser.getDoubleValue();
						} else if (text == 'Currency') {
							cCurrency = parser.getText();
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
	
	public class RiskLocation {
		public Object Block {get;set;} 
		public String City {get;set;} 
		public AddressType Country {get;set;} 
		public Object Department {get;set;} 
		public String DisplayName {get;set;} 
		public Object Floor {get;set;} 
		public Object LocationCode {get;set;} 
		public Object LocationName {get;set;} 
		public Object Phone {get;set;} 
		public AdditionalFuelType PhoneCountry {get;set;} 
		public String PostalCode {get;set;} 
		public String PublicID {get;set;} 
		public AddressType State {get;set;} 
		public Object Street {get;set;} 
		public Object StreetNumber {get;set;} 
		public Object Type_Z {get;set;} // in json: Type
		public Object policyPeriodID {get;set;} 
		public Object vehiclePublicID {get;set;} 

		public RiskLocation(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Block') {
							Block = parser.readValueAs(Object.class);
						} else if (text == 'City') {
							City = parser.getText();
						} else if (text == 'Country') {
							Country = new AddressType(parser);
						} else if (text == 'Department') {
							Department = parser.readValueAs(Object.class);
						} else if (text == 'DisplayName') {
							DisplayName = parser.getText();
						} else if (text == 'Floor') {
							Floor = parser.readValueAs(Object.class);
						} else if (text == 'LocationCode') {
							LocationCode = parser.readValueAs(Object.class);
						} else if (text == 'LocationName') {
							LocationName = parser.readValueAs(Object.class);
						} else if (text == 'Phone') {
							Phone = parser.readValueAs(Object.class);
						} else if (text == 'PhoneCountry') {
							PhoneCountry = new AdditionalFuelType(parser);
						} else if (text == 'PostalCode') {
							PostalCode = parser.getText();
						} else if (text == 'PublicID') {
							PublicID = parser.getText();
						} else if (text == 'State') {
							State = new AddressType(parser);
						} else if (text == 'Street') {
							Street = parser.readValueAs(Object.class);
						} else if (text == 'StreetNumber') {
							StreetNumber = parser.readValueAs(Object.class);
						} else if (text == 'Type') {
							Type_Z = parser.readValueAs(Object.class);
						} else if (text == 'policyPeriodID') {
							policyPeriodID = parser.readValueAs(Object.class);
						} else if (text == 'vehiclePublicID') {
							vehiclePublicID = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'RiskLocation consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public List<Summaries> Summaries {get;set;} 
	public Boolean HasError {get;set;} 
	public Boolean HasWarning {get;set;} 
	public Boolean HasInformation {get;set;} 
	public List<Accesories> Messages {get;set;} 

	public SanCristobalCotizacionResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Summaries') {
						Summaries = arrayOfSummaries(parser);
					} else if (text == 'HasError') {
						HasError = parser.getBooleanValue();
					} else if (text == 'HasWarning') {
						HasWarning = parser.getBooleanValue();
					} else if (text == 'HasInformation') {
						HasInformation = parser.getBooleanValue();
					} else if (text == 'Messages') {
						Messages = arrayOfAccesories(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SanCristobalCotizacionResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Summary {
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
		public ChangeInCost NetPremium {get;set;} 
		public ChangeInCost OverrideCommissionBroker {get;set;} 
		public ChangeInCost OverrideCommissionOrg {get;set;} 
		public ChangeInCost OverrideCommissionProd {get;set;} 
		public String PolicyPeriodId {get;set;} 
		public ChangeInCost Taxes {get;set;} 
		public ChangeInCost TotalCommission {get;set;} 
		public ChangeInCost TotalCommissionOrg {get;set;} 
		public ChangeInCost TotalCost {get;set;} 
		public ChangeInCost TotalPremium {get;set;} 
		public Object TransactionDescription {get;set;} 
		public Object UWCompany {get;set;} 
		public String Validity {get;set;} 
		public Integer BranchNumber {get;set;} 
		public String ProductOfferingCALine {get;set;} 
		public Object DeductibleType {get;set;} 
		public Object DirectDeductible {get;set;} 
		public Object DeductiblePercentage {get;set;} 
		public Object ReferenceCode {get;set;} 
		public String ClaveProducto {get;set;} 
		public Object TipoFranquicia {get;set;} 
		public Object ValorFranquicia {get;set;} 
		public String ClaveAmpliada {get;set;} 
		public Object DescripcionAmpliada {get;set;} 

		public Summary(JSONParser parser) {
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
							NetPremium = new ChangeInCost(parser);
						} else if (text == 'OverrideCommissionBroker') {
							OverrideCommissionBroker = new ChangeInCost(parser);
						} else if (text == 'OverrideCommissionOrg') {
							OverrideCommissionOrg = new ChangeInCost(parser);
						} else if (text == 'OverrideCommissionProd') {
							OverrideCommissionProd = new ChangeInCost(parser);
						} else if (text == 'PolicyPeriodId') {
							PolicyPeriodId = parser.getText();
						} else if (text == 'Taxes') {
							Taxes = new ChangeInCost(parser);
						} else if (text == 'TotalCommission') {
							TotalCommission = new ChangeInCost(parser);
						} else if (text == 'TotalCommissionOrg') {
							TotalCommissionOrg = new ChangeInCost(parser);
						} else if (text == 'TotalCost') {
							TotalCost = new ChangeInCost(parser);
						} else if (text == 'TotalPremium') {
							TotalPremium = new ChangeInCost(parser);
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
							DeductibleType = parser.readValueAs(Object.class);
						} else if (text == 'DirectDeductible') {
							DirectDeductible = parser.readValueAs(Object.class);
						} else if (text == 'DeductiblePercentage') {
							DeductiblePercentage = parser.readValueAs(Object.class);
						} else if (text == 'ReferenceCode') {
							ReferenceCode = parser.readValueAs(Object.class);
						} else if (text == 'ClaveProducto') {
							ClaveProducto = parser.getText();
						} else if (text == 'TipoFranquicia') {
							TipoFranquicia = parser.readValueAs(Object.class);
						} else if (text == 'ValorFranquicia') {
							ValorFranquicia = parser.readValueAs(Object.class);
						} else if (text == 'ClaveAmpliada') {
							ClaveAmpliada = parser.getText();
						} else if (text == 'DescripcionAmpliada') {
							DescripcionAmpliada = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'Summary consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Summaries {
		public Summary Summary {get;set;} 
		public List<Vehicles> Vehicles {get;set;} 
		public List<Accesories> UWIssues {get;set;} 

		public Summaries(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Summary') {
							Summary = new Summary(parser);
						} else if (text == 'Vehicles') {
							Vehicles = arrayOfVehicles(parser);
						} else if (text == 'UWIssues') {
							UWIssues = arrayOfAccesories(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Summaries consuming unrecognized property: '+text);
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
	
	public class AdditionalFuelType {
		public Object Code {get;set;} 
		public Object Description {get;set;} 

		public AdditionalFuelType(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Code') {
							Code = parser.readValueAs(Object.class);
						} else if (text == 'Description') {
							Description = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'AdditionalFuelType consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Vehicles {
		public List<Accesories> Accesories {get;set;} 
		public AdditionalFuelType AdditionalFuelType {get;set;} 
		public List<Accesories> AdditionalInterestContacts {get;set;} 
		public AdditionalFuelType AutomaticAdjust {get;set;} 
		public Object BonusMalus {get;set;} 
		public Integer BrandCode {get;set;} 
		public String BrandName {get;set;} 
		public Object CNRT {get;set;} 
		public AddressType Category {get;set;} 
		public Object Census {get;set;} 
		public Object CertificateDateGeneration {get;set;} 
		public Object CertificateNumber {get;set;} 
		public AdditionalFuelType Color {get;set;} 
		public String DeductibleValueDescription {get;set;} 
		public Object EngineNumber {get;set;} 
		public AddressType FuelType {get;set;} 
		public Object GPSProvider {get;set;} 
		public Boolean HasClaimComputableForBonusMalus {get;set;} 
		public Boolean HasGPS {get;set;} 
		public Boolean HasInspections {get;set;} 
		public Boolean Is0Km {get;set;} 
		public Boolean IsPatentedAtArg {get;set;} 
		public Boolean IsTruck10TT100KM {get;set;} 
		public AdditionalFuelType Jurisdiction {get;set;} 
		public Object LessorName {get;set;} 
		public Object LicensePlate {get;set;} 
		public Object LienName {get;set;} 
		public Integer ModelCode {get;set;} 
		public String ModelName {get;set;} 
		public AddressType OriginCountry {get;set;} 
		public Double OriginalCostNew {get;set;} 
		public String OtherBrandName {get;set;} 
		public String OtherModelName {get;set;} 
		public String OtherVersionName {get;set;} 
		public Boolean PolicyOwnerIsInsured {get;set;} 
		public String PrimaryNamedInsured {get;set;} 
		public AddressType ProductOffering {get;set;} 
		public String PublicId {get;set;} 
		public Object ROUTE {get;set;} 
		public RiskLocation RiskLocation {get;set;} 
		public AdditionalFuelType ServiceType {get;set;} 
		public Double StatedAmount {get;set;} 
		public Double TargetPremium {get;set;} 
		public Double TargetPremiumAfterTax {get;set;} 
		public AddressType Usage {get;set;} 
		public Object VIN {get;set;} 
		public String VTVExpirationDate {get;set;} 
		public Integer VehicleNumber {get;set;} 
		public Integer VersionCode {get;set;} 
		public String VersionName {get;set;} 
		public Integer Year {get;set;} 
		public Integer CodigoInfoAuto {get;set;} 

		public Vehicles(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Accesories') {
							Accesories = arrayOfAccesories(parser);
						} else if (text == 'AdditionalFuelType') {
							AdditionalFuelType = new AdditionalFuelType(parser);
						} else if (text == 'AdditionalInterestContacts') {
							AdditionalInterestContacts = arrayOfAccesories(parser);
						} else if (text == 'AutomaticAdjust') {
							AutomaticAdjust = new AdditionalFuelType(parser);
						} else if (text == 'BonusMalus') {
							BonusMalus = parser.readValueAs(Object.class);
						} else if (text == 'BrandCode') {
							BrandCode = parser.getIntegerValue();
						} else if (text == 'BrandName') {
							BrandName = parser.getText();
						} else if (text == 'CNRT') {
							CNRT = parser.readValueAs(Object.class);
						} else if (text == 'Category') {
							Category = new AddressType(parser);
						} else if (text == 'Census') {
							Census = parser.readValueAs(Object.class);
						} else if (text == 'CertificateDateGeneration') {
							CertificateDateGeneration = parser.readValueAs(Object.class);
						} else if (text == 'CertificateNumber') {
							CertificateNumber = parser.readValueAs(Object.class);
						} else if (text == 'Color') {
							Color = new AdditionalFuelType(parser);
						} else if (text == 'DeductibleValueDescription') {
							DeductibleValueDescription = parser.getText();
						} else if (text == 'EngineNumber') {
							EngineNumber = parser.readValueAs(Object.class);
						} else if (text == 'FuelType') {
							FuelType = new AddressType(parser);
						} else if (text == 'GPSProvider') {
							GPSProvider = parser.readValueAs(Object.class);
						} else if (text == 'HasClaimComputableForBonusMalus') {
							HasClaimComputableForBonusMalus = parser.getBooleanValue();
						} else if (text == 'HasGPS') {
							HasGPS = parser.getBooleanValue();
						} else if (text == 'HasInspections') {
							HasInspections = parser.getBooleanValue();
						} else if (text == 'Is0Km') {
							Is0Km = parser.getBooleanValue();
						} else if (text == 'IsPatentedAtArg') {
							IsPatentedAtArg = parser.getBooleanValue();
						} else if (text == 'IsTruck10TT100KM') {
							IsTruck10TT100KM = parser.getBooleanValue();
						} else if (text == 'Jurisdiction') {
							Jurisdiction = new AdditionalFuelType(parser);
						} else if (text == 'LessorName') {
							LessorName = parser.readValueAs(Object.class);
						} else if (text == 'LicensePlate') {
							LicensePlate = parser.readValueAs(Object.class);
						} else if (text == 'LienName') {
							LienName = parser.readValueAs(Object.class);
						} else if (text == 'ModelCode') {
							ModelCode = parser.getIntegerValue();
						} else if (text == 'ModelName') {
							ModelName = parser.getText();
						} else if (text == 'OriginCountry') {
							OriginCountry = new AddressType(parser);
						} else if (text == 'OriginalCostNew') {
							OriginalCostNew = parser.getDoubleValue();
						} else if (text == 'OtherBrandName') {
							OtherBrandName = parser.getText();
						} else if (text == 'OtherModelName') {
							OtherModelName = parser.getText();
						} else if (text == 'OtherVersionName') {
							OtherVersionName = parser.getText();
						} else if (text == 'PolicyOwnerIsInsured') {
							PolicyOwnerIsInsured = parser.getBooleanValue();
						} else if (text == 'PrimaryNamedInsured') {
							PrimaryNamedInsured = parser.getText();
						} else if (text == 'ProductOffering') {
							ProductOffering = new AddressType(parser);
						} else if (text == 'PublicId') {
							PublicId = parser.getText();
						} else if (text == 'ROUTE') {
							ROUTE = parser.readValueAs(Object.class);
						} else if (text == 'RiskLocation') {
							RiskLocation = new RiskLocation(parser);
						} else if (text == 'ServiceType') {
							ServiceType = new AdditionalFuelType(parser);
						} else if (text == 'StatedAmount') {
							StatedAmount = parser.getDoubleValue();
						} else if (text == 'TargetPremium') {
							TargetPremium = parser.getDoubleValue();
						} else if (text == 'TargetPremiumAfterTax') {
							TargetPremiumAfterTax = parser.getDoubleValue();
						} else if (text == 'Usage') {
							Usage = new AddressType(parser);
						} else if (text == 'VIN') {
							VIN = parser.readValueAs(Object.class);
						} else if (text == 'VTVExpirationDate') {
							VTVExpirationDate = parser.getText();
						} else if (text == 'VehicleNumber') {
							VehicleNumber = parser.getIntegerValue();
						} else if (text == 'VersionCode') {
							VersionCode = parser.getIntegerValue();
						} else if (text == 'VersionName') {
							VersionName = parser.getText();
						} else if (text == 'Year') {
							Year = parser.getIntegerValue();
						} else if (text == 'CodigoInfoAuto') {
							CodigoInfoAuto = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Vehicles consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static SanCristobalCotizacionResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SanCristobalCotizacionResponse(parser);
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
	



    private static List<Summaries> arrayOfSummaries(System.JSONParser p) {
        List<Summaries> res = new List<Summaries>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Summaries(p));
        }
        return res;
    }






    private static List<Accesories> arrayOfAccesories(System.JSONParser p) {
        List<Accesories> res = new List<Accesories>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Accesories(p));
        }
        return res;
    }








    private static List<Vehicles> arrayOfVehicles(System.JSONParser p) {
        List<Vehicles> res = new List<Vehicles>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Vehicles(p));
        }
        return res;
    }



}