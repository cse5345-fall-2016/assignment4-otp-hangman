defmodule Hangman do
  use Application

  @moduledoc """

  The Game supervisor is a :one_for_one supervisor because if the Game dies,
  only it should be restarted. The Dictionary, on the other hand, should be
  :one_for_all because if the Dictionary exits, all children need to restart.
  Additionally, the Game restart option should be :transient because it should
  restart if the Game crashes. The Dictionary restart option should be
  :permanent because it needs to restart if it exits for any reason.

  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, [], id: :dictionary, restart: :permanent),
      supervisor(Hangman.GameSupervisor, [], id: :game_supervisor)
    ]

    opts = [strategy: :one_for_all, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
