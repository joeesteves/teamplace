defmodule Teamplace.Combustible do
  alias Teamplace.Factura
  alias Teamplace.Factura.{Producto, Concepto}
  alias Teamplace.Helper
  alias Decimal, as: D

  @decimals 3

  def cargar(numero_comprobante, proveedor_codigo, cantidad, neto, exento) do
    %Factura{
      IdentificacionExterna: Helper.uuid(),
      NumeroComprobante: numero_comprobante,
      Proveedor: proveedor_codigo,
      ImporteTotal: D.new(neto) |> D.mult(D.new(1.21)) |> D.add(D.new(exento))
    }
    |> Factura.add_product(%Producto{
      Cantidad: D.new(cantidad),
      Precio: D.div(D.new(neto), D.new(cantidad))
    })
    |> Factura.add_concepto(%Concepto{
      ConceptoCodigo: "COMPRA_IVA_21",
      ConceptoImporte: D.mult(D.new(neto), D.new(0.21)),
      ConceptoImporteGravado: D.new(neto)
    })
    |> Factura.add_concepto(%Concepto{
      ConceptoCodigo: "IMPINT",
      ConceptoImporte: D.new(exento),
      ConceptoImporteGravado: D.new(0)
    })
    |> to_fixed([
      :ImporteTotal,
      Productos: [:Cantidad, :Precio],
      Conceptos: [:ConceptoImporte, :ConceptoImporteGravado]
    ])
  end

  def control(%Factura{} = factura, importe_control) do
    %{factura | ImporteTotalControl: D.new(importe_control)}
    |> to_fixed([:ImporteTotalControl])
  end

  defp to_fixed(struct, [{k, v} | tail]) do
    Map.update!(struct, k, fn k ->
      Enum.map(k, &to_fixed(&1, v))
    end)
    |> to_fixed(tail)
  end

  defp to_fixed(struct, [k | tail]) do
    Map.update!(struct, k, &fix(&1))
    |> to_fixed(tail)
  end

  defp to_fixed(struct, []), do: struct

  defp fix(decimal),
    do: decimal |> D.to_float() |> :erlang.float_to_binary([:compact, {:decimals, @decimals}])

end
