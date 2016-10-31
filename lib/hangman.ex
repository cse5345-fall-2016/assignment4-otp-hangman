defmodule Hangman do
  use Application

  @moduledoc """

  I am creating a main parent supervisor and two seperate supervisors for dictionary and game. I chose this pattern to be able to specify different 
  shutdown options and supervisor strategies for both dictionary and game.

  The parents supervisor starts both the dictionary and game supervisors and those supervisors in turn start the dictionary module and the game module.

  Dictionary is :one_for_rest strategy because I want all other processes to terminate if dictionary terminates. Game is one for one becaue I only want the 
  specific game to crash and restart if there's a problem. But if the main parent supervisor fails for some reason all the others will be restarted as well
  because the main supervisor is one_for_all. I made it work like that because there's no reason for the child supervisors to run or maintain state if the parent
  fails.

  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false
    
    children = [
      supervisor(Hangman.DictionarySupervisor, [[name: Hangman.DictionarySupervisor]]), 
      supervisor(Hangman.GameSupervisor, [[name: Hangman.GameSupervisor]])
     ]
    
    opts = [strategy: :one_for_all, name: Hangman.Supervisor]
    
    Supervisor.start_link(children, opts)
  end
end

