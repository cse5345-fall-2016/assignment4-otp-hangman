defmodule Hangman.GameSupervisor do

   @moduledoc """

   @Strategies - :one_for_one
   @Restart Values - :transient
        Hangman.GameServer Child proces is restarted only if it terminates abnormally and populted with random dictionary word
   """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
       worker(Hangman.GameServer, [Hangman.Dictionary.random_word], restart: :transient)
    ]

    supervise(children, strategy: :one_for_one)
  end

end