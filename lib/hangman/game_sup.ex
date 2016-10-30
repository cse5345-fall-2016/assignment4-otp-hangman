defmodule Hangman.GameServerSup do
  use Supervisor

  #http://elixir-lang.org/getting-started/mix-otp/supervisor-and-application.html#our-first-supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Hangman.GameServer, [], id: :game, restart: :transient) #easy to scale
    ]

    supervise(children, strategy: :one_for_one)
  end
end
