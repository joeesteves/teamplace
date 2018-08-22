defmodule Teamplace do
  @moduledoc """
  Documentation for Teamplace Wrapper API.
  """
  @type credentials :: %{client_id: String.t, client_secret: String.t}

  alias Teamplace.Helpers
  @doc """
    Get Data


  """
  @spec get_data(credentials, String.t, String.t, Map.t) :: Map.t
  def get_data(credentials, resource, action, params \\ nil) do
    case HTTPoison.get!(url_factory(credentials, resource, action, params), [], recv_timeout: :infinity) do
      #status_code is invalid token
      %HTTPoison.Response{status_code: 406, body: body} ->
        new_token(credentials)
        get_data(credentials, resource, action)
      %HTTPoison.Response{body: ""} ->
        []
      %HTTPoison.Response{body: body} ->
        Poison.decode!(body)
    end
  end

  @doc """
  Get's actual token is exists or generates new one

  ## Examples

    iex> Teamplace.get_token(%{client_id: System.get_env("TEAMPLACE_CLIENT_ID"), client_secret: System.get_env("TEAMPLACE_CLIENT_SECRET")})
    ...> |> String.match?(~r/[\\d, \\w]{41}/)
    true
  """
  def get_token(%{client_id: client_id} = credentials) do
    Agent.get(:teamplace, & &1[client_id]) || new_token(credentials)
  end

  def post_data(end_point, data) do
    headers = [{"content-type", "application/json"}]
    error = {:error, "Hubo un error"}

    case HTTPoison.post(end_point, data, headers) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> {:ok, "Registro Creado"}
      {:ok, _} -> error
      {:error, _} -> error
    end
  end

  defp url_factory(credentials, resource, action, params) do
    Application.get_env(:teamplace, :api_base) <>
      resource <>
      "/" <>
      action <>
      "?ACCESS_TOKEN=" <>
      get_token(credentials) <>
      Helpers.param_query_parser(params)
  end

  defp save_session(token, credentials) do
    Agent.update(:teamplace, &Map.put(&1, credentials["client_id"], token))
    token
  end

  defp new_token(credentials) do
    auth_url(credentials)
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> save_session(credentials)
  end

  defp auth_url(%{client_id: client_id, client_secret: client_secret}) do
    Application.get_env(:teamplace, :api_base) <>
      "oauth/token?grant_type=client_credentials&client_id=#{client_id}&client_secret=#{
        client_secret
      }"
  end
end
