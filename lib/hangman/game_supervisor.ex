defmodule Hangman.GameSupervisor do
  
  def start_link(_type) do

   import Supervisor.Spec, warn: false
    
    children = [
       worker(Hangman.GameServer, [Hangman.GameServer])
     ]
    
    opts = [
        strategy: :one_for_one, 
        name: Hangman.GameSupervisor]
    
    Supervisor.start_link(children, opts)
  end
end