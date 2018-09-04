defmodule Teamplace do
  @moduledoc """
    Documentation for Teamplace Wrapper API.
  """

  alias Teamplace.Helpers

  @doc """
  Get Data, receives credentials type, resource (i.e. "reportes" || "facturaCompras"), action (i.e. "list")
  and returns a response Map
  """

  @type credentials :: %{client_id: String.t, client_secret: String.t}
  @spec get_data(credentials, String.t, String.t, Map.t) :: Map.t
  def test() do
    get_chunked(Mate.Accounts.get_user!(1).credentials, "reports", "saldosprov")
  end

  def get_chunked(credentials, resource, action, params \\ nil) do
    %HTTPoison.AsyncResponse{id: ref} = HTTPoison.get!(url_factory(credentials, resource, action, params), [], recv_timeout: :infinity, stream_to: self())

    Stream.resource(
      fn -> {"", []} end,
      fn {remanent, acc} ->
        receive do
          %HTTPoison.AsyncChunk{chunk: chunk, id: ^ref} ->
            capture = Regex.named_captures(~r/\[?(?<complete>{.*})?(?<incomplete>.*)\]?/, chunk)
            partial_content = remanent <> capture["complete"]
            next = if (partial_content |> String.match?(~r/(?<=}),/)) do
              partial_content |> String.split(~r/(?<=}),/)
            end || []
            {next, {(partial_content <> capture["incomplete"]) |> String.replace(~r/^,(?={)/, ""), acc ++ next }}

          %HTTPoison.AsyncEnd{id: ^ref  } ->
            {:halt, acc }
        end
      end,
      fn _ -> end
      )
  end

  def db(item) do
    try do
      Poison.decode!(item)
    rescue
      e ->
        IO.puts "------------" <> item <> "---------------"
        %{}
    end
  end

  def print(item) do
    IO.puts String.duplicate("-",60)
    IO.puts item
  end

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

  def post_data(credentials, resource, action, data) do
    headers = [{"content-type", "application/json"}]
    error = {:error, "Hubo un error"}

    case HTTPoison.post(url_factory(credentials, resource, action), data, headers) do
      %HTTPoison.Response{status_code: 406} ->
        new_token(credentials)
        post_data(credentials, resource, action, data)
      {:ok, %HTTPoison.Response{status_code: 200}} -> {:ok, "Registro Creado"}
      {:ok, _} -> error
      {:error, _} -> error
    end
  end

  def url_factory(credentials, resource, action, params \\ nil) do
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
