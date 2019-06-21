defmodule TeamplaceTest do
  use ExUnit.Case
  doctest Teamplace
  doctest Teamplace.Helper

  alias Teamplace.Factura
  alias Teamplace.Factura.{Producto, Concepto}

  @tag :factura
  describe "factura" do
    test "the truth" do
      assert Map.get(%Factura{}, :Fecha) == "#{Date.utc_today}"
    end
  end
end
