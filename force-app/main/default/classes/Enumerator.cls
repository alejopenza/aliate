public with sharing class Enumerator {

    public enum Ramo {
        AUTOMOTOR,
        ACCIDENTE_PERSONALES
    }

    public enum Producto {
        AUTO,
        MOTO,
        AP_24HS_MODULADO,
        AP_INTEGRO_MAX,
        AP_OCASION_TRABAJO
    }

    public enum RangoEtario {
        EDAD_16_A_70,
        EDAD_71_A_75,
        EDAD_76_A_80
    }

    public enum SumaTipo {
        MUERTE,
        ASISTENCIA_MEDICA,
        COSTOS_ENTIERRO,
        INTERNACION_DIARIA,
        SUBVENCION_MUERTE,
        MONTO_FIJO
    }
}