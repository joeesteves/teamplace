defmodule Teamplace.Helpers do
  @moduledoc """
    Templace helper functions
  """

  @doc """
  Receives a map of key values and an optional prefix and returns a query params string

  ## Example

    iex> Teamplace.Helpers.param_query_parser(%{TipoCheque: 0})
    "&PARAMWEBREPORT_TipoCheque=0"

    iex> Teamplace.Helpers.param_query_parser(nil)
    ""

  """
  @spec param_query_parser(Map.t()) :: String.t()
  def param_query_parser(nil), do: ""

  def param_query_parser(params) do
    clean_nils(params)
    |> Enum.reduce("", fn {k, v}, acc ->
      "#{acc}&#{Application.get_env(:teamplace, :query_prefix)}#{k}=#{v}"
    end)
    |> URI.encode()
  end

  def uuid do
    :rand.uniform()
    |> Float.to_string()
    |> String.replace(~r/0\./, "")
    |> String.slice(0..8)
  end

  defp clean_nils(map) do
    for {k, v} <- map, not is_nil(v), into: %{}, do: {k, v}
  end
end
