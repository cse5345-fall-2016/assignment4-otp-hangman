defmodule Hangman.GameSupervisor do
  use Supervisor
  #@name Hangman.GameSupervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def new_game do
    Supervisor.start_child(Hangman.GameSupervisor, [])
  end

  def init(:ok) do
    # pool_options = [
    #   name: {:local, :hangman_pool},
    #   worker_module: Hangman.GameServer,
    #   size: 2,
    #   max_overflow: 4
    # ]
    children = [
      #:poolboy.child_spec(:hangman_pool, pool_options, [])
      worker(Hangman.GameServer, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
