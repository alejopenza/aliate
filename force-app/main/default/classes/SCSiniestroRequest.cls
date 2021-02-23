public class SCSiniestroRequest {

	public class BasicElements {
		public Integer StolenWheels {get;set;} 
		public Boolean IsPartialAccident {get;set;} 
		public Boolean IsTotalAccident {get;set;} 
		public Boolean AccesoriesOnly {get;set;} 
		public Boolean PartialBurglary {get;set;} 
		public Boolean BrokenLock {get;set;} 
		public Boolean BrokenLockInBurglary {get;set;} 
		public Boolean BrokenGlass {get;set;} 
		public Boolean BrokenGlassInBurglary {get;set;} 
		public Boolean WasParked {get;set;} 
		public Boolean WasStolen {get;set;} 
		public Boolean Hail {get;set;} 
		public Boolean PartialFire {get;set;} 
		public Boolean TotalFire {get;set;} 
		public Boolean Flood {get;set;} 
		public Boolean SolarRoof {get;set;} 
		public Boolean BrokenWindShield {get;set;} 
		public Boolean IsWheelsSteal {get;set;} 

		public BasicElements(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'StolenWheels') {
							StolenWheels = parser.getIntegerValue();
						} else if (text == 'IsPartialAccident') {
							IsPartialAccident = parser.getBooleanValue();
						} else if (text == 'IsTotalAccident') {
							IsTotalAccident = parser.getBooleanValue();
						} else if (text == 'AccesoriesOnly') {
							AccesoriesOnly = parser.getBooleanValue();
						} else if (text == 'PartialBurglary') {
							PartialBurglary = parser.getBooleanValue();
						} else if (text == 'BrokenLock') {
							BrokenLock = parser.getBooleanValue();
						} else if (text == 'BrokenLockInBurglary') {
							BrokenLockInBurglary = parser.getBooleanValue();
						} else if (text == 'BrokenGlass') {
							BrokenGlass = parser.getBooleanValue();
						} else if (text == 'BrokenGlassInBurglary') {
							BrokenGlassInBurglary = parser.getBooleanValue();
						} else if (text == 'WasParked') {
							WasParked = parser.getBooleanValue();
						} else if (text == 'WasStolen') {
							WasStolen = parser.getBooleanValue();
						} else if (text == 'Hail') {
							Hail = parser.getBooleanValue();
						} else if (text == 'PartialFire') {
							PartialFire = parser.getBooleanValue();
						} else if (text == 'TotalFire') {
							TotalFire = parser.getBooleanValue();
						} else if (text == 'Flood') {
							Flood = parser.getBooleanValue();
						} else if (text == 'SolarRoof') {
							SolarRoof = parser.getBooleanValue();
						} else if (text == 'BrokenWindShield') {
							BrokenWindShield = parser.getBooleanValue();
						} else if (text == 'IsWheelsSteal') {
							IsWheelsSteal = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'BasicElements consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Properties {
		public Persons Owner {get;set;} 
		public String DamageDescription {get;set;} 
		public String PropertyType {get;set;} 
		public String PropertyDescription {get;set;} 

		public Properties(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Owner') {
							Owner = new Persons(parser);
						} else if (text == 'DamageDescription') {
							DamageDescription = parser.getText();
						} else if (text == 'PropertyType') {
							PropertyType = parser.getText();
						} else if (text == 'PropertyDescription') {
							PropertyDescription = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Properties consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Vehicles {
		public Boolean IsAssociated {get;set;} 
		public Vehicle Vehicle {get;set;} 
		public List<Accesories> Accesories {get;set;} 
		public String DamageDescription {get;set;} 
		public BasicElements BasicElements {get;set;} 
		public List<Persons> Persons {get;set;} 

		public Vehicles(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'IsAssociated') {
							IsAssociated = parser.getBooleanValue();
						} else if (text == 'Vehicle') {
							Vehicle = new Vehicle(parser);
						} else if (text == 'Accesories') {
							Accesories = arrayOfAccesories(parser);
						} else if (text == 'DamageDescription') {
							DamageDescription = parser.getText();
						} else if (text == 'BasicElements') {
							BasicElements = new BasicElements(parser);
						} else if (text == 'Persons') {
							Persons = arrayOfPersons(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Vehicles consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Vehicle {
		public String LicensePlate {get;set;} 
		public Boolean IsThirdPartyVehicle {get;set;} 
		public String Category {get;set;} 
		public String Brand {get;set;} 
		public String ThirdPartyPolicyNumber {get;set;} 
		public String ThirdPartyCoverage {get;set;} 
		public String OtherInsuranceCompany {get;set;} 
		public Boolean NotInsured {get;set;} 

		public Vehicle(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'LicensePlate') {
							LicensePlate = parser.getText();
						} else if (text == 'IsThirdPartyVehicle') {
							IsThirdPartyVehicle = parser.getBooleanValue();
						} else if (text == 'Category') {
							Category = parser.getText();
						} else if (text == 'Brand') {
							Brand = parser.getText();
						} else if (text == 'ThirdPartyPolicyNumber') {
							ThirdPartyPolicyNumber = parser.getText();
						} else if (text == 'ThirdPartyCoverage') {
							ThirdPartyCoverage = parser.getText();
						} else if (text == 'OtherInsuranceCompany') {
							OtherInsuranceCompany = parser.getText();
						} else if (text == 'NotInsured') {
							NotInsured = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Vehicle consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Accesories {
		public String Description {get;set;} 
		public Integer Ammount {get;set;} 
		public String Serial {get;set;} 

		public Accesories(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'Ammount') {
							Ammount = parser.getIntegerValue();
						} else if (text == 'Serial') {
							Serial = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Accesories consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Identifier {
		public String IdentifierType {get;set;} 
		public String IdentifierNumber {get;set;} 

		public Identifier(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'IdentifierType') {
							IdentifierType = parser.getText();
						} else if (text == 'IdentifierNumber') {
							IdentifierNumber = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Identifier consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Persons {
		public String Surname {get;set;} 
		public String Email {get;set;} 
		public String Address {get;set;} 
		public String IdNumber {get;set;} 
		public String Name {get;set;} 
		public Relationship Relationship {get;set;} 
		public String PhoneNumber {get;set;} 
		public String Role {get;set;} 
		public Boolean IsInsured {get;set;} 
		public Boolean IsInjured {get;set;} 
		public List<Injuries> Injuries {get;set;} 
		public String SecondaryRole {get;set;} 

		public Persons(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Surname') {
							Surname = parser.getText();
						} else if (text == 'Email') {
							Email = parser.getText();
						} else if (text == 'Address') {
							Address = parser.getText();
						} else if (text == 'IdNumber') {
							IdNumber = parser.getText();
						} else if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'Relationship') {
							Relationship = new Relationship(parser);
						} else if (text == 'PhoneNumber') {
							PhoneNumber = parser.getText();
						} else if (text == 'Role') {
							Role = parser.getText();
						} else if (text == 'IsInsured') {
							IsInsured = parser.getBooleanValue();
						} else if (text == 'IsInjured') {
							IsInjured = parser.getBooleanValue();
						} else if (text == 'Injuries') {
							Injuries = arrayOfInjuries(parser);
						} else if (text == 'SecondaryRole') {
							SecondaryRole = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Persons consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ClaimAddress {
		public String City {get;set;} 
		public String Street {get;set;} 
		public String ZipCode {get;set;} 
		public String State {get;set;} 

		public ClaimAddress(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'City') {
							City = parser.getText();
						} else if (text == 'Street') {
							Street = parser.getText();
						} else if (text == 'ZipCode') {
							ZipCode = parser.getText();
						} else if (text == 'State') {
							State = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ClaimAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Relationship {
		public String Code {get;set;} 
		public String Description {get;set;} 

		public Relationship(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Code') {
							Code = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Relationship consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Author {
		public Identifier Identifier {get;set;} 
		public Integer Relationship {get;set;} 

		public Author(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Identifier') {
							Identifier = new Identifier(parser);
						} else if (text == 'Relationship') {
							Relationship = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Author consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Injuries {
		public String SeverityType {get;set;} 
		public String InjuryDescription {get;set;} 

		public Injuries(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'SeverityType') {
							SeverityType = parser.getText();
						} else if (text == 'InjuryDescription') {
							InjuryDescription = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Injuries consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Claim {
		public String lossCause {get;set;} 
		public String country {get;set;} 
		public String lossDate {get;set;} 
		public String description {get;set;} 
		public String policyNumber {get;set;} 
		public ClaimAddress claimAddress {get;set;} 
		public Author author {get;set;} 
		public String howReported {get;set;} 
		public String userName {get;set;} 
		public List<Vehicles> vehicles {get;set;} 
		public List<Persons> pedestrians {get;set;} 
		public List<Properties> properties {get;set;} 
		public List<Persons> witnesses {get;set;} 

		public Claim(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'lossCause') {
							lossCause = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'lossDate') {
							lossDate = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'policyNumber') {
							policyNumber = parser.getText();
						} else if (text == 'claimAddress') {
							claimAddress = new ClaimAddress(parser);
						} else if (text == 'author') {
							author = new Author(parser);
						} else if (text == 'howReported') {
							howReported = parser.getText();
						} else if (text == 'userName') {
							userName = parser.getText();
						} else if (text == 'vehicles') {
							vehicles = arrayOfVehicles(parser);
						} else if (text == 'pedestrians') {
							pedestrians = arrayOfPersons(parser);
						} else if (text == 'properties') {
							properties = arrayOfProperties(parser);
						} else if (text == 'witnesses') {
							witnesses = arrayOfPersons(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Claim consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Claim Claim {get;set;} 

	public SCSiniestroRequest(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Claim') {
						Claim = new Claim(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SCSiniestroRequest consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static SCSiniestroRequest parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SCSiniestroRequest(parser);
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

    private static List<Injuries> arrayOfInjuries(System.JSONParser p) {
        List<Injuries> res = new List<Injuries>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Injuries(p));
        }
        return res;
    }

    private static List<Properties> arrayOfProperties(System.JSONParser p) {
        List<Properties> res = new List<Properties>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Properties(p));
        }
        return res;
    }


    private static List<Persons> arrayOfPersons(System.JSONParser p) {
        List<Persons> res = new List<Persons>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Persons(p));
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

    private static List<Accesories> arrayOfAccesories(System.JSONParser p) {
        List<Accesories> res = new List<Accesories>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Accesories(p));
        }
        return res;
    }
}