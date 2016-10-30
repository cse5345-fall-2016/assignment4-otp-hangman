defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...

  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.Dictionary, [], restart: :permanent),
      supervisor(Hangman.GameServer, [], restart: :transient)
    ]

    # Game is transient and should be handled one for one.
    # Dictionary is permanent and should be handled rest for one because one for all will kill ALL parts of the tree.
    # Rest for one kills the problem child and subsequent children.

    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    {:ok, _pid} = Supervisor.start_link(children, opts)
  end
end

