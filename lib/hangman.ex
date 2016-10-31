defmodule Hangman do
  use Application

  @moduledoc """

  In our architecture the game depends on the dictionary but the
  dictionary is indpendent of the game. We use the rest_for_one strategy
  at the top level because we want all games to restart if the dictionary
  stops running for any reason. The dictionary should restart every time
  it goes down whether it was on purpose or not, so it is permanent.

  The game supervisor is then responsible for managing the individual
  games. The game supervisor uses a one_for_one strategy, restarting
  games individually. This strategy makes sense because games are
  independent, i.e. if one goes down, it doesn't affect any of the other
  games. Games should only restart if it crashes, so the restart is
  transient.

  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.Dictionary, [], id: :dictionary, restart: :permanent),
      supervisor(Hangman.GameSupervisor, []),
    ]
    
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

