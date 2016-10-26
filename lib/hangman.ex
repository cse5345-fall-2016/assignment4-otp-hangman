defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...

  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false
    
    # COME BACK TO THIS
    children = [
      worker(Hangman.Dictionary, [], restart: :permanent),
      supervisor(Hangman.SubSupervisor, [], restart: :transient)
    ]

    # Game is transient and should be handled one for one.
    # Dictionary is permanent and should be handled one for all.

    opts = [strategy: :one_for_all, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

