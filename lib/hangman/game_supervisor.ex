defmodule Hangman.GameSupervisor do
  use Supervisor

  @moduledoc """

  The Game supervisor is a :one_for_one supervisor because if the Game dies,
  only it should be restarted. Additionally, the Game restart option should
  be :transient because it should restart if the Game crashes.

  """

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, name: :game_supervisor)
  end

  def init(:ok) do
    children = [
      worker(Hangman.GameServer, [], restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: GameSupervisor.Supervisor]
    supervise(children, opts)
  end
end
