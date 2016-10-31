defmodule Hangman do
  use Application

  @name :"Hangman.Supervisor"

  @moduledoc """

  My structure is similar to the structure found in "Programming Elixir" page 235.
  The main supervisor has two children: the Dictionary server and API, and the Game Supervisor. 
  The Game Supervisor is transient and has one child: the Game Server.  
  If the game crashes, only the Game Server that controls it is restarted using one-for-one strategy. Since it is transient, the game does not restart if it exits normally.
  The Dictionary is permanent because it must always restart if it exits.  
  If it exits for any reason, the Dictionary and all subsequent children including the Game Supervisor and Server are restarted using the rest-for-one strategy.

  """

  def start(_type, args) do

    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.Dictionary, args, restart: :permanent),
      supervisor(Hangman.GameSupervisor, args, restart: :transient)
    ]

    opts = [strategy: :rest_for_one, name: @name]
    Supervisor.start_link(children, opts)
  end
end

