defmodule Hangman.DictionarySupervisor do

  def start_link(_type) do

   import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.Dictionary, [])
     ]
    
    opts = [
        strategy: :rest_for_one, 
        name: Hangman.DictionarySupervisor
    ]
    
    Supervisor.start_link(children, opts)
  end
end