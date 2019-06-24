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
            DiferenciaCambio: "1",
            UsaCotizacionOrigen: "1",
            Descripcion: "",
            Banco: [],
            Otros: [],
            CtaCte: [],
            Cotizaciones: [%Cotizacion{MonedaCodigo: "PES", Cotizacion: "1"}]

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
