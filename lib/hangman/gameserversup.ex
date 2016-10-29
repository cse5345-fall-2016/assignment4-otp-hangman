defmodule GameSup do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...

  """
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
     
    children = [
        worker(Hangman.GameServer, [])
    ]
    
    opts = [strategy: :one_for_one, name: GameSup.Supervisor]
    
	Supervisor.start_link(children, opts)
  end
end

defmodule GameSup.SubSupervisor do
    use Supervisor
    def start_link() do
        {:ok, _pid} = Supervisor.start_link(__MODULE__)
    end
    
    def init(_args) do
        child_processes = [ worker(Hangman.GameServer, []) ]
        supervise child_processes, strategy: :one_for_one
    end
end

