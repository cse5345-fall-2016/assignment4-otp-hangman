defmodule Hangman.GameSupervisor do
  use Application

  def start(_type, _args) do
    call_supervisor()
  end

  def start_link(_type, _args) do
    call_supervisor()
  end

  def call_supervisor() do
    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, []),
      worker(Hangman.GameServer, [], restart: :transient)
    ]

    opts = [
      strategy: :one_for_all,
      name: Hangman.GameSupervisor
    ]

    Supervisor.start_link(children, opts)
  end

end
