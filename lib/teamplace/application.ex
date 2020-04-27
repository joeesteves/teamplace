defmodule Teamplace.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    ensure_required_envs() &&
      IO.puts("Teamplace - All envs are correctly setted ✔")

    children = [
      # Starts a worker by calling: Teamplace.Worker.start_link(arg)
      # {Teamplace.Worker, arg},
      {Teamplace.Worker, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Teamplace.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp ensure_required_envs do
    case Application.get_env(:teamplace, :multi_user) do
      x when x in [nil, false] ->
        credentials = Application.get_env(:teamplace, :credentials)
        api_base = Application.get_env(:teamplace, :api_base)
        bcra_token = Application.get_env(:teamplace, :bcra_token)
        suggestion = ". Please set them on config.exs and try again"

        credentials[:client_id] ||
          raise "Missing :teamplace, credentials[:client_id] env" <> suggestion

        credentials[:client_secret] ||
          raise "Missing :teamplace, credentials[:client_secret] env" <> suggestion

        api_base || raise "Missing :teamplace, api_base env" <> suggestion

        bcra_token ||
          IO.warn(
            "Missing :teamplace, bsra_token env. They are needed for transactions operations"
          )

        true

      _ ->
        true
    end
  end
end
