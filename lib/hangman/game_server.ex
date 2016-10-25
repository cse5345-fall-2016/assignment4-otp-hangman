defmodule Hangman.GameServer do

	use GenServer

	@me :game_server

	def start_link do
		GenServer.start_link(__MODULE__, Hangman.Game.new_game, name: @me)
	end

	def start_link(word) do
		GenServer.start_link(__MODULE__, Hangman.Game.new_game(word), name: @me)
	end


	# Game Server API Implementation (as defined in Game.ex)

	def make_move(guess) do
		GenServer.call(@me, { :make_move, guess })
	end

	def word_length do
		GenServer.call(@me, { :word_length })
	end

	def letters_used_so_far do
		GenServer.call(@me, { :letters_used })
	end

	def turns_left do
		GenServer.call(@me, { :turns_left })
	end

	def word_as_string(reveal \\ false) do
		GenServer.call(@me, { :word, reveal })
	end

	# Didn't think I needed to redefine this as part of the server, however I get errors if it isnt defined
	def new_game(word \\ Hangman.Dictionary.random_word) do
		GenServer.cast @me, { :newGame, word }
	end

	def crash(exit_code) do
		GenServer.cast(@me, { :crash, exit_code })
	end


	# Server Implementation

	def init(word) do
		{:ok, word}
	end

	def handle_call({ :make_move, guess }, _from, state) do
		{ updated_state, status, _guess } = Hangman.Game.make_move(state, guess)
		{:reply, status, updated_state}
	end

	def handle_call({ :word_length }, _from, state) do
		{:reply, Hangman.Game.word_length(state), state}
	end

	def handle_call({ :letters_used }, _from, state) do
		{:reply, Hangman.Game.letters_used_so_far(state), state}
	end

	def handle_call({ :turns_left }, _from, state) do
		{:reply, Hangman.Game.turns_left(state), state}
	end

	def handle_call({ :word, reveal }, _from, state) do
		{:reply, Hangman.Game.word_as_string(state, reveal), state}
	end

	# Do not need state, so use _state instead
	def handle_cast({ :new_game, word }, _from, _state) do
		{:no_reply, Hangman.Game.new_game(word)}
	end

	def handle_cast({ :crash, exit_code }, _from, state) do
		{:stop, exit_code, state}
	end

end