defmodule Hangman.Supervisor do
  use Supervisor

  @strategy :one_for_all

  @restart :transient

  def start_link(initial_word) do
    result = {:ok, sup } = Supervisor.start_link(__MODULE__, [initial_word])
    start_workers(sup, initial_word)
    result
  end

  def start_workers(sup, initial_word) do
    # Start the Dictionary
    Supervisor.start_child(sup, worker(Hangman.Dictionary, [], restart: @restart))
    # Start subsupervisor GameServer_SubSupervisor
    Supervisor.start_child(sup, supervisor(Hangman.GameServer_SubSupervisor, [initial_word], restart: @restart))
  end

  def init(_) do
    supervise [], strategy: @strategy
  end

end
