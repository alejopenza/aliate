public inherited sharing class RUSCotizador {

    public RUSCotizador() { }

    public static CotizadorController.Wrapper doQuoteCallout(CotizadorController.Wrapper result, CotizadorController.Auto auto, CotizadorController.Cliente cliente){
        System.debug('doSanCristobalCallout()');

        RUSLoginWebService authenticator = new RUSLoginWebService();
        RUSCotizacionAutoWebService api = new RUSCotizacionAutoWebService();

        if ( authenticator.login() ) {
            RUSCotizacionAutoRequest requestBody = getRequestBody(auto, cliente);

            if ( api.cotizar( requestBody, authenticator.getToken() ) ) {
                result.cotizacionesRUS.addAll(
                    getCotizacion(api.serviceResponse.cotizacion)
                );
                result.hasError = false;
            }else{
                result.hasError = true;
                result.errors.add(api.serviceResponse.message);
            }
        } else {
            result.hasError = true;
            result.errors.add(authenticator.serviceResponse.message);
        }


        return result;
    }

    private static List<CotizadorController.CotizacionRUS> getCotizacion(RUSCotizacionAutoResponse response){
        List<CotizadorController.CotizacionRUS> cotizaciones = new List<CotizadorController.CotizacionRUS>();
        CotizadorController.CotizacionRUS cotizacion;

        for(RUSCotizacionAutoResponse.DtoList summary : response.dtoList){
            cotizacion = new CotizadorController.CotizacionRUS();
            cotizacion.aseguradora = 'RIO URUGUAY SEGUROS';
            cotizacion.descripcionCorta = summary.codigoRC;
            cotizacion.ivaTotal = summary.iva;
            cotizacion.ivaMensual = cotizacion.ivaTotal / 12;
            cotizacion.premioTotal = summary.premio;
            cotizacion.premioMensual = cotizacion.premioMensual / 12; // Se  calcula, si bien es Anual habria que ver los demas cuando se procese
            cotizacion.ajusteAutomatico = summary.ajusteAutomatico;
            cotizacion.ajustesAutomaticosPosibles = summary.ajustesAutomaticosPosibles;
            cotizacion.auxilioMecanico = summary.auxilioMecanico;
            cotizacion.coberturaVida = summary.coberturaVida;
            cotizacion.codigoCasco = summary.codigoCasco;
            cotizacion.codigoRC = summary.codigoRC;
            cotizacion.descripcionCasco = summary.descripcionCasco;
            cotizacion.descripcionComercial = summary.descripcionComercial;
            cotizacion.descripcionRC = summary.descripcionRC;
            cotizacion.detalleCoberturaCasco = summary.detalleCoberturaCasco;
            cotizacion.detalleCoberturaRC = summary.detalleCoberturaRC;
            cotizacion.franquicia = summary.franquicia;
            cotizacion.numeroSolicitud = summary.numeroSolicitud;
            cotizacion.paisesLimitrofes = summary.paisesLimitrofes;
            cotizacion.prima = summary.prima;
            cotizacion.responsabilidadCivil = summary.responsabilidadCivil;
            cotizacion.sumaAsegurada = summary.sumaAsegurada;

            // sumas
            cotizaciones.add(cotizacion);
        }

        return cotizaciones;
    }

    private static RUSCotizacionAutoRequest getRequestBody (CotizadorController.Auto auto, CotizadorController.Cliente cliente) {
        RUSCotizacionAutoRequest request = new RUSCotizacionAutoRequest();
        request.codigoProductor = 10385; // TODO aca iria el codigo del PAS del usuario
	    request.codigoSolicitante = 10385; // TODO aca iria el codigo del PAS del usuario
	    request.codigoTipoInteres = 'VEHICULO'; // Opciones: VEHICULO / MOTOVEHICULO

        // Esto se basa en la parametria de sancor
        switch on cliente.condicionAnteIVA {
            when 1 {
                // 1- Responsable Inscripto
                request.condicionFiscal = 'RI';
            } when 2 {
                // 2- Responsable No Inscripto
                request.condicionFiscal = 'RNI';
            } when 3 {
                // 3- Exento
                request.condicionFiscal = 'EX';
            } when 4 {
                // 4- Consumidor Final
                request.condicionFiscal = 'CF';
            } when 5 {
                // 5- No Declarado
                request.condicionFiscal = '';
            } when 6 {
                // 6- No Alcanzado
                request.condicionFiscal = '';
            } when 7 {
                // 7- Responsable Monotribuito
                request.condicionFiscal = 'RMT';
            } when 8 {
                // 8- Sujeto No Categorizado
                request.condicionFiscal = 'SSF'; //Sin Situacion Fiscal
            } when else { }
        }
        // TODO Faltan mapeos para
        // FM => Resp. Insc. Fact. M
        // GC => Gran Contribuyente
        // CDE => Cliente del Exterior

        // plantear cantidad de cuotas con el tipo de vigencia (Solo permiten anual 3 cuotas)
        request.tipoVigencia = 'ANUAL';
        request.cuotas = 3;
        request.numeroSolicitud = 0; //Esto es para nosotros que ponemos??¿
        request.vigenciaDesde = DateTime.newInstance(
            Date.today().year(),
            Date.today().month(),
            Date.today().day(),
            0,
            0,
            0
        ).format('yyyy-mm-dd');
        request.vigenciaHasta = DateTime.newInstance(
            Date.today().year()+1,
            Date.today().month(),
            Date.today().day(),
            0,
            0,
            0
        ).format('yyyy-mm-dd');

        RUSCotizacionAutoRequest.Vehiculo vehiculo = new RUSCotizacionAutoRequest.Vehiculo();
        // TODO falta control satelital, rastreador a cargo de RUS y cp y locaidad donde guarda el auto.
        vehiculo.anio = String.valueOf(auto.anio);
        vehiculo.controlSatelital = 'NO'; //auto.rastreador ? 'SI' : 'NO'; // Opciones: 'SI' | 'NO'
        vehiculo.cpLocalidadGuarda = cliente.Codigo_Postal;
        vehiculo.gnc = auto.gnc ? 'SI' : 'NO'; // Opciones: 'SI' | 'NO'
        vehiculo.localidadGuarda = '';
        vehiculo.modeloVehiculo = Integer.valueOf(auto.version); //cod infoauto
        vehiculo.rastreadorSatelital = auto.rastreador ? 'SI' : 'NO'; // Opciones: 'SI' | 'NO'
        vehiculo.rastreoACargoRUS = 'NO'; // Opciones: 'SI' | 'NO'
        vehiculo.sumaAseguradaAccesorios = Integer.valueOf(auto.sumaAseguradaAccesorio);
        vehiculo.sumaAseguradaGnc = auto.sumaAseguradaGNC;
        vehiculo.sumaAseguradaVehiculo = String.valueOf(auto.sumaAsegurada); // Si se deja vacio '' cotiza todo
        vehiculo.uso = auto.uso ? 'PARTICULAR' : '';
        request.vehiculos.add(vehiculo);

        return request;
    }
}