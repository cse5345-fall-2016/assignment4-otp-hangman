defmodule Hangman do
  use Application,Supervisor

  @moduledoc """

  @Strategies - Hangman supervisor defines "one_for_one"" strategies to manage child processes.
    Hence Hangman.Dictionary is needed to retrive random word so on child processors crash the supervisor will restart
   "Hangman.Dictionary and Hangman.GameSupervisor".

  @Restart Values - restart: :transient i.e , Child proces is restarted only if it terminates abnormally

  """

  def start(_type, _args) do

     import Supervisor.Spec, warn: false

     children = [
        worker(Hangman.Dictionary,["shashi"]),
        supervisor(Hangman.GameSupervisor, [])
     ]
     opts = [strategy: :one_for_one, name: Hangman.Supervisor, restart: :transient]
     Supervisor.start_link(children, opts)
  end
end

