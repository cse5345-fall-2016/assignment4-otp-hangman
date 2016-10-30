defmodule Hangman.GameSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(arg) do

    children = [
      worker(Hangman.GameServer, arg, restart: :transient)
    ]
    opts = [strategy: :one_for_one, name: __MODULE__]
    supervise(children, opts)
  end
end
