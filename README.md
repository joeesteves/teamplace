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
config :teamplace, api_base: "https://diferntapibase.com/api, query_prefix: "QueryParamPrefix"
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/teamplace](https://hexdocs.pm/teamplace).
