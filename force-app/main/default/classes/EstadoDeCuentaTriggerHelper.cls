public inherited sharing class EstadoDeCuentaTriggerHelper {

    // TODO: Metodo provisorio hasta que este la integracion y ahi se defina bien el modelo/flujo. Ahora sirve como un mock.
    public static void crearPagosDeEstadosDeCuenta(List<Estado_de_Cuenta__c> estados){
        List<Pago__c> pagos = new List<Pago__c>();

        for (Estado_de_Cuenta__c estadoCuenta : estados) {
            pagos.addAll(
                generarPagosParaEstadoDeCuenta(estadoCuenta)
            );
        }

        insert pagos;
    }

    private static List<Pago__c> generarPagosParaEstadoDeCuenta(Estado_de_Cuenta__c estado){
        List<Pago__c> pagos = new List<Pago__c>();
        Integer cuotas = Integer.valueOf(estado.Cuotas__c);

        // Calculamos el monto x cuota y la cantidad de cuotas pagadas.
        Double montoCuota = estado.Importe__c / estado.Cuotas__c;
        Integer cuotasPagas = Integer.valueOf(Math.ceil(estado.Total_Pagos__c / montoCuota));

        String estadoDePago;
        Date fechaGeneracion;
        Date fechaVencimiento;
        Date currentDate = Date.today();
        Integer lastDayOfMonth;
        Integer month;
        List<Integer> months = new List<Integer>();

        for (Integer i = 0; i < cuotas; i++) {

            If (i < (cuotasPagas-1)) {
                month = currentDate.addMonths(-(cuotasPagas-1-i)).month();
            } else if ( i == (cuotasPagas-1) ) {
                month = currentDate.month();
            } else {
                month = currentDate.addMonths(i-cuotasPagas).month();
            }

            lastDayOfMonth = Date.daysInMonth(currentDate.year(), month);

            If ( i < cuotasPagas ) {
                estadoDePago = 'Pagado';
            } else {
                estadoDePago = 'Pendiente';
            }

            fechaGeneracion = Date.newInstance(currentDate.year(), month, 1);
            fechaVencimiento = Date.newInstance(currentDate.year(), month, lastDayOfMonth);

            pagos.add(
                new Pago__c(
                    Estado_Cuenta__c = estado.id,
                    Estado__c = estadoDePago,
                    Fecha_de_Generacion__c = fechaGeneracion,
                    Fecha_de_Vencimiento__c = fechaVencimiento,
                    Importe__c = montoCuota
                )
            );
        }
        return pagos;
    }
}