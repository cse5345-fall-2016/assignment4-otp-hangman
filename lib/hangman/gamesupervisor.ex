defmodule Hangman.GameSupervisor do
  use Supervisor

  def start_link(pid) do
    Supervisor.start_link(__MODULE__, pid, name: :gamesupervisor)
  end

  def init(_pid) do

        children = [
            worker(Hangman.GameServer, [], restart: :transient)
        ]

        supervise children, strategy: :one_for_one
  end
end
