defmodule Hangman.GameSupervisor do
  use Supervisor
  @me __MODULE__
  
  def start_link(initial_number \\ []) do
  	Supervisor.start_link(@me, [initial_number])
  end
  
  def init(_args) do
  	children = [worker(Hangman.GameServer, [], restart: :transient)]
  	supervise(children, strategy: :one_for_one)
  end
end