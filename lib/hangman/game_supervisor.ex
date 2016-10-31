defmodule Hangman.GameSupervisor do
	use Supervisor

	def start_link() do
		Supervisor.start_link(__MODULE__, :ok, name: :game_supervisor)
	end

	def init(:ok) do
		children = [
			worker(Hangman.GameServer, [], restart: :transient)
		]
		opts = [strategy: :one_for_one, name: __MODULE__]
		supervise(children, opts)
	end
end
