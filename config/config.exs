# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :teamplace,
  credentials: %{
    client_id: System.get_env("TEAMPLACE_CLIENT_ID"),
    client_secret: System.get_env("TEAMPLACE_CLIENT_SECRET")
  }

config :teamplace,
  api_base: System.get_env("TEAMPLACE_API_BASE")

config :teamplace,
  bcra_token: System.get_env("TEAMPLACE_BCRA_TOKEN")

#     import_config "#{Mix.env}.exs"
