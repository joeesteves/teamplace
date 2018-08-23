defmodule Teamplace.Factura.Producto.DimensionDistribucion do
  defstruct dimensionCodigo: "DIMCTC", distribucionCodigo: "ADMIN"
end

defmodule Teamplace.Factura.Producto do
  alias Teamplace.Factura.Producto.DimensionDistribucion

  defstruct ProductoCodigo: "GASOIL",
            Cantidad: "",
            Precio: "",
            DimensionDistribucion: [
              %DimensionDistribucion{}
            ]
end

# IMPINT -> Impuestos Internos
# COMPRA_IVA_21 -> Iva 21%
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
            EmpresaCodigo: "INT",
            Fecha: "#{Date.utc_today()}",
            FechaComprobante: "#{Date.utc_today()}",
            Proveedor: "",
            CondicionPagoCodigo: "15",
            TransaccionTipoCodigo: "OPER",
            TransaccionSubtipoCodigo: "FC",
            WorkflowCodigo: "CPRA-SERCON",
            NumeroComprobante: "",
            MonedaCodigo: "PES",
            ComprobanteTipoImpositivoCodigo: "81",
            ImporteTotal: "",
            ImporteTotalControl: "",
            Productos: [],
            Conceptos: []

  def add_product(%Factura{} = factura, %Producto{} = producto) do
    Map.update!(factura, :Productos, &[producto | &1])
  end

  def add_concepto(%Factura{} = factura, %Concepto{} = concepto) do
    Map.update!(factura, :Conceptos, &[concepto | &1])
  end
end
