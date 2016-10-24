defmodule Hangman.GameSupervisor do
  use Application

  def start_link(_type, args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, args),
      worker(Hangman.GameServer, args, restart: :transient)
    ]

    opts = [
      strategy: :one_for_all,
      name: Hangman.GameSupervisor
    ]

    Supervisor.start_link(children, opts)
  end

end
