defmodule GameServerSupervisor do
  use Supervisor

  def start_link(arg \\ []) do
    Supervisor.start_link(__MODULE__, arg)
  end

  def init(_arg) do
    children = [
      worker(Hangman.GameServer, [], restart: :transient)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
