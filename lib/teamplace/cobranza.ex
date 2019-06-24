defmodule Teamplace.Cobranza.Banco do
  defstruct OperacionBancariaCodigo: "DEPOSEFECT",
            CuentaCodigo: "MERCADO_PAGO",
            DebeHaber: "1",
            ImporteMonTransaccion: "95",
            MonedaCodigo: "PES",
            Descripcion: ""
end

defmodule Teamplace.Cobranza.Otros do
  defstruct CuentaCodigo: "GASBAN",
            DebeHaber: "1",
            ImporteMonTransaccion: "5",
            MonedaCodigo: "PES",
            Descripcion: ""
end

defmodule Teamplace.Cobranza.CtaCte do
  defstruct CuentaCodigo: "CLIENTES",
            DebeHaber: "-1",
            ImporteMonTransaccion: "100",
            ImporteMonPrincipal: "100",
            MonedaCodigo: "PES",
            Descripcion: ""
end

defmodule Teamplace.Cobranza.Cotizacion do
  defstruct MonedaCodigo: "",
            Cotizacion: ""
end

# "AplicacionOrigen": "Tipo: String, Obligatorio: No, Descripción: Identificacion Externa de la transaccion origen a aplicar",

defmodule Teamplace.Cobranza do
  alias Teamplace.Cobranza
  alias Teamplace.Cobranza.{Banco, Otros, CtaCte, Cotizacion}

  defstruct IdentificacionExterna: Teamplace.Helper.uuid(),
            EmpresaCodigo: "PRUEBA39",
            Proveedor: "0292",
            TransaccionTipoCodigo: "OPERTESORERIA",
            TransaccionSubtipoCodigo: "COBRANZA",
            Fecha: "#{Date.utc_today()}",
            DiferenciaCambio: "1",
            UsaCotizacionOrigen: "1",
            Descripcion: "",
            Banco: [],
            Otros: [],
            CtaCte: [],
            Cotizaciones: [%Cotizacion{MonedaCodigo: "PES", Cotizacion: "1"}]

  def add_bank(%Cobranza{} = cobranza, %Banco{} = banco) do
    Map.update!(cobranza, :Banco, &[banco | &1])
  end

  def add_others(%Cobranza{} = cobranza, %Otros{} = otros) do
    Map.update!(cobranza, :Otros, &[otros | &1])
  end

  def add_cta_cte(%Cobranza{} = cobranza, %CtaCte{} = cta_cte) do
    Map.update!(cobranza, :CtaCte, &[cta_cte | &1])
  end

  def add_dolar_price(%Cobranza{} = cobranza) do
    Map.update!(cobranza, :Cotizaciones, fn cot ->
      [
        %Cotizacion{
          MonedaCodigo: "DOL",
          Cotizacion: Teamplace.Helper.bcra_dolar_price()
        }
        | cot
      ]
    end)
  end
end

# {
#   "IdentificacionExterna": "Tipo: String, Obligatorio: No, Descripción: Identificación externa",
#   "EmpresaCodigo": "Tipo: String, Obligatorio: Si, Consulte la API /Empresa/list",
#   "NumeroComprobante": "Tipo: String, Obligatorio: No, Descripción: Numero de documento",
#   "Proveedor": "Tipo: String, Obligatorio: Si, Consulte la API /Proveedor/list",
#       "TransaccionTipoCodigo": "Tipo: String, Obligatorio: Sí, Valor a completar: OPERTESORERIA ",
#       "TransaccionSubtipoCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /TransaccionSubtipo/list",
#       "Fecha": "Tipo: Date, Obligatorio: Si, Descripción: aaaa-mm-dd",
#       "Nombre": "Tipo: String. Sólo para GET",
#       "DiferenciaCambio": "Tipo: INT. Descripción: Coloque 0 para opción Asumir, 1 para No Asumir, 2 para opción Generar Documento, 3 para opción Segmentar",
#       "UsaCotizacionOrigen": "Tipo: Boolean. Descripción: Coloque 0 para No, 1 para Sí",
#       "Descripcion": "Tipo: String, Obligatorio: No",
#       "CajaCodigo": "Tipo: String, Obligatorio: No. Consulte la API /Caja/list",
#       "CobradorCodigo": "Tipo: String, Consulte la API /Persona/listAll (No obligatoria)",
#       "Banco": [
#         {
#           "OperacionBancariaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /OperacionBancaria/list",
#           "CuentaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /Cuenta/list",
#           "DebeHaber": "Tipo: INT. Descripción: Coloque 1 para Debe o -1 para Haber",
#           "ImporteMonTransaccion": "Tipo: Decimal. Obligatorio: Sí",
#           "MonedaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /Moneda/list",
#           "Descripcion": "Tipo: String, Obligatorio: No",
#           "DocumentoFisicoID": "Tipo: int, Obligatorio: No",
#           "NumeroDocumentoFisico": null,
#           "FechaDocumentoFisico": "Tipo: Date, Obligatorio: No, Descripción: aaaa-mm-dd",
#           "FechaVencimientoDocumentoFisico": "Tipo: Date, Obligatorio: No, Descripción: aaaa-mm-dd",
#           "BancoCodigo": "Tipo: String, Obligatorio: No, Consulte la API /Banco/list",
#           "DimensionDistribucion": [
#             {
#               "dimensionCodigo": "(Tipo) String, (Obligatorio) Si, si lo requiere la transacción. Consulte la API /Dimension/list",
#               "distribucionCodigo": "(Tipo) String, (Obligatorio) No, Pasar el codigo de la dimensión distribucion en caso de querer pasar una distribución por default. No sería necesario pasar distribucionItems",
#               "distribucionItems": [
#                 {
#                   "codigo": "(Tipo) String, (Obligatorio) No, Codigo de registro de la dimension. Ej.: Código de un registro perteneciente a la dimensión Centro de Costo.",
#                   "porcentaje": "(Tipo) Numero, (Obligatorio) No, Porcentaje de distribución"
#                 }
#               ]
#             }
#           ]
#         }
#       ],
#       "Efectivo": [
#         {
#           "CuentaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /Cuenta/list",
#           "DebeHaber": "Tipo: INT. Descripción: Coloque 1 para Debe o -1 para Haber",
#           "ImporteMonTransaccion": "Tipo: Decimal. Obligatorio: Sí",
#           "MonedaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /Moneda/list",
#           "Descripcion": "Tipo: String, Obligatorio: No",
#           "DimensionDistribucion": [
#             {
#               "dimensionCodigo": "(Tipo) String, (Obligatorio) Si, si lo requiere la transacción. Consulte la API /Dimension/list",
#               "distribucionCodigo": "(Tipo) String, (Obligatorio) No, Pasar el codigo de la dimensión distribucion en caso de querer pasar una distribución por default. No sería necesario pasar distribucionItems",
#               "distribucionItems": [
#                 {
#                   "codigo": "(Tipo) String, (Obligatorio) No, Codigo de registro de la dimension. Ej.: Código de un registro perteneciente a la dimensión Centro de Costo.",
#                   "porcentaje": "(Tipo) Numero, (Obligatorio) No, Porcentaje de distribución"
#                 }
#               ]
#             }
#           ]
#         }
#       ],
#       "Tarjeta": [
#         {
#           "OperacionBancariaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /OperacionBancaria/list",
#           "CuentaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /Cuenta/list",
#           "DebeHaber": "Tipo: INT. Descripción: Coloque 1 para Debe o -1 para Haber",
#           "ImporteMonTransaccion": "Tipo: Decimal. Obligatorio: Sí",
#           "MonedaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /Moneda/list",
#           "Descripcion": "Tipo: String, Obligatorio: No",
#           "NumeroDocumentoFisico": null,
#           "DocumentoTitular": "Tipo: String, Obligatorio: No",
#           "FechaDocumento": "Tipo: Date, Obligatorio: No, Descripción: aaaa-mm-dd",
#           "FechaVencimiento": "Tipo: Date, Obligatorio: No, Descripción: aaaa-mm-dd",
#           "NumeroAutorizacionTarjeta": "Tipo: String, Obligatorio: No",
#           "NumeroTarjeta": "Tipo: String, Obligatorio: No",
#           "NumeroLote": "Tipo: String, Obligatorio: No",
#           "Titular": "Tipo: String, Obligatorio: No",
#           "BancoCodigo": "Tipo: String, Obligatorio: No, Consulte la API /Banco/list"
#         }
#       ],
#       "Otros": [
#         {
#           "CuentaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /Cuenta/list",
#           "DebeHaber": "Tipo: INT. Descripción: Coloque 1 para Debe o -1 para Haber",
#           "ImporteMonTransaccion": "Tipo: Decimal. Obligatorio: Sí.",
#           "MonedaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /Moneda/list",
#           "Descripcion": "Tipo: String, Obligatorio: No",
#           "DimensionDistribucion": [
#             {
#               "dimensionCodigo": "(Tipo) String, (Obligatorio) Si, si lo requiere la transacción. Consulte la API /Dimension/list",
#               "distribucionCodigo": "(Tipo) String, (Obligatorio) No, Pasar el codigo de la dimensión distribucion en caso de querer pasar una distribución por default. No sería necesario pasar distribucionItems",
#               "distribucionItems": [
#                 {
#                   "codigo": "(Tipo) String, (Obligatorio) No, Codigo de registro de la dimension. Ej.: Código de un registro perteneciente a la dimensión Centro de Costo.",
#                   "porcentaje": "(Tipo) Numero, (Obligatorio) No, Porcentaje de distribución"
#                 }
#               ]
#             }
#           ]
#         }
#       ],
#       "Retenciones": [
#         {
#           "RetencionCodigo": "Tipo: String, Obligatorio: No, Consulte la API /Retencion/list",
#           "Importe": "Tipo: Decimal. Obligatorio: Sí",
#           "ISAR": "Tipo: Decimal. Obligatorio: No",
#           "ISARAcumulado": "Tipo: Decimal. Obligatorio: No",
#           "Fecha": "Tipo: Date, Obligatorio: Si, Descripción: aaaa-mm-dd",
#           "NumeroRetencion": "Tipo: String, Obligatorio: Si"
#         }
#       ],
#       "Cotizaciones": [
#         {
#           "MonedaCodigo": "Tipo: String, Obligatorio: No, Consulte la API /Moneda/list",
#           "Cotizacion": "Tipo: Decimal. Obligatorio: No"
#         }
#       ],
#       "CtaCte": [
#         {
#           "CuentaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /Cuenta/list",
#           "DebeHaber": "Tipo: INT. Descripción: Coloque 1 para Debe o -1 para Haber",
#           "ImporteMonTransaccion": "Tipo: Decimal. Obligatorio: Sí",
#           "ImporteMonPrincipal": "Tipo: Decimal. Obligatorio: Sí",
#           "MonedaCodigo": "Tipo: String, Obligatorio: Sí, Consulte la API /Moneda/list",
#           "Descripcion": "Tipo: String, Obligatorio: No",
#           "AplicacionOrigen": "Tipo: String, Obligatorio: No, Descripción: Identificacion Externa de la transaccion origen a aplicar",
#           "DimensionDistribucion": [
#             {
#               "dimensionCodigo": "(Tipo) String, (Obligatorio) Si, si lo requiere la transacción. Consulte la API /Dimension/list",
#               "distribucionCodigo": "(Tipo) String, (Obligatorio) No, Pasar el codigo de la dimensión distribucion en caso de querer pasar una distribución por default. No sería necesario pasar distribucionItems",
#               "distribucionItems": [
#                 {
#                   "codigo": "(Tipo) String, (Obligatorio) No, Codigo de registro de la dimension. Ej.: Código de un registro perteneciente a la dimensión Centro de Costo.",
#                   "porcentaje": "(Tipo) Numero, (Obligatorio) No, Porcentaje de distribución"
#                 }
#               ]
#             }
#           ]
#         }
#       ]
#     }
