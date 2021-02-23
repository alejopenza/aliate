public with sharing class PypDatosAPIResponse {
    public class Inf_lab_hist_fecha {
		public List<Row_S> row {get;set;} 

		public Inf_lab_hist_fecha(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = arrayOfRow_S(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Inf_lab_hist_fecha_ consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public RESULTADO RESULTADO {get;set;} 

	public PypDatosAPIResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    system.debug('parser.getText(): ' + parser.getText());
					if (text == 'RESULTADO') {
						RESULTADO = new RESULTADO(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Juicios_Posee_Inhabilitacion {
		public Row row {get;set;} 

		public Juicios_Posee_Inhabilitacion(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Juicios_Posee_Inhabilitacion consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Existencia_Fisica_Resu {
		public Row_U row {get;set;} 

		public Existencia_Fisica_Resu(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_U(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Existencia_Fisica_Resu consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Tipo_empleador {
		public Row_P row {get;set;} 

		public Tipo_empleador(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_P(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Tipo_empleador consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CONSTANCIA_DE_INSCRIPCION_AFIP {
		public Row_N row {get;set;} 

		public CONSTANCIA_DE_INSCRIPCION_AFIP(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_N(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'CONSTANCIA_DE_INSCRIPCION_AFIP consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_Z {
		public Integer monto_maximo {get;set;} 
		public Integer deuda_actual {get;set;} 
		public String fecha {get;set;} 
		public String entidad {get;set;} 
		public Integer situacion {get;set;} 

		public Row_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'monto_maximo') {
							monto_maximo = parser.getIntegerValue();
						} else if (text == 'deuda_actual') {
							deuda_actual = parser.getIntegerValue();
						} else if (text == 'fecha') {
							fecha = parser.getText();
						} else if (text == 'entidad') {
							entidad = parser.getText();
						} else if (text == 'situacion') {
							situacion = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_Y {
		public String tiene_juicio {get;set;} 

		public Row_Y(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'tiene_juicio') {
							tiene_juicio = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_Y consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_X {
		public Integer cantidad_autos {get;set;} 
		public String posee_autos {get;set;} 

		public Row_X(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cantidad_autos') {
							cantidad_autos = parser.getIntegerValue();
						} else if (text == 'posee_autos') {
							posee_autos = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_X consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_W {
		public String imp_iva {get;set;} 
		public String monotributo {get;set;} 
		public String empleador {get;set;} 
		public Integer periodo {get;set;} 
		public String integrante_soc {get;set;} 
		public String imp_ganancias {get;set;} 

		public Row_W(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'imp_iva') {
							imp_iva = parser.getText();
						} else if (text == 'monotributo') {
							monotributo = parser.getText();
						} else if (text == 'empleador') {
							empleador = parser.getText();
						} else if (text == 'periodo') {
							periodo = parser.getIntegerValue();
						} else if (text == 'integrante_soc') {
							integrante_soc = parser.getText();
						} else if (text == 'imp_ganancias') {
							imp_ganancias = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_W consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_V {
		public Integer ult_periodo {get;set;} 
		public Long cuit {get;set;} 
		public Integer alta_ult_trabajo {get;set;} 
		public String situacion_laboral_actual {get;set;} 
		public String razon_social {get;set;} 

		public Row_V(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ult_periodo') {
							ult_periodo = parser.getIntegerValue();
						} else if (text == 'cuit') {
							cuit = parser.getLongValue();
						} else if (text == 'alta_ult_trabajo') {
							alta_ult_trabajo = parser.getIntegerValue();
						} else if (text == 'situacion_laboral_actual') {
							situacion_laboral_actual = parser.getText();
						} else if (text == 'razon_social') {
							razon_social = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_V consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_U {
		public Integer codigo_postal {get;set;} 
		public Integer nume_docu {get;set;} 
		public String fecha_nacimiento {get;set;} 
		public Long cdi {get;set;} 
		public String provincia {get;set;} 
		public Integer edad {get;set;} 
		public Integer clase {get;set;} 
		public String ape_nom {get;set;} 
		public String t_docu {get;set;} 
		public String direc_calle {get;set;} 
		public String apellido_materno {get;set;} 
		public String localidad {get;set;} 
		public String fallecido {get;set;} 

		public Row_U(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'codigo_postal') {
							codigo_postal = parser.getIntegerValue();
						} else if (text == 'nume_docu') {
							nume_docu = parser.getIntegerValue();
						} else if (text == 'fecha_nacimiento') {
							fecha_nacimiento = parser.getText();
						} else if (text == 'cdi') {
							cdi = parser.getLongValue();
						} else if (text == 'provincia') {
							provincia = parser.getText();
						} else if (text == 'edad') {
							edad = parser.getIntegerValue();
						} else if (text == 'clase') {
							clase = parser.getIntegerValue();
						} else if (text == 'ape_nom') {
							ape_nom = parser.getText();
						} else if (text == 't_docu') {
							t_docu = parser.getText();
						} else if (text == 'direc_calle') {
							direc_calle = parser.getText();
						} else if (text == 'apellido_materno') {
							apellido_materno = parser.getText();
						} else if (text == 'localidad') {
							localidad = parser.getText();
						} else if (text == 'fallecido') {
							fallecido = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_U consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Consultas {
		public Row_Q row {get;set;} 

		public Consultas(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_Q(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Consultas consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DEUDA_SISTEMA_FINANCIERO_12M {
		public Row_Z row {get;set;} 

		public DEUDA_SISTEMA_FINANCIERO_12M(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'DEUDA_SISTEMA_FINANCIERO_12M consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TIENE_JUI_QUI_EJEC {
		public Row_Y row {get;set;} 

		public TIENE_JUI_QUI_EJEC(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_Y(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'TIENE_JUI_QUI_EJEC consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Moviles_posee {
		public Row_X row {get;set;} 

		public Moviles_posee(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_X(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Moviles_posee consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class RESULTADO {
		public Juicios_Posee_Inhabilitacion Juicios_Posee_Inhabilitacion {get;set;} 
		public DEUDA_SISTEMA_FINANCIERO_12M DEUDA_SISTEMA_FINANCIERO_12M {get;set;} 
		public TIENE_JUI_QUI_EJEC TIENE_JUI_QUI_EJEC {get;set;} 
		public Moviles_posee Moviles_posee {get;set;} 
		public DEUDA_SISTEMA_FINANCIERO_12M DEUDA_SISTEMA_FINANCIERO_24M {get;set;} 
		public CONSTANCIA_DE_INSCRIPCION CONSTANCIA_DE_INSCRIPCION {get;set;} 
		public RELACION_DEPENDENCIA RELACION_DEPENDENCIA {get;set;} 
		public Existencia_Fisica_Resu Existencia_Fisica_Resu {get;set;} 
		public Juicios_Posee_Inhabilitacion Juicios_Posee_Embargo {get;set;} 
		public DEUDA_SISTEMA_FINANCIERO_12M DEUDA_SISTEMA_FINANCIERO_6M {get;set;} 
		public DEUDA_SISTEMA_FINANCIERO_ACT DEUDA_SISTEMA_FINANCIERO_ACT {get;set;} 
		public Inf_lab_hist_fecha inf_lab_hist_fecha {get;set;} 
		public Tipo_Actividad Tipo_Actividad {get;set;} 
		public Consultas consultas {get;set;} 
		public Tipo_empleador tipo_empleador {get;set;} 
		public Predictor_ingreso predictor_ingreso {get;set;} 
		public CONSTANCIA_DE_INSCRIPCION_AFIP CONSTANCIA_DE_INSCRIPCION_AFIP {get;set;} 

		public RESULTADO(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Juicios_Posee_Inhabilitacion') {
							Juicios_Posee_Inhabilitacion = new Juicios_Posee_Inhabilitacion(parser);
						} else if (text == 'DEUDA_SISTEMA_FINANCIERO_12M') {
							DEUDA_SISTEMA_FINANCIERO_12M = new DEUDA_SISTEMA_FINANCIERO_12M(parser);
						} else if (text == 'TIENE_JUI_QUI_EJEC') {
							TIENE_JUI_QUI_EJEC = new TIENE_JUI_QUI_EJEC(parser);
						} else if (text == 'Moviles_posee') {
							Moviles_posee = new Moviles_posee(parser);
						} else if (text == 'DEUDA_SISTEMA_FINANCIERO_24M') {
							DEUDA_SISTEMA_FINANCIERO_24M = new DEUDA_SISTEMA_FINANCIERO_12M(parser);
						} else if (text == 'CONSTANCIA_DE_INSCRIPCION_') {
							CONSTANCIA_DE_INSCRIPCION = new CONSTANCIA_DE_INSCRIPCION(parser);
						} else if (text == 'RELACION_DEPENDENCIA') {
							RELACION_DEPENDENCIA = new RELACION_DEPENDENCIA(parser);
						} else if (text == 'Existencia_Fisica_Resu') {
							Existencia_Fisica_Resu = new Existencia_Fisica_Resu(parser);
						} else if (text == 'Juicios_Posee_Embargo') {
							Juicios_Posee_Embargo = new Juicios_Posee_Inhabilitacion(parser);
						} else if (text == 'DEUDA_SISTEMA_FINANCIERO_6M') {
							DEUDA_SISTEMA_FINANCIERO_6M = new DEUDA_SISTEMA_FINANCIERO_12M(parser);
						} else if (text == 'DEUDA_SISTEMA_FINANCIERO_ACT') {
							DEUDA_SISTEMA_FINANCIERO_ACT = new DEUDA_SISTEMA_FINANCIERO_ACT(parser);
						} else if (text == 'inf_lab_hist_fecha_') {
							inf_lab_hist_fecha = new Inf_lab_hist_fecha(parser);
						} else if (text == 'Tipo_Actividad') {
							Tipo_Actividad = new Tipo_Actividad(parser);
						} else if (text == 'consultas') {
							consultas = new Consultas(parser);
						} else if (text == 'tipo_empleador') {
							tipo_empleador = new Tipo_empleador(parser);
						} else if (text == 'predictor_ingreso') {
							predictor_ingreso = new Predictor_ingreso(parser);
						} else if (text == 'CONSTANCIA_DE_INSCRIPCION_AFIP') {
							CONSTANCIA_DE_INSCRIPCION_AFIP = new CONSTANCIA_DE_INSCRIPCION_AFIP(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'RESULTADO consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CONSTANCIA_DE_INSCRIPCION {
		public Row_W row {get;set;} 

		public CONSTANCIA_DE_INSCRIPCION(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_W(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'CONSTANCIA_DE_INSCRIPCION_ consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class RELACION_DEPENDENCIA {
		public Row_V row {get;set;} 

		public RELACION_DEPENDENCIA(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
                    system.debug('text: ' + text);
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_V(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'RELACION_DEPENDENCIA consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DEUDA_SISTEMA_FINANCIERO_ACT {
		public Row_T row {get;set;} 

		public DEUDA_SISTEMA_FINANCIERO_ACT(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_T(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'DEUDA_SISTEMA_FINANCIERO_ACT consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_T {
		public Integer deuda_actual {get;set;} 
		public String fecha {get;set;} 
		public Long cuit {get;set;} 
		public String entidad {get;set;} 
		public Integer situacion {get;set;} 

		public Row_T(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'deuda_actual') {
							deuda_actual = parser.getIntegerValue();
						} else if (text == 'fecha') {
							fecha = parser.getText();
						} else if (text == 'cuit') {
							cuit = parser.getLongValue();
						} else if (text == 'entidad') {
							entidad = parser.getText();
						} else if (text == 'situacion') {
							situacion = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_T consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Tipo_Actividad {
		public Row_R row {get;set;} 

		public Tipo_Actividad(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_R(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Tipo_Actividad consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_S {
		public String inf_lab_razon {get;set;} 
		public String relacion_hasta {get;set;} 
		public String relacion_desde {get;set;} 
		public Long inf_lab_cuit {get;set;} 

		public Row_S(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'inf_lab_razon_') {
							inf_lab_razon = parser.getText();
						} else if (text == 'relacion_hasta_') {
							relacion_hasta = parser.getText();
						} else if (text == 'relacion_desde_') {
							relacion_desde = parser.getText();
						} else if (text == 'inf_lab_cuit_') {
							inf_lab_cuit = parser.getLongValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_S consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_R {
		public String tipo_actividad {get;set;} 

		public Row_R(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'tipo_actividad') {
							tipo_actividad = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_R consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Predictor_ingreso {
		public Row_O row {get;set;} 

		public Predictor_ingreso(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'row') {
							row = new Row_O(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Predictor_ingreso consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row {
		public Integer juicios_posee_tipo {get;set;} 

		public Row(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'juicios_posee_tipo') {
							juicios_posee_tipo = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Row consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_Q {
		public Integer consultas {get;set;} 
		public Integer consultas_6 {get;set;} 

		public Row_Q(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'consultas') {
							consultas = parser.getIntegerValue();
						} else if (text == 'consultas_6') {
							consultas_6 = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_Q consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_P {
		public String tipo_empleador {get;set;} 

		public Row_P(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'tipo_empleador') {
							tipo_empleador = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_P consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_O {
		public String predictor_ingresos {get;set;} 

		public Row_O(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'predictor_ingresos') {
							predictor_ingresos = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_O consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Row_N {
		public String descripcion {get;set;} 
		public Long cuit {get;set;} 
		public String denominacion {get;set;} 
		public String fecha_contrato_social {get;set;} 
		public String categoria {get;set;} 
		public Integer fecha_inicio_actividades {get;set;} 
		public Integer antiguedad_meses {get;set;} 
		public String direccion {get;set;} 
		public String mes_cierre {get;set;} 
		public String localidad {get;set;} 
		public String provincia {get;set;} 
		public String cp {get;set;} 

		public Row_N(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'descripcion') {
							descripcion = parser.getText();
						} else if (text == 'cuit') {
							cuit = parser.getLongValue();
						} else if (text == 'denominacion') {
							denominacion = parser.getText();
						} else if (text == 'fecha_contrato_social') {
							fecha_contrato_social = parser.getText();
						} else if (text == 'categoria') {
							categoria = parser.getText();
						} else if (text == 'fecha_inicio_actividades') {
							fecha_inicio_actividades = parser.getIntegerValue();
						} else if (text == 'antiguedad_meses') {
							antiguedad_meses = parser.getIntegerValue();
						} else if (text == 'direccion') {
							direccion = parser.getText();
						} else if (text == 'mes_cierre') {
							mes_cierre = parser.getText();
						} else if (text == 'localidad') {
							localidad = parser.getText();
						} else if (text == 'provincia') {
							provincia = parser.getText();
						} else if (text == 'cp') {
							cp = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Row_N consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static PypDatosAPIResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new PypDatosAPIResponse(parser);
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
	
    private static List<Row_S> arrayOfRow_S(System.JSONParser p) {
        List<Row_S> res = new List<Row_S>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Row_S(p));
        }
        return res;
    }
}