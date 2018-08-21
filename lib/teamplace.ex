defmodule Teamplace do
  @moduledoc """
  Documentation for Teamplace Wrapper API.
  """
  @type credentials :: %{client_id: String.t, client_secret: String.t}

  @doc """
    Get Data


  """
  @spec get_data(credentials, String.t, String.t, Map.t) :: Map.t
  def get_data(credentials, resource, action, _params \\ nil) do
    case HTTPoison.get!(url_factory(credentials, resource, action), [], recv_timeout: :infinity) do
      %HTTPoison.Response{status_code: 406} ->
        new_token(credentials)
        get_data(credentials, resource, action)

      %HTTPoison.Response{body: body} ->
        Poison.decode!(body)
    end
  end

  @doc """
  Get's actual token is exists or generates new one

  ## Examples

    get_token({client_id: "my_client_id", client_secret: "my_client_secret"})
    "returned_token_string"

  """
  def get_token(%{client_id: client_id, client_secret: client_secret} = credentials) do
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

  defp url_factory(credentials, resource, action) do
    Application.get_env(:teamplace, :api_base) <>
      resource <>
      "/" <>
      action <>
      "?ACCESS_TOKEN=" <>
      get_token(credentials) <>
      "&PARAMWEBREPORT_TipoCheque=0&PARAMWEBREPORT_Estado=emitido&PARAMWEBREPORT_MostrarSoloNoConciliados=1&PARAMWEBREPORT_Empresa=EMPRE01"
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

  defp auth_url(credentials) do
    %{client_id: client_id, client_secret: client_secret} = credentials

    Application.get_env(:teamplace, :api_base) <>
      "oauth/token?grant_type=client_credentials&client_id=#{client_id}&client_secret=#{
        client_secret
      }"
  end
end
