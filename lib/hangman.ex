defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...

  """

  def start(_type, _args) do

    # Uncomment and complete this:

     import Supervisor.Spec, warn: false

     children = [
       worker(Hangman.GameServer, [])
     ]

     opts = [strategy: :one_for_one, name: Hangman.Supervisor]
     {:ok, _pid} = Supervisor.start_link(children, opts)
  end
end
