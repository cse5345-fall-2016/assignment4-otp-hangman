defmodule Hangman do
  use Application

  @moduledoc """

  Description of Supervision Strategy:

  The main supervisor (this module) monitors both the Game Supervisor and the dictionary.
  This supervisor is at the root of the supervisor tree.
  The Game Supervisor is the parent to the Game Server.

  The main supervisor uses the one_for_all restart strategy.
  This way if the dictionary crashes all the games will be stopped (needed because the games are dependent on the Dictionary being up and running).
  The Dictionary Server uses the :permanent restart strategy, because (being a dependency) it always needs to be running for the Game Server to work.
  The Game Supervisor uses the one_for_one restart strategy. If a game crashes, only that individual game will be restarted.
  We currently are only running one child off of the Game Supervisor, but this would be helpful in the case that there is more than one child server.
  The Game Server/Supervisor uses the :transient restart strategy, because we only want this child process to restart if it terminates abnormally, with an exit reason other than :normal or :shutdown.
  If the game ends normally, it should not restart.


  I had lots of issues getting this module to launch the Game Supervisor and Game Server.
  The stack trace/errors that that "mix test" gives you when the error involves supervisor parts of the application can be diffucult to decipher.

  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, [], restart: :permanent),
      supervisor(Hangman.GameSupervisor, [])
    ]

    opts = [strategy: :one_for_all, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

