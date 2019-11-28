# Teamplace

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `teamplace` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:teamplace, "~> 0.1.0"}
  ]
end
```

## Config

In your config.exs you can override this defaults atributes:

api_base: "https://3.teamplace.finneg.com/BSA/api/"
query_prefix: "PARAMWEBREPORT_"

Like this
```elixir
config :teamplace, api_base: "https://different_api_base.com/api, query_prefix: "QueryParamPrefix"
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/teamplace](https://hexdocs.pm/teamplace).

#Asientos

```ex
credentials = Application.get_env(:teamplace, :credentials)                                                                               %{
  client_id: "####",
  client_secret: "#####"
}
debe = %Teamplace.Asiento.Item{
  DebeHaber: 1,
  CuentaID: "GGUIAS",
  ImporteMonTransaccion: "100", ImporteMonPrincipal: "100"
  }
  |> Item.add_dimension("DIMCTC", "ADMIN")

haber = %Teamplace.Asiento.Item{
  DebeHaber: -1,
  CuentaID: "CAJA",
  ImporteMonTransaccion: "100", ImporteMonPrincipal: "100"
  }
  |> Item.add_dimension("DIMAPARFIN", "CF")

asiento = %Teamplace.Asiento{
  AsientoItems: [debe, haber]
  }
  |> Teamplace.Asiento.add_dolar_price
  |> Poison.encode!

Teamplace.post_data(credentials, "asiento", asiento)
{:ok, "Succesfully posted"}
```
