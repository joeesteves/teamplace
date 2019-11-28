defmodule Teamplace.Asiento.Item do
  alias Teamplace.Asiento.Item
  alias Teamplace.Shared.DimensionDistribucion

  defstruct CuentaID: "",
            DebeHaber: "",
            ImporteMonTransaccion: "",
            ImporteMonPrincipal: "",
            Descripcion: "",
            DimensionDistribucion: []

  def add_dimension(%Item{} = item, dimension_codigo, distribucion_codigo) do
    Map.update!(item, :DimensionDistribucion, fn dim_dist ->
      dim_dist ++
        [
          %DimensionDistribucion{
            dimensionCodigo: dimension_codigo,
            distribucionCodigo: distribucion_codigo
          }
        ]
    end)
  end
end

defmodule Teamplace.Asiento.Cotizacion do
  defstruct MonedaID: "PES",
            Cotizacion: "1"
end

defmodule Teamplace.Asiento do
  alias Teamplace.Asiento
  alias Teamplace.Asiento.Cotizacion

  defstruct EmpresaID: "INT",
            TransaccionTipoID: "ASIENTOGENERICO",
            TransaccionSubtipoID: "AG",
            Fecha: "#{Date.utc_today()}",
            FechaComprobante: "#{Date.utc_today()}",
            MonedaID: "PES",
            AsientoItems: [],
            AsientoGenericoCotizaciones: [%Cotizacion{}],
            Descripcion: ""

  def add_dolar_price(%Asiento{} = asiento) do
    Map.update!(asiento, :AsientoGenericoCotizaciones, fn cot ->
      cot ++
        [
          %Cotizacion{
            MonedaID: "DOL",
            Cotizacion: Teamplace.Helper.bcra_dolar_price()
          }
        ]
    end)
  end
end
