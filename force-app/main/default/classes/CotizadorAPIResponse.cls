/** Representa la Cotizacion de los distintos servicios para cotizar. */
public class CotizadorAPIResponse {

    public List<Plan> planes { get; set;}
    public Integer idCotizacionRelacion { get; set;} // id sancor que engloba todas las cotizaciones
    public Integer idCotizacion { get; set;} // id sancor de la Cotizacion del modulo


    public CotizadorAPIResponse() {
        this.idCotizacionRelacion = -1;
        this.idCotizacion = -1;
        this.planes = new List<Plan>();
    }

    public class Plan {

        /* ACCIDENTE PERSONALES */
        public Enumerator.RangoEtario rango { get; set; }
        public Integer idCotizacion { get; set; }
        public List<Validacion> validaciones { get; set;}

        /* AUTOMOTOR */
        public Integer moduloCodigo { get; set; }
        public String clienteDescripcion { get; set; }
        public String descripcionLarga { get; set; }
        public String descripcionCorta { get; set; }
        public String resultadoValidacion { get; set; }
        public String mensajeInformativo { get; set; }
        public Boolean poseeEquipoDeRastreo { get; set; }
        public Boolean fueraDeNorma { get; set; }
        // public Boolean poseeTelematica { get; set; } //OBS: Actualmente no se utiliza
        public Decimal valuacionDelVechiculo { get; set; }
        // public List<CalculosAdicionales> calculosAdicionales { get; set; }  //OBS: Actualmente no se utiliza
        public Integer idPreciosAPF { get; set; } // Accidente Personales

        /* GENERAL */
        public List<SumaAsegurada> sumasAseguradas { get; set;}
        public Decimal premioMensual { get; set; }
        public Decimal premioTotal { get; set; }
        public Boolean cotizacionExitosa { get; set; }
        public Integer idPrecios { get; set; }
        public Integer idPreciosValor { get; set; }

        // Vienen del tag TaxBases
        public Decimal ivaMensual { get; set; }
        public Decimal ivaTotal { get; set; }

        // Vienen del tag PrimaTotal
        public Decimal primaPuraMensual { get; set; }
        public Decimal PrimaPuraTotal { get; set; }

        public Plan() {
            this.validaciones = new List<Validacion>();
            this.sumasAseguradas = new List<SumaAsegurada>();
            this.moduloCodigo = 0;
            this.clienteDescripcion = '';
            this.descripcionLarga = '';
            this.descripcionCorta = '';
            this.mensajeInformativo = '';
            this.premioMensual = 0;
            this.premioTotal = 0;
            this.cotizacionExitosa = false;
            this.resultadoValidacion = '';
            this.fueraDeNorma = false;
            this.poseeEquipoDeRastreo = false;
            // this.poseeTelematica = false; //OBS: Actualmente no se utiliza
            this.valuacionDelVechiculo = 0;
            // this.calculosAdicionales = new List<CalculosAdicionales>();  //OBS: Actualmente no se utiliza
            this.idCotizacion = -1;
            this.idPrecios = -1;
            this.idPreciosAPF = -1;
            this.ivaMensual = 0;
            this.ivaTotal = 0;
            this.primaPuraMensual = 0;
            this.PrimaPuraTotal = 0;
        }
    }

    public class SumaAsegurada {

        public Decimal capital { get; set; }
        public String descripcion { get; set; }
        public String detalle { get; set; }
        public Integer detalleCodigo { get; set; }
        public Decimal primaPuraMensual { get; set; }
        public Decimal primaPuraTotal { get; set; }
        public String detalleTipo { get; set; }

        public SumaAsegurada() {
            this.capital = 0;
            this.descripcion = '';
            this.detalle = '';
            this.detalleCodigo = -1;
            this.primaPuraMensual = 0;
            this.primaPuraTotal = 0;
            this.detalleTipo = '';
        }
    }

    //OBS: Actualmente no se utiliza
    // public class CalculosAdicionales {

    //     public Decimal baseCalculoAdicional { get; set; }

    //     public CalculosAdicionales() {
    //         this.baseCalculoAdicional = 0;
    //     }
    // }

    /** Accidentes Personales */
    public class Validacion {
        public String mensajeDeError { get; set; }
        public String nivel { get; set; }
        // public String miembros { get; set; } // No se utiliza

        public Validacion() {
            this.mensajeDeError = '';
            this.nivel = '';
        }
    }
}