defmodule Hangman do
  use Application

  @strategy :one_for_all

  @restart :permanent


  @moduledoc """

  Write your description of your supervision scheme here...

  """

  def start(_type, args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, [], id: :dictionary, restart: @restart),
      worker(Hangman.GameServer, [], id: :game, restart: @restart)
    ]

    opts = [strategy: @strategy, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
