defmodule Hangman do
  use Application

  @moduledoc """

  Because the GameServer worker depends on the dictionary
  worker, we will use the :one_for_all strategy. That way,
  if the dictionary worker goes down, the gameserver worker
  will be restarted also.

  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, []),
      worker(Hangman.GameServer, [])
    ]

    opts = [strategy: :one_for_all , name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

