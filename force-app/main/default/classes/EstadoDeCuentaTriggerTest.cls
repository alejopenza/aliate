@IsTest
public class EstadoDeCuentaTriggerTest {

    @TestSetup
    static void makeData(){ }

    @IsTest
    private static void test(){
        // Generamos N pago__c en base al estado de cuenta insertado.

        //Setup(Given)
        Estado_de_Cuenta__c newAccountStatus =
        Build.aEstadoDeCuenta()
            .withCuotas(6)
            .withImporte(600.00)
            .withModoDePago('Tarjeta de Credito')
            .withSaldo(200.00)
            .withTotalPagos(400.00)
            .withNumeroDeTarjeta(Long.valueOf('1212121212121212'))
            .build();

        //Exercise(When)
        Test.startTest();
        insert newAccountStatus;
        Test.stopTest();

        //Test(Then)
        List<Pago__c> pagos = [ SELECT id, Importe__c, Estado__c, Estado_Cuenta__c FROM Pago__c ];
        Integer cuotasPagas = 0;
        Integer cuotasImpagas = 0;

        System.assertEquals(6, pagos.size(), 'Son 6 cuotas que tiene que generar!');
        for (Pago__c pago : pagos) {
            System.assertEquals(100, pago.Importe__c, 'El monto es de $100, son 6 cuotas. Revisar el handler');
            System.assertEquals(newAccountStatus.id, pago.Estado_Cuenta__c, 'No esta relacionado al mismo estado de cuenta!');
            if ( 'Pagado'.equalsIgnoreCase(pago.Estado__c) ){
                cuotasPagas += 1;
            } else {
                cuotasImpagas += 1;
            }
        }
        System.assertEquals(4, cuotasPagas, 'Tiene que haber 4 cuotas pagas generadas');
        System.assertEquals(2, cuotasImpagas, 'Tiene que haber 2 cuotas NO pagadas generadas');
    }
}