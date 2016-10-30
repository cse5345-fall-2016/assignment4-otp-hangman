defmodule GameSup.SubSupervisor do
    use Supervisor
    
    @moduledoc """

  Write your description of your supervision scheme here...

  """
  
    def start_link() do
        Supervisor.start_link()
    end
    
    def init(_args) do
        child_processes = [ worker(Hangman.GameServer, []) ]
        supervise child_processes, strategy: :one_for_one
    end
end

