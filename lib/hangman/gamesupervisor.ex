defmodule GameSupervisor do
  use Application

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false

    children = [
        worker(Hangman.GameServer, []),
    ]

    opts = [strategy: :one_for_one, name: Hangman.GameSupervisor]
    Supervisor.start_link(children, opts)
  end
end
