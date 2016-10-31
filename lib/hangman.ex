defmodule Hangman do
  use Application

  @moduledoc """
  The supervisor strategy is to restart workers using the :rest_for_one
  strategy.  GameServer should restart by itself if it crashes, but if
  Dictionary crashes, both Dictionary and GameServer should restart.
  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, []),
      worker(Hangman.GameServer, [])
    ]

    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)

  end

end
