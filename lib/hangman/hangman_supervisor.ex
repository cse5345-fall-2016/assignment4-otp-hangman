defmodule Hangman.HangmanSupervisor do
  use Supervisor
  @me __MODULE__

  def start_link do
    Supervisor.start_link(@me, :ok, name: @me)
  end

  # needs an init defined for the start_link() above^
  def init(_default \\ []) do
    # Define workers and child supervisors to be supervised
    children = [
      # restart GameServer on error only, hence :transient (let it terminate if
      # the game has finished)
      worker(Hangman.GameServer, [], restart: :transient  )
    ]
    # HangmanSupervisor only has one child, the GameServer, hence :one_for_one
    opts = [strategy: :one_for_one]
    supervise(children, opts)
  end
end
