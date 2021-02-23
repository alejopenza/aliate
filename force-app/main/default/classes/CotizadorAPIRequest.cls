/** Representa el pedido de Cotizacion de los distintos servicios. */
public class CotizadorAPIRequest {

    // Generico (Revisado con AP, Auto)
    public Integer numeroDeDocumento { get; set; }
    public Double numeroDeDocumentoDouble { get; set; }
    public String tipoDeDocumento { get; set; }
    public Integer ciudadId { get; set; }
    public Integer codigoPostal { get; set; } // Requerido (Auto)
    public List<Integer> codigosDeModuloDeCoberturas  { get; set; }
    public Integer condicionAnteIVA { get; set; }
    public Integer frecuenciaDePago { get; set; } // Requerido (Auto)
    public List<Descuento> descuentos { get; set; }
    public Integer numeroOrganizacion { get; set; } // Requerido (Auto)
    public Integer numeroProductor { get; set; } // Requerido (Auto)
    public Integer grupoEstadistico { get; set; }
    public Integer periodoDeValidez { get; set; } // Requerido (Auto)
    public Integer cuotas { get; set; }
    public DateTime fechaEfectiva { get; set; } // En Auto es de cotizacion/AP de vigencia

    // Accidentes Personales (AP)
    public Integer codigoPolizaTipo { get; set; }
    public DateTime fechaExpiracion { get; set; }
    public PersonaAsegurada personasAseguradas { get; set; }
    public Boolean respetarCondicionIVACliente { get; set; }

    //Vehiculo Request
    public Boolean personaJuridica { get; set; } // Requerido (Auto)
    public Integer bienAsegurado { get; set; }
    public Vehiculo vehiculo { get; set; } // Requerido (Auto)
    public List<Scoring> scoring { get; set; }

    public CotizadorAPIRequest() {  }

    public Boolean hasPersonaJuridicaFilled(){
        return this.personaJuridica != null;
    }

    public Boolean hasNumeroProductorFilled(){
        return this.numeroProductor != null;
    }

    public Boolean hasNumeroOrganizacionFilled(){
        return this.numeroOrganizacion != null;
    }

    public Boolean hasPeriodoValidezFilled(){
        return this.periodoDeValidez != null;
    }

    public Boolean hasFrecuenciaDePagoFilled(){
        return this.frecuenciaDePago != null;
    }

    public Boolean hasCodigoPostalFilled(){
        return this.codigoPostal != null;
    }

    public Boolean hasVehiculoFilled(){
        return this.vehiculo != null;
    }

    public Boolean hasScoringFilled(){
        return this.scoring != null && ! this.scoring.isEmpty();
    }

    public class Descuento { // Es generico (Auto, AP)
        public Integer codigoDeDescuento { get; set; }
        public Integer porcentaje { get; set; }

        public Descuento() {   }
    }

/**---------------------------------------------------------------------**/
/**------------------------ACCIDENTES PERSONALES------------------------**/
/**---------------------------------------------------------------------**/
    public class PersonaAsegurada {

        public Integer codigoProfesion { get; set; }
        public Integer codigoClasificacion { get; set; }
        public Integer codigoTarea { get; set; }
        public List<RangoEtario> rangoEtario { get; set; }

        public PersonaAsegurada() {   }
    }

    public class RangoEtario {

        public Enumerator.RangoEtario tipoDeRango { get; set; }
        public Boolean seleccionado { get; set; }
        public Integer cantidadDePersonas { get; set; }
        public List<SumaAsegurada> sumas { get; set; }

        public RangoEtario() {   }
    }

    public class SumaAsegurada {

        public Enumerator.SumaTipo tipoDeSuma { get; set; }
        public Integer codigo { get; set; }
        public Integer monto { get; set; }

        public SumaAsegurada() {   }
    }

/**---------------------------------------------------------------------**/
/**------------------------------AUTOMOTOR------------------------------**/
/**---------------------------------------------------------------------**/
    public class Vehiculo {
        public String codigo { get; set; } // Requerido
        public Integer anio { get; set; } // Requerido
        public Integer valor { get; set; }
        public Integer uso { get; set; } // Requerido
        public Boolean tieneGNC { get; set; }
        public Decimal valorEquipoGNC { get; set; }
        public Boolean poseeRuedaDeAuxilio { get; set; }
        public Boolean es0KM { get; set; }
        
        public Vehiculo() { }
        
        public Boolean hasCodigoFilled(){
            return String.isNotBlank(this.codigo);
        }

        public Boolean hasAnioFilled(){
            return this.anio != null;
        }
        
        public Boolean hasUsoFilled(){
            return this.uso != null;
        }
    }

    public class Scoring {
        public Integer tipoId { get; set; }
        public Integer opcionId { get; set; }
    
        public Scoring() {   }
    
        public Boolean hasTipoIdFilled(){
            return this.tipoId != null;
        }
    
        public Boolean hasOpcionIdFilled(){
            return this.opcionId != null;
        }
    }
}