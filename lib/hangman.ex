defmodule Hangman do
  use Application

  @moduledoc """

  The supervision scheme I decided to implement consists of two supervisors: the
  base Hangman supervisor and a GameSupervisor. The base supervisor has two
  children: a Dictionary GenServer and the GameSupervisor. The strategy for the
  base supervisor is 'rest_for_one', meaning the children after the crashed
  process will be restarted. In this case, The dictionary server is started first
  and the game supervisor second. If the Dictionary crashes, then the game
  supervisor will be restarted. The dictionary will always be restarted, given
  its 'permanent' restart option. The GameServerSupervisor has one child process:
  the GameServer. It implements a 'one_for_one' supervision strategy, meaning if
  the process dies, restart it and only it. The GameServer child process will
  always be restarted if it crashes, due to its 'permanent' restart option.

  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, [], restart: :permanent),
      supervisor(Hangman.GameServerSupervisor, [])
    ]

    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

