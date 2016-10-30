defmodule GameServer_SubSupervisor do
  use Application

  @strategy :one_for_one

  @restart :transient

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.GameServer, [], restart: @restart)
    ]

    opts = [strategy: @strategy, name: Hangman.GameServer_SubSupervisor]
    Supervisor.start_link(children, opts)
  end

end
