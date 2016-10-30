defmodule GameSup.SubSupervisor do
    use Supervisor
    
    @moduledoc """

  This supervisor has only one worker and since no other worker 
  depends on this worker, if this worker fails, we would want only it to restart.
  :one_for_one-> If this worker fails, only restart itself.

  """
  
    def start_link() do
        Supervisor.start_link(__MODULE__, :ok)
    end
    
    def init(:ok) do
        children = [ worker(Hangman.GameServer, []) ]
        supervise(children, strategy: :one_for_one)
        
    end
end

