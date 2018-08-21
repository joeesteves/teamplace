defmodule Teamplace.Worker do
  @moduledoc false

  use Agent

  def start_link(_args) do
    Agent.start_link(fn -> %{} end, name: :teamplace)
  end
end
