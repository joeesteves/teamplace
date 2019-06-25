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
            Cotizacion: 1,
            MonedaCodigo: "PES",
            Descripcion: ""
end

defmodule Teamplace.Cobranza.Cotizacion do
  defstruct MonedaCodigo: "",
            Cotizacion: ""
end

# "AplicacionOrigen": "Tipo: String, Obligatorio: No, Descripción: Identificacion Externa de la transaccion origen a aplicar",
defmodule Teamplace.Cobranza do
  @moduledoc """
    JSON example on doc/cobranza.json
  """

  alias Teamplace.Cobranza
  alias Teamplace.Cobranza.{Banco, Otros, CtaCte, Cotizacion}

  defstruct IdentificacionExterna: Teamplace.Helper.uuid(),
            EmpresaCodigo: "",
            Proveedor: "",
            TransaccionTipoCodigo: "OPERTESORERIA",
            TransaccionSubtipoCodigo: "COBRANZA",
            Fecha: "#{Date.utc_today()}",
            DiferenciaCambio: 0,
            UsaCotizacionOrigen: 0,
            Descripcion: "",
            Banco: [],
            Otros: [],
            CtaCte: [],
            Cotizaciones: [
              %Cotizacion{MonedaCodigo: "PES", Cotizacion: 1.00}
            ]

  def add_banco(%Cobranza{} = cobranza, %Banco{} = banco) do
    Map.update!(cobranza, :Banco, &[banco | &1])
  end

  def add_otros(%Cobranza{} = cobranza, %Otros{} = otros) do
    Map.update!(cobranza, :Otros, &[otros | &1])
  end

  def add_cta_cte(%Cobranza{} = cobranza, %CtaCte{} = cta_cte) do
    Map.update!(cobranza, :CtaCte, &[cta_cte | &1])
  end

  def add_dolar_price(%Cobranza{} = cobranza) do
    Map.update!(cobranza, :Cotizaciones, fn cot ->
      cot ++
        [
          %Cotizacion{
            MonedaCodigo: "DOL",
            Cotizacion: Teamplace.Helper.bcra_dolar_price()
          }
        ]
    end)
  end
end
