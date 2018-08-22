defmodule Teamplace.Factura.Producto.DimensionDistribucion do
  defstruct [:dimensionCodigo, :distribucionCodigo]
end

defmodule Teamplace.Factura.Producto do
  alias Teamplace.Factura.Producto.DimensionDistribucion

  defstruct ProductoCodigo: "",
            Cantidad: "",
            Precio: "",
            DimensionDistribucion: [%DimensionDistribucion{}]
end

defmodule Teamplace.Factura.Concepto do
  defstruct ConceptoCodigo: "",
            ImporteEditable: "1",
            ConceptoImporte: "",
            ConceptoImporteGravado: ""
end

# FACTURA MAIN MODULE
defmodule Teamplace.Factura do
  alias Teamplace.Factura
  alias Teamplace.Factura.{Producto, Concepto}

  defstruct IdentificacionExterna: "",
            EmpresaCodigo: "",
            Fecha: "",
            FechaComprobante: "",
            Proveedor: "",
            CondicionPagoCodigo: "",
            TransaccionTipoCodigo: "OPER",
            TransaccionSubtipoCodigo: "FC",
            WorkflowCodigo: "CPRA-SERCON",
            NumeroComprobante: "",
            MonedaCodigo: "PES",
            ComprobanteTipoImpositivoCodigo: "81",
            ImporteTotalControl: "",
            Productos: [%Producto{}],
            Conceptos: [%Concepto{}]

  def add_product(%Factura{} = factura, %Producto{} = producto) do
    Map.update!(factura, :Productos, &([producto | &1]))
  end
end
