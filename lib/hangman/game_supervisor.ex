defmodule Hangman.GameSupervisor do 

  use Supervisor
 
  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    child = [worker(Hangman.GameServer, [])]
    opts = [strategy: :one_for_one, name: __MODULE__]
    supervise(child, opts) 
  end
end