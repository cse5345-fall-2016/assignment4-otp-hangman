defmodule Hangman do
  use Application

  @moduledoc """

  Here, we want that if either of the worker or supervisor fails, we restart both.
  Suppose that there are multiple workers under the SubSupervisor and all depend on the worker Dictionary to provide them with a random word.
  Now, if worker Dictionary fails, we will need to restart SubSupervisor too.
  But, nothing is dependent on the SubSupervisor. If it crashes, we can only restart it and nothing else.
  In short: child1 crashes, restart all. child2 crashes, restart itself.
  :rest_for_one-> This is the strategy to use when processes have one way dependencies.
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
     
    children = [
        worker(Hangman.Dictionary.Server, []),
        supervisor(GameSup.SubSupervisor, [])
    ]
    
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    
	Supervisor.start_link(children, opts)
  end
end

