defmodule Teamplace do
  @moduledoc """
    Documentation for Teamplace Wrapper API.
  """

  alias Teamplace.Helpers

  def test() do
    get_chunked(Mate.Accounts.get_user!(1).credentials, "reports", "saldosprov")
  end

  def get_chunked(credentials, resource, action, params \\ nil) do
    %HTTPoison.AsyncResponse{id: ref} =
      HTTPoison.get!(
        url_factory(credentials, resource, action, params),
        [],
        recv_timeout: :infinity,
        stream_to: self()
      )

    Stream.resource(
      fn -> "" end,
      fn previus_chunk_remanent ->
        receive do
          %HTTPoison.AsyncChunk{chunk: chunk, id: ^ref} ->
            capture = Regex.named_captures(~r/\[?(?<complete>.*})?(?<incomplete>.*)\]?/, chunk)

            partial_content = previus_chunk_remanent <> capture["complete"]

            next = extract_maps_if_any(partial_content)

            {next, create_chunk_remanent(next, partial_content, capture["incomplete"])}

          %HTTPoison.AsyncEnd{id: ^ref} ->
            {:halt, ""}
        end
      end,
      fn _ -> nil end
    )
    |> Stream.map(&try_decode/1)
  end

  @doc """
  Get Data, receives credentials type, resource (i.e. "reportes" || "facturaCompras"), action (i.e. "list")
  and returns a response Map
  """

  @type credentials :: %{client_id: String.t(), client_secret: String.t()}
  @spec get_data(credentials, String.t(), String.t(), Map.t()) :: Map.t()
  def get_data(credentials, resource, action, params \\ nil) do
    case HTTPoison.get!(
           url_factory(credentials, resource, action, params),
           [],
           recv_timeout: :infinity
         ) do
      # status_code is invalid token
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

      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, "Registro Creado"}

      {:ok, _} ->
        error

      {:error, _} ->
        error
    end
  end

  def url_factory(credentials, resource, action, params \\ nil) do
    Application.get_env(:teamplace, :api_base) <>
      resource <>
      "/" <>
      action <> "?ACCESS_TOKEN=" <> get_token(credentials) <> Helpers.param_query_parser(params)
  end

  defp create_chunk_remanent([], _partial_content, _incomplete), do: ""

  defp create_chunk_remanent(_, partial_content, incomplete) do
    (partial_content <> incomplete)
    |> String.replace(~r/^,(?={)/, "")
  end

  defp extract_maps_if_any(partial_content) do
    if partial_content |> String.match?(~r/(?<=}),/) do
      partial_content |> String.split(~r/(?<=}),/)
    else
      []
    end
  end

  defp db(item) do
    try do
      Poison.decode!(item)
    rescue
      e ->
        IO.puts("------------" <> item <> "---------------")
        %{}
    end
  end

  defp create_chunk_remanent([], _partial_content, _incomplete), do: ""

  defp create_chunk_remanent(_, partial_content, incomplete) do
    (partial_content <> incomplete)
    |> String.replace(~r/^,(?={)/, "")
  end

  defp extract_maps_if_any(partial_content) do
    if partial_content |> String.match?(~r/(?<=}),/) do
      partial_content |> String.split(~r/(?<=}),/)
    else
      []
    end
  end

  defp try_decode(item) do
    try do
      Poison.decode!(item)
    rescue
      e ->
        IO.puts("ERROR DECODING ITEM")
        %{}
    end
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
