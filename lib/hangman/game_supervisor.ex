defmodule Hangman.GameSupervisor do
  use Supervisor

  def start_link(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, []),
      worker(Hangman.GameServer, [], restart: :transient)
    ]

    opts = [
      strategy: :rest_for_one,
      name: Hangman.GameSupervisor
    ]

    Supervisor.start_link(children, opts)
  end

  def init(_args), do: {:ok, :ignore}

end
