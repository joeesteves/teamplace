defmodule Teamplace.Combustible do
  alias Teamplace.Factura
  alias Teamplace.Factura.{Producto, Concepto}
  alias Decimal, as: D

  @decimals 3

  def cargar(%Factura{} = factura, numero_comprobante, proveedor_codigo, cantidad, neto, exento) do
    %{factura | NumeroComprobante: numero_comprobante, Proveedor: proveedor_codigo}
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
    |> to_fixed([Productos: [:Cantidad, :Precio], Conceptos: [:ConceptoImporte, :ConceptoImporteGravado]])
  end

  def to_fixed(struct, [ {k, v} | tail]) do
    Map.update!(struct, k, fn k ->
      Enum.map(k, &(to_fixed(&1, v)))
    end)
    |> to_fixed(tail)
  end

  def to_fixed(struct, [ k | tail]) do
    Map.update!(struct, k, &(fix(&1)))
    |> to_fixed(tail)
  end

  def to_fixed(struct, []), do: struct

  def fix(decimal), do: decimal |> D.to_float |> :erlang.float_to_binary([:compact, { :decimals, @decimals }])

end
