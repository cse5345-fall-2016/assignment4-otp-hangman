defmodule Hangman.GameServerSupervisor do
  use Supervisor

  @me __MODULE__

  def start_link(default \\ []) do
    Supervisor.start_link(@me, default)
  end

  def init(_args) do
    children = [
      worker(Hangman.GameServer, [], restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: @me]
    supervise(children, opts)
  end
end
