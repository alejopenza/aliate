public with sharing class SanCristobalCotizador {
    public SanCristobalCotizador() {

    }

    public static CotizadorController.Wrapper doSanCristobalCallout(CotizadorController.Wrapper result, CotizadorController.Auto auto, CotizadorController.Cliente cliente){
        system.debug('doSanCristobalCallout()');

        SCApiQuote api = new SCApiQuote();
        SCApiQuote.Wrapper response = api.getDataFromAPI(auto, cliente);

        if(!response.hasError){
            for(SanCristobalCotizacionResponse.Summaries summary : response.response.Summaries){
                CotizadorController.CotizacionSanCristobal cotizacion = new CotizadorController.CotizacionSanCristobal();
                //todo mapear campos de la respuesta
                //cotizacion.campo = 
                cotizacion.aseguradora = 'SAN CRISTÓBAL';
                cotizacion.descripcion = summary.Vehicles[0].Category.Description;
                cotizacion.premioTotal = summary.Summary.TotalCost.Amount;
                result.cotizacionesSanCristobal.add(cotizacion);
            }
        }else{
            result.hasError = true;
            for(SanCristobalCotizadorResAutoErro.Messages errorMsg : response.errorResponse.Messages){
                result.errors.add(errorMsg.Description);
            }
        }

        return result;
    }
}