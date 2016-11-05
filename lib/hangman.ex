defmodule Hangman do
  use Application

  @moduledoc """

  Supervision Strategy - rest_for_one
    Choosing this strategy because if the Dictionary crashes, we want
    everything after that to be restarted.
    Currently Dictionary starts first, followed by GameServer.
    This way if Dictionary crashes, GameServer restarts and if GameServer
    crashes, only that restarts.

  Restart Value - transient
    Chosen because we want to re-run the modules only if they are
    terminated abnormally.
  """

  def start(_type, _args) do
    # Uncomment and complete this:
     import Supervisor.Spec, warn: false

     children = [
       worker(Hangman.Dictionary, [], restart: :transient),
       supervisor(Hangman.GameSupervisor, [])
     ]

     opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
     Supervisor.start_link(children, opts)
  end
end
