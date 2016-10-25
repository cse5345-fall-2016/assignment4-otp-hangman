defmodule Hangman.GameSupervisor do
	use Supervisor

	@moduledoc """
		This supervisor is responsible for starting and supervising the child Game Server.
	"""

	def start_link do
		Supervisor.start_link(__MODULE__, [])
	end

	def init(args) do
		children = [ worker( Hangman.GameServer, args, restart: :transient ) ]
		supervise(children, [strategy: :one_for_one, name: __MODULE__])
	end

	@doc """
		server documentation http://elixir-lang.org/docs/stable/elixir/GenServer.html
	"""

end