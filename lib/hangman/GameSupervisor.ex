defmodule Hangman.GameSupervisor do
  use Supervisor

  def start_link do
   Supervisor.start_link(__MODULE__, :ok, name: Hangman.GameSupervisor)
  end

  def new_game do
   {:ok, pid} = Supervisor.start_child(Hangman.GameSupervisor, [])
   pid
  end

  import Supervisor.Spec, warn: false
  def init(:ok) do
   children = [
   worker(Hangman.GameServer, [], restart: :transient)
   ]
   
   supervise(children, strategy: :simple_one_for_one)
  end
end
