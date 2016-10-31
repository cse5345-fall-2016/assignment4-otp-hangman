defmodule Hangman.GameSupervisor do
	use Supervisor
	# Game Supervisor is responsible for supervising Game Server.
	
	def start_link do
		Supervisor.start_link(__MODULE__, [])
	end

	def init(args) do
		child_processes = [worker(Hangman.GameServer, args, restart: :transient)]
		supervise child_processes, strategy: :one_for_one 
	end

end