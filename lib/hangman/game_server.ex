defmodule Hangman.GameServer do	
	use GenServer 
	@me :game_server
	######################
	# API implementation #
	######################
	def start_link do
		GenServer.start_link(__MODULE__, GenServer.call(:dictionary, :random_word), name: @me)
	end 
	def start_link(word) do
		GenServer.start_link(__MODULE__, word, name: @me)
	end
	
	#Initialize game state#
	def init(word) do
		{:ok, Hangman.Game.new_game(word)}
	end

	def make_move(guess) do
		GenServer.call @me, {:make_move, guess}
	end

	def word_as_string(reveal \\ false) do
		GenServer.call @me, {:word_as_string, reveal}
	end

	def word_length do 
		GenServer.call @me, {:word_length}
	end

	def turns_left() do
		GenServer.call @me, {:turns_left}
	end

	def letters_used_so_far do
		GenServer.call @me, {:letters_used_so_far}
	end

	def crash(cause) do
		GenServer.stop(@me, cause)
	end

	############################
	# GenServer implementation #
	############################

	def handle_call({ :make_move, guess}, _from, state) do
		{new_state, status, _}=Hangman.Game.make_move(state, guess)
		{:reply, status, new_state}
	end

	def handle_call({ :word_as_string, reveal}, _from, state) do
		{:reply, Hangman.Game.word_as_string(state, reveal), state}
	end

	def handle_call({ :word_length}, _from, state) do
		{:reply, Hangman.Game.word_length(state), state}
	end

	def handle_call({ :turns_left}, _from, state) do
		{:reply, Hangman.Game.turns_left(state), state}
	end

	def handle_call({ :letters_used_so_far}, _from, state) do
		{:reply, Hangman.Game.letters_used_so_far(state), state}
	end

	def handle_call({ :crash, cause}, state) do
		{:stop, cause, state}
	end

end


