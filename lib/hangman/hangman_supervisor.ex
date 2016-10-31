defmodule Hangman.HangmanSupervisor do
  use Supervisor
  @me __MODULE__

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications

  def start_link do
    Supervisor.start_link(@me, :ok, name: @me)
  end

  # needs an init defined for the start_link() above^
  def init(default \\ []) do
    # Define workers and child supervisors to be supervised
    children = [
      # restart GameServer on error only
      worker(Hangman.GameServer, [], restart: :transient  )
    ]
    # HangmanSupervisor only has one child, the GameServer
    # opts = [strategy: :one_for_one]
    supervise(children, strategy: :one_for_one)
  end
end
