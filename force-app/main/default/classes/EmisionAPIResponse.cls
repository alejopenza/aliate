public inherited sharing class EmisionAPIResponse {

    public Integer ramoId { get; set; }
    public Integer numeroCertificado { get; set; }
    public String numeroTramiteInterno { get; set; }
    public String estadoDeTramite { get; set; }
    public Integer numeroOficialPoliza { get; set; }
    public Integer numeroSancorPoliza { get; set; }
    public Recibo recibo { get; set; }

    public EmisionAPIResponse() {   }

    public class Recibo {
        public Integer numero { get; set; }
        public List<Detalle> detalles { get; set; }

        public Recibo () {
            this.detalles = new List<Detalle>();
        }
    }

    public class Detalle {
        public String descripcion { get; set; }
        public Decimal premio { get; set; }
        public Decimal premioSegunFormaDePago { get; set; }

        public Detalle () {  }
    }
}