public with sharing class InfoAutoAPIVersionesResponse {
    public InfoAutoAPIVersionesResponse() {

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
	
	public List<Versiones> Versiones {get;set;} 
	public Boolean HasError {get;set;} 
	public Boolean HasWarning {get;set;} 
	public Boolean HasInformation {get;set;} 
	public List<Messages> Messages {get;set;} 

	public InfoAutoAPIVersionesResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Versiones') {
						Versiones = arrayOfVersiones(parser);
					} else if (text == 'HasError') {
						HasError = parser.getBooleanValue();
					} else if (text == 'HasWarning') {
						HasWarning = parser.getBooleanValue();
					} else if (text == 'HasInformation') {
						HasInformation = parser.getBooleanValue();
					} else if (text == 'Messages') {
						Messages = arrayOfMessages(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'InfoAutoAPIVersionesResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Versiones {
		public Integer ID {get;set;} 
		public Integer VersionNumero {get;set;} 
		public String VersionDescripcion {get;set;} 
		public Integer MarcaNumero {get;set;} 
		public String MarcaDescripcion {get;set;} 
		public Integer ModeloNumero {get;set;} 
		public String ModeloDescripcion {get;set;} 
		public String NombreCompleto {get;set;} 
		public String Categoria {get;set;} 
		public Integer CodigoInfoAuto {get;set;} 
		public Integer CodigoReasignado {get;set;} 
		public Boolean Critico {get;set;} 
		public String CombustibleCodigo {get;set;} 
		public String CombustibleDescripcion {get;set;} 
		public Integer Precio {get;set;} 
		public Integer PrecioReferencia0Km {get;set;} 
		public Double ImporteUsado {get;set;} 
		public Integer Precio0KmUsado {get;set;} 
		public List<CoberturasCriticas> CoberturasCriticas {get;set;} 
		public Boolean Importado {get;set;} 
		public Boolean TechoPanoramico {get;set;} 
		public Boolean TechoCorredizo {get;set;} 

		public Versiones(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ID') {
							ID = parser.getIntegerValue();
						} else if (text == 'VersionNumero') {
							VersionNumero = parser.getIntegerValue();
						} else if (text == 'VersionDescripcion') {
							VersionDescripcion = parser.getText();
						} else if (text == 'MarcaNumero') {
							MarcaNumero = parser.getIntegerValue();
						} else if (text == 'MarcaDescripcion') {
							MarcaDescripcion = parser.getText();
						} else if (text == 'ModeloNumero') {
							ModeloNumero = parser.getIntegerValue();
						} else if (text == 'ModeloDescripcion') {
							ModeloDescripcion = parser.getText();
						} else if (text == 'NombreCompleto') {
							NombreCompleto = parser.getText();
						} else if (text == 'Categoria') {
							Categoria = parser.getText();
						} else if (text == 'CodigoInfoAuto') {
							CodigoInfoAuto = parser.getIntegerValue();
						} else if (text == 'CodigoReasignado') {
							CodigoReasignado = parser.getIntegerValue();
						} else if (text == 'Critico') {
							Critico = parser.getBooleanValue();
						} else if (text == 'CombustibleCodigo') {
							CombustibleCodigo = parser.getText();
						} else if (text == 'CombustibleDescripcion') {
							CombustibleDescripcion = parser.getText();
						} else if (text == 'Precio') {
							Precio = parser.getIntegerValue();
						} else if (text == 'PrecioReferencia0Km') {
							PrecioReferencia0Km = parser.getIntegerValue();
						} else if (text == 'ImporteUsado') {
							ImporteUsado = parser.getDoubleValue();
						} else if (text == 'Precio0KmUsado') {
							Precio0KmUsado = parser.getIntegerValue();
						} else if (text == 'CoberturasCriticas') {
							CoberturasCriticas = arrayOfCoberturasCriticas(parser);
						} else if (text == 'Importado') {
							Importado = parser.getBooleanValue();
						} else if (text == 'TechoPanoramico') {
							TechoPanoramico = parser.getBooleanValue();
						} else if (text == 'TechoCorredizo') {
							TechoCorredizo = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Versiones consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CoberturasCriticas {

		public CoberturasCriticas(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'CoberturasCriticas consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static InfoAutoAPIVersionesResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new InfoAutoAPIVersionesResponse(parser);
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






    private static List<CoberturasCriticas> arrayOfCoberturasCriticas(System.JSONParser p) {
        List<CoberturasCriticas> res = new List<CoberturasCriticas>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new CoberturasCriticas(p));
        }
        return res;
    }




    private static List<Versiones> arrayOfVersiones(System.JSONParser p) {
        List<Versiones> res = new List<Versiones>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Versiones(p));
        }
        return res;
    }

}