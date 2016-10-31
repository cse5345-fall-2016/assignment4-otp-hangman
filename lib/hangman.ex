defmodule Hangman do
  use Application

  @moduledoc """

  In our architecture the game depends on the dictionary but the
  dictionary is indpendent of the game. We use the rest_for_one strategy
  at the top level because we want all games to restart if there's a
  problem with the dictionary. We have the game supervisor is then
  responsible for managing the individual games.

  The game supervisor uses a one_for_one strategy, restarting games
  individually. I went with this strategy at the game level because
  games are independent. A breakage in one does not change anything
  in the other game processes.

  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.Dictionary, [], id: :dictionary, restart: :transient),
      supervisor(Hangman.GameSupervisor, []),
    ]
    
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

