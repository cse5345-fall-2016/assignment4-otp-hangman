defmodule Hangman do
  use Application

  @moduledoc """
  
  The top level supervisor will start 2 children: a worker process to start the dictionary 
  and a subsupervisor to monitor the game process. 
 
  We use a :permanent restart option for the dictionary so that it will restart upon on any exits.
  We use a :rest_for_one strategy to restart both the dictionary and game processes when the dictionary
  crashes, but only restart the game when the game crashes. 

  The sub-supervisor is used to apply different strategies on the game process. We want to restart the game only on 
  crashes, so we use the :transient option. Since we only want to only restart that one crashed game process, 
  we use a :one_for_one strategy. 

  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.Dictionary, [], restart: :permanent), 
      supervisor(Hangman.SubSupervisor, [], restart: :transient)
    ]
    
    opts = [
      strategy: :rest_for_one, 
      name: __MODULE__
    ]

    Supervisor.start_link(children, opts)
  end
end

