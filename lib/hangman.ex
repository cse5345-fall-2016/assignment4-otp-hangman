defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
     
    children = [
        worker(Hangman.Dictionary.Server, []),
        #worker(Hangman.GameServer, [])
        #supervisor(GameSup.Supervisor, [])
    ]
    
    opts = [strategy: :one_for_all, name: Hangman.Supervisor]
    
	Supervisor.start_link(children, opts)
  end
end

