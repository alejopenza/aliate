@isTest
public inherited sharing class OrbisCotizarWebServiceTest {

    @isTest
    private static void orbisCotizarWebServiceTest() {
        CotizadorController.Auto auto = new CotizadorController.Auto();
        auto.uso = false;
        auto.periodoDeValidez = 4;
        auto.km = false;
        auto.anio=2021;
        CotizadorController.Cliente cliente = new CotizadorController.Cliente();
        cliente.Codigo_Postal = 7600;
        cliente.tipoDeDocumento = 'DNI';

        Test.startTest();
        OrbisCotizarWebService controller = new OrbisCotizarWebService();
        Boolean respuesta = controller.cotizar(auto, cliente, null);
        Test.stopTest();

        System.assertEquals(false, respuesta, 'Debería ser false');

    }

}