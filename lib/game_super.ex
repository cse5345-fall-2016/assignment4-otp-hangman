defmodule Hangman.Game_Super do
    use Supervisor

    @ai __MODULE__

    def start_link do
 		Supervisor.start_link(@ai, [])
 	end

	def init(args) do
		children = [
            worker(Hangman.GameServer, args, restart: :transient)
        ]

		supervise(children, [strategy: :one_for_one, name: @ai])
    end
end
