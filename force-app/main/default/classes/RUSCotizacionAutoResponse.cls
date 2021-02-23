public with sharing class RUSCotizacionAutoResponse {

    public Integer cantidadTotal;
	public List<DtoList> dtoList;

    /** ERROR FIELDS START */
    public String timestamp;
	public Integer status;
	public String error;
	public String message;
	public String path;
	public String httpStatusCode;
	public String code;
	public String errorCode;
	public String cause;
	// public Properties properties; // Blank fields
	// public List<Object> validationErrors;
    /** ERROR FIELDS END */

	// remove CRLF '\\n\\r'
	// remove LF '\\n'
	// remove CR '\\r'
	public static RUSCotizacionAutoResponse parse(String json) {
		String jsonToProcess = json.replace('\n','').replace('\r','').replace('\n\r','');
		return (RUSCotizacionAutoResponse) System.JSON.deserialize(jsonToProcess, RUSCotizacionAutoResponse.class);
	}

    public class DtoList {
		public String ajusteAutomatico;
		public List<String> ajustesAutomaticosPosibles;
		public String auxilioMecanico;
		public String coberturaVida;
		public String codigoCasco;
		public String codigoRC;
		public String descripcionCasco;
		public String descripcionComercial;
		public String descripcionRC;
		public String detalleCoberturaCasco;
		public String detalleCoberturaRC;
		public Integer franquicia;
		public Integer id;
		public Integer iva;
		public String numeroSolicitud;
		public String paisesLimitrofes;
		public Integer premio;
		public Integer prima;
		public String responsabilidadCivil;
		public Integer sumaAsegurada;

		public void setId (String value){
			this.id =  value != null ? Integer.valueOf(value) : null;
		}

		public void setCodigoCasco (String value){
			this.codigoCasco =  value != null ? value : '';
		}

		public void setDescripcionCasco (String value){
			this.descripcionCasco =  value != null ? value : '';
		}

		public void setDescripcionRC (String value){
			if(value != null) {
				this.descripcionRC = value;
			} else {
				this.descripcionRC = '';
			}
		}

		public void setDetalleCoberturaCasco (String value){
			this.detalleCoberturaCasco =  value != null ? value : '';
		}

		public void setSumaAsegurada (String value){
			this.sumaAsegurada =  value != null ? Integer.valueOf(value) : 0;
		}

		public void setAjustesAutomaticosPosibles (String value){
			this.ajustesAutomaticosPosibles =  value != null ? (List<String>) System.JSON.deserialize(value, List<String>.class) : new List<String>();
		}
	}

    // In the example it's in blank
    // public class Properties { }
}