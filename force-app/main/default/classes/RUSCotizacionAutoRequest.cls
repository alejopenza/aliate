public with sharing class RUSCotizacionAutoRequest {

	public Integer codigoProductor; // Codigo Productor
	public Integer codigoSolicitante; // Codigo Productor
	public String codigoTipoInteres; // Opciones: VEHICULO / MOTOVEHICULO
	public String condicionFiscal;
	public Integer cuotas;
	public Integer numeroSolicitud;
	public String tipoVigencia;
	public List<Vehiculo> vehiculos;
	public String vigenciaDesde;
	public String vigenciaHasta;
	public String vigenciaPolizaId; // No es necesario si se indica el campo TipoVigencia

	public static RUSCotizacionAutoRequest parse(String json) {
		return (RUSCotizacionAutoRequest) System.JSON.deserialize(json, RUSCotizacionAutoRequest.class);
	}

	public class Vehiculo {
		public String anio;
		public String controlSatelital; // Opciones: 'SI' | 'NO'
		public Integer cpLocalidadGuarda;
		public String gnc; // Opciones: 'SI' | 'NO'
		public String localidadGuarda;
		public Integer modeloVehiculo; //cod infoauto
		public String rastreadorSatelital; // Opciones: 'SI' | 'NO'
		public String rastreoACargoRUS; // Opciones: 'SI' | 'NO'
		public Integer sumaAseguradaAccesorios;
		public Integer sumaAseguradaGnc;
		public String sumaAseguradaVehiculo; // Si se deja vacio '' cotiza todo
		public String uso; // Opciones: "PARTOCULAR"
	}
}