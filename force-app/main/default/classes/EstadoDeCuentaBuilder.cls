@IsTest
public without sharing class EstadoDeCuentaBuilder {

    private Estado_de_Cuenta__c estado { get; set; }

    public EstadoDeCuentaBuilder() {
        this.estado = new Estado_de_Cuenta__c();
    }

    public EstadoDeCuentaBuilder forPoliza(Asset poliza){
        this.estado.Asset__c = poliza.id;
        return this;
    }

    public EstadoDeCuentaBuilder forCliente(Account cliente){
        this.estado.cuenta__c = cliente.id;
        return this;
    }

    public EstadoDeCuentaBuilder withEstado(String estado){
        this.estado.cuenta__c = estado;
        return this;
    }

    public EstadoDeCuentaBuilder withFechaDeGeneracion(Date fecha){
        this.estado.Fecha_de_Generacion__c = fecha;
        return this;
    }

    public EstadoDeCuentaBuilder withFechaDeVencimiento(Date fecha){
        this.estado.Fecha_de_Vencimiento__c = fecha;
        return this;
    }

    public EstadoDeCuentaBuilder withImporte(Decimal importe){
        this.estado.Importe__c = importe;
        return this;
    }

    public EstadoDeCuentaBuilder withModoDePago(String modoDePago){
        this.estado.Modo_de_Pago__c = modoDePago;
        return this;
    }

    public EstadoDeCuentaBuilder withCuotas(Integer numero){
        this.estado.Cuotas__c = numero;
        return this;
    }

    public EstadoDeCuentaBuilder withNumeroDeTarjeta(Long numero){
        this.estado.Numero_de_Tarjeta__c = numero;
        return this;
    }

    public EstadoDeCuentaBuilder withRecordTypeId(String recordid){
        this.estado.RecordTypeId = recordid;
        return this;
    }

    public EstadoDeCuentaBuilder withSaldo(Decimal saldo){
        this.estado.Saldo__c = saldo;
        return this;
    }

    public EstadoDeCuentaBuilder withTotalPagos(Decimal saldo){
        this.estado.Total_Pagos__c = saldo;
        return this;
    }

    public Estado_de_Cuenta__c build(){
        return this.estado;
    }
}