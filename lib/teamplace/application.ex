defmodule Teamplace.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    ensure_required_envs() && IO.puts "Teamplace - All envs are correctly setted ✔"

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
    credentials = Application.get_env(:teamplace, :credentials)
    api_base = Application.get_env(:teamplace, :api_base)
    credentials[:client_id] || raise "Missing TEAMPLACE_CLIENT_ID System Variable"
    credentials[:client_secret] || raise "Missing TEAMPLACE_CLIENT_SECRET System Variable"
    api_base || raise "Missing TEAMPLACE_API_BASE System Variable"
    true
  end
end
