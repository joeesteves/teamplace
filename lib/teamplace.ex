defmodule Teamplace do
  use Agent
  @moduledoc """
  Documentation for Teamplace.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Teamplace.hello
      :world

  """
  @api_base "https://3.teamplace.finneg.com/BSA/api/"

  def start_link(_args) do
    IO.inspect Application.get_env(:teamplace, :test)
    Agent.start_link(fn -> %{} end, name: :teamplace)
  end

  def get_token(current_user) do
    Agent.get(:teamplace, & &1[current_user.username]) || new_token(current_user)
  end

  def get_data(current_user, resource, action, _params \\ nil) do
    case HTTPoison.get!(url_factory(current_user, resource, action), [], recv_timeout: :infinity) do
      %HTTPoison.Response{status_code: 406} ->
        new_token(current_user)
        get_data(current_user, resource, action)

      %HTTPoison.Response{body: body} ->
        Poison.decode!(body)
    end
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

  defp url_factory(current_user, resource, action) do
    @api_base <>
      resource <>
      "/" <>
      action <>
      "?ACCESS_TOKEN=" <>
      get_token(current_user) <>
      "&PARAMWEBREPORT_TipoCheque=0&PARAMWEBREPORT_Estado=emitido&PARAMWEBREPORT_MostrarSoloNoConciliados=1&PARAMWEBREPORT_Empresa=EMPRE01"
  end

  defp save_session(token, current_user) do
    Agent.update(:teamplace, &Map.put(&1, current_user.username, token))
    token
  end

  defp new_token(current_user) do
    auth_url(current_user)
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> save_session(current_user)
  end

  defp auth_url(user) do
    %{"client_id" => client_id, "client_secret" => client_secret} = user.credentials

    @api_base <>
      "oauth/token?grant_type=client_credentials&client_id=#{client_id}&client_secret=#{
        client_secret
      }"
  end
end
