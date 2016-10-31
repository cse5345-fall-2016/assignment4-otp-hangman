defmodule Hangman.GameSupervisor do

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], :good)
  end

  def init([]) do
    children = [
                worker(Hangman.GameServer, [], restart: :transient)
              ]
    supervise(children, strategy: :one_for_one)
  end
end
