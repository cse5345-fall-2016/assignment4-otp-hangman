defmodule Hangman.GameServer_SubSupervisor do
  use Supervisor

  @strategy :one_for_one

  @restart :transient

  def start_link(initial_word) do
    Supervisor.start_link(__MODULE__, initial_word)
  end

  def init(initial_word) do
    child_processes = [ worker(Sequence.Server, [initial_word], restart: @restart) ]
    supervise child_processes, strategy:   @strategy
  end

end
