defmodule Hangman do
  @moduledoc """

  The main supervisor named Hangman.Supervisor is used to monitor both the Game Supervisor named Hangman.GameSupervisor and the dictionary called Hangman.Dictionary.
  The supervisor strategy used is the 'one_for_all' strategy so that if the Dictionary exits for any reason, all the games supervised by GameSupervisor supervisor
  will be terminated. After which both the Dictionary and the GameSupervisor will be restarted.

  The Dictionary Server uses the :permanent restart strategy by default, because it needs to be restarted whenever it terminates.
  Futhermore, The GameSupervisor uses the one_for_one restart strategy because if one game dies, it alone should be restarted.
  Finally, The GameServer uses the :transient restart strategy, so the child process is restarted only if it terminates abnormally.

  """
  use Application
  @me Hangman.Supervisor

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, []),
      supervisor(Hangman.GameSupervisor, [[], [name: @me]])
    ]

    opts = [
      strategy: :one_for_all,
      name: Hangman.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
