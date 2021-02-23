public inherited sharing class EmisionAPIRequest {

    public InfoCertificado informacionCertificado { get; set; }
    public Integer codigoMoneda { get; set; }// Fijo 1
    public Integer numeroOrganizador { get; set; }
    public Integer numeroProductor { get; set; }
    public Integer codigoProducto { get; set; }
    public Integer tipoRenovacionPoliza { get; set; }
    public Integer codigoGrupoEstadistico { get; set; }


    public EmisionAPIRequest() {    }

    public class InfoCertificado {

        public Integer clienteFacturable { get; set; } // Cód. que indica a quién hay que facturar la póliza
        public InfoRamo infoRamo { get; set; }
        public List<InfoCliente> clientes { get; set; }
        public String comentarios { get; set; } // Comentarios / Observaciones de la Solicitud
        public Integer codigoModulo { get; set; }// Cód. Módulo de Cobertura
        public List<InfoCobertura> coberturas { get; set; }
        public InfoPago pago { get; set; }
        public Integer codigoPago { get; set; }  // Tipo de Pago: 0-Efectivo 1-Debito Bacario  2- Tarjeta Credito 4- CBU
        public List<InfoCapitalAsegurado> capitalesAsegurados { get; private set; } // fijo Null (Lista Vacia)
        public List<InfoBienAsegurado> bienesAsegurados { get; private set; } // fijo Null (Lista Vacia)
        public Boolean esEmision { get; private set; } // Indicador de Emisión de Póliza (fijo NULL)
        public Integer codigoFrecuenciaPago { get; set; } // Frecuencia de Pago de la póliza
        public Integer polizaId { get; private set; } // ID interno de la póliza (fijo 0)
        public Integer cuotas { get; set; } // Cantidad de Cuotas (pago)
        public InfoCotizacion cotizaciones { get; private set; } // Fijo Null
        public DateTime vigenciaDesde { get; set; } // Vigencia DESDE de la póliza
        public InfoOperatoriaEspecial infoOperatoriaEspecial { get; set; }
        public List<InfoDescuentoEspecial> infoDescuentosEspeciales { get; set; }
        public DateTime vigenciaHasta { get; set; } // Vigencia HASTA de la póliza
        public InfoEnvioDigital infoEnvioDigital { get; set; }

        // SANCOR-ACCIDENTES PERSONALES
        public List<Adicional> adicionales { get; set; }
        public InfoDireccionRiesgo direccionRiesgo { get; set; }
        public Integer capitalesBasicosAsegurados { get; set; }

        public InfoCertificado() {    }
    }

    public class InfoRamo{
        public Integer porcentajeAjuste { get; set; } // Porcentaje de Ajuste Automático
        public Integer porcentajeDescuento { get; private set; } // Porcentaje de Descuento Automático (Fijo 99)
        public Integer codigoTransportaCombustible { get; set; } // Cod. opción Transporta Combustible
        public Boolean conductorMenorDe25 { get; set; } // Conductor menor a 25 años
        public Boolean masDe25KmPorAnio { get; set; } // Recorre más de 25000 kms. al año
        public Boolean guardaEnGarage { get; set; } // Guarda en garage
        public Vehiculo vehiculo { get; set; }

        // SANCOR-ACCIDENTES PERSONALES
        public Integer codActividad { get; set; }
        public Integer codAsistenciaMedicaFarmaceutica { get; set; }
        public Integer codClasificacion{ get; set; }
        public String direccion { get; set; }
        public Integer codCapitalMuerteInvalidez { get; set; }
        public Boolean subsidioPorMuerte { get; set; }
        public Integer capitalMuerte { get; set; }
        public Boolean buenaSalud { get; set; }
        public Boolean zurdo { get; set; }
        public Integer codTarea{ get; set; }

        public InfoRamo() { }
    }

    public class InfoCliente {
        public Integer tipoRol { get; set; } // Tipo de Rol del Cliente
        public Integer codigoAreaTelefono { get; set; } // Cód. de Área (Teléfono)
        public DateTime fechaNacimiento { get; set; } // Fecha de Nacimiento
        public String lugarNacimiento { get; set; } // Lugar de Nacimiento
        public Integer codigoCiudad { get; set; } // Cód. de Localidad
        public String cuit_cuil { get; set; } // Nro. CUIT/CUIL
        public String numeroDocumento { get; set; } // Nro. de Documento
        public String tipoDocumento { get; set; } // Tipo de Documento
        public String email { get; set; } // Dirección de e-mail
        public String nombre { get; set; } // Nombre/s del Cliente
        public String apellido { get; set; } // Apellido del Cliente
        public Integer genero { get; set; } // Sexo del Cliente
        public Integer codigoCondicionIVA { get; set; } // Condición de IVA del Cliente
        public Integer codigoActividadPrincipal { get; set; } // Cód. de Actividad Principal
        public Integer codigoEstadoCivil { get; set; } // Estado Civil del Cliente
        public String telefono { get; set; } // Nro. de Teléfono
        public Integer categoriaMonotributo { get; set; } // Categoría de Monotributista
        public String calle { get; set; } //Dirección (Domicilio) del Cliente (Calle-Nro.)
        public Integer codigoPostal { get; set; } // Cód. Postal del Domicilio del Cliente

        public InfoCliente(){ }
    }

    public class InfoCobertura{
        public Decimal capital { get; set; } // Capital / Suma Asegurada
        public Integer codigoCobertura { get; set; } // Código de la Cobertura
        public Integer porcentajeDeducible { get; set; } // Porcentaje de Deducible
        public Integer codigoTipoDeducible{ get; set; } // Tipo de Deducible

        public InfoCobertura(){ }
    }

    /**
     * - Efectivo: Nada
     * - Debito en Cuenta solo "numeroCuentaDebito", "tipoCuentaDebito", "codigoBanco" y "codigoAgenciaSucursal"
     * - CBU solo "codigoBanco", "codigoAgenciaSucursal" y "cuentaCBU"
     * - Tarjeta solo "codigoMarcaTarjeta", "numeroTarjeta" y "fechaVencimientoTarjeta"*/
    public class InfoPago{
        public String numeroCuentaDebito { get; set; } // Nro. de Cuenta de Débito
        public Integer tipoCuentaDebito { get; set; } // Tipo de Cuenta de Débito
        public Integer codigoBanco { get; set; } // Cód. de Banco
        public Integer codigoAgenciaSucursal { get; set; } // Cód. de Agencia/Sucursal de Débito
        public String cuentaCBU { get; set; } // Nro. de CBU
        public Integer codigoMarcaTarjeta { get; set; } // Cod. Marca de la Tarjeta
        public String numeroTarjeta { get; set; } // Nro. de la Tarjeta
        public DateTime fechaVencimientoTarjeta { get; set; } // Fecha Vencimiento de la Tarjeta

        public InfoPago(){ }
    }

    public class InfoEnvioDigital{
        public String emailEnvio { get; set; } // E-mail para el Despacho Electrónico
        public Boolean envioElectronico { get; set; } // Aplica Despacho Electrónico

        public InfoEnvioDigital(){ }
    }

    /**
     * EMISION:
     * Ramo Automotor/AP: NO APLICA
     */
    public class InfoCapitalAsegurado {
        public Integer codigoCapital { get; set; } // Cód. del Capital Asegurado
        public Decimal importe { get; set; } // Importe del Capital Asegurado

        public InfoCapitalAsegurado(){ }
    }

    /**
     * EMISION:
     * Ramo Automotor/AP: NO APLICA
     */
    public class InfoBienAsegurado {
        public Integer descripcion { get; set; }
        public String codigoBienAsegurado { get; set; }
        public Decimal importeAsegurado { get; set; }

        public InfoBienAsegurado(){ }
    }

    /**
     * EMISION:
     * Ramo Automotor/AP: NO APLICA
     */
    public class InfoCotizacion {
        public List<Long> numerosDeTarifas { get; set; } // Nro. de Tarifa
        public long numeroCotizacion { get; set; } // Nro. de Cotización

        public InfoCotizacion(){ }
    }

    public class InfoOperatoriaEspecial {
        public Integer codigoBanco { get; set; } // Cód. de Banco
        public String numeroContrato { get; set; } // Nro. de Contrato
        public DateTime fechaEfectivaContrato { get; set; } // Fecha de Efecto del contrato
        public DateTime fechaVencimientoContrato { get; set; } // Fecha de Vencimiento/Fin del contrato
        public DateTime fechaVencimientoPrimeraCuota { get; set; } //Fecha de Vencimiento de la primera cuota
        public String idOperacion { get; set; } // ID de Operación / Identificador Único
        public Integer cantidadCoutas { get; set; } // Cantidad de Cuotas del contrato

        public InfoOperatoriaEspecial(){ }
    }

    public class InfoDescuentoEspecial {
        public Decimal importe { get; set; } // Importe del descuento (con Porcentaje cero)
        public Decimal porcentaje { get; set; } // Porcentaje del descuento (con Importe cero)
        public Integer codigoDescuento { get; set; } // Cód. del descuento

        public InfoDescuentoEspecial(){ }
    }



/**----------------------------------------------------------------*/
/**--------------------------Solo para AP--------------------------*/
/**----------------------------------------------------------------*/
    public class Adicional {
        public Integer capital { get; set; }
        public String descripcion { get; set; }
        public String descripcionCompleta { get; private set; } // no se utiliza
        public Integer codigoAdicional { get; set; }
        public Boolean adicionalObligatorio { get; set; }
        public Boolean seleccionado { get; set; }
        public String descripcionOpcion { get; set; }
        public Integer codigoOpcion { get; set; }

        public Adicional() {    }
    }

    /**
     * EMISION:
     * Ramo AP: APLICA
     * Ramo Automotor: NO APLICA
    */
    public class InfoDireccionRiesgo{
        public Integer puntoCardinal { get; set; } // Punto Cardinal
        public Integer codigoCiudad { get; set; } // Cód. de Localidad
        public Integer codigoPostal { get; set; } // Cód. Postal del Riesgo
        public Integer kilometros { get; set; } // A (determinados) Kilómetros
        public String calle { get; set; } // Calle/Nro. del Riesgo

        public InfoDireccionRiesgo(){ }
    }

/**---------------------------------------------------------------*/
/**----------------------Solo para AUTOMOTOR----------------------*/
/**---------------------------------------------------------------*/
    public class Vehiculo {
        public String numeroChasis { get; set; } // Nro. de Chasis
        public String licencia { get; set;} // Nro. de Patente
        public String numeroMotor { get; set;} // Nro. de Motor
        public Boolean tieneQueColocarRastreoSatelital { get; set;} // Debe colocar el Equipo de Rastreo Satelital
        public String codigoModeloInfoAuto { get; set;} // Código del Vehículo según InfoAuto
        public Integer codigoUso { get; set;} // Código de Uso del vehículo
        public Decimal valor { get; set;} // Valor del vehículo
        public Integer anio { get; set;} // Año (modelo) de fabricación del vehículo
        public Boolean esCeroKilometro { get; set;} // Indicador de Unidad 0 Km.
        public EquipoGNC equipoGnc { get; set;}
        public InspeccionPrevia inspeccionPrevia { get; set; }

        public Vehiculo() { }
    }

    public class EquipoGNC {
        public String marcaCilindro1 { get; set; } // Marca del Cilindro 1
        public String numeroCilindro1 { get; set; } //Nro. del Cilindro 1
        public String marcaCilindro2 { get; set; } // Marca del Cilindro 2
        public String numeroCilindro2 { get; set; } //Nro. del Cilindro 2
        public String marcaCilindro3 { get; set; } // Marca del Cilindro 3
        public String numeroCilindro3 { get; set; } //Nro. del Cilindro 3
        public String marcaCilindro4 { get; set; } // Marca del Cilindro 4
        public String numeroCilindro4 { get; set; } //Nro. del Cilindro 4
        public Decimal valor { get; set; } // Valor total del equipo de GNC
        public String marcaRegulador { get; set; } // Marca del Regulador
        public String numeroRegulador { get; set; } // Nro. del Regulador

        public EquipoGNC(){ }
    }

    public class InspeccionPrevia{
        public String comentario { get; set; } // Comentarios
        public List<ArchivoAdjunto> archivosAdjuntos { get; set; }
        public Integer codigoTipoCombustible { get; set; } // Tipo de Combustible
        public Integer codigoAspectoGeneral { get; set; } // Aspecto General
        public Integer codigoEstadoCristales { get; set; } // Estado de los Cristales
        public DateTime fecha { get; set; } // Fecha de la Inspección Previa
        public Integer codigoResultado { get; set; } //Resultado general de la Inspección Previa
        public Decimal kilometraje { get; set; } //Kilometraje de la unidad al momento de la Inspección
        public Integer codigoEstadoPintura { get; set; } // Estado de la Pintura
        public Integer codigoTipoPintura { get; set; } // Tipo de Pintura
        public Integer codigoAspectoChapa { get; set; } // Aspecto de la Chapa
        public Integer codigoEstadoNeumatico { get; set; } // Estado de los Neumáticos
        public Integer codigoEstadoTapizado { get; set; } // Estado del Tapizado
        public Integer codigoColorTapizado { get; set; } // Color del Tapizado
        public Integer codigoTipoTapizado { get; set; } // Tipo de Tapizado
        public String colorVehiculo { get; set; } // Color de la Unidad
        public Integer codigoTipoLlantas { get; set; } // Tipo de Llantas

        public InspeccionPrevia(){
            this.archivosAdjuntos = new List<ArchivoAdjunto>();
        }
    }

    public class ArchivoAdjunto {
        public String nombre { get; set; } // Nombre del archivo adjunto
        public String contenido { get; set; } // Contenido del archivo adjunto (Base64)

        public ArchivoAdjunto(){ }
    }
}