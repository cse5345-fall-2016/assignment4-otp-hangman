defmodule Hangman.GameServer do
	use GenServer
	alias Hangman.Game, as: API

	@me :game_server
	
	def start_link(default \\ []) do
    	GenServer.start_link(__MODULE__, default, name: @me)
  	end

  	def make_move(guess) do
  		Genserver.call(@me, {:move, guess})
  	end

  	def word_length do
  		Genserver.call(@me, {:length})
  	end

  	def letters_used_so_far do
  	  	Genserver.call(@me, {:letters})
  	end

  	def turns_left do
  		Genserver.call(@me, {:turns})
  	end

  	def word_as_string(state, reveal \\ false) do
  		Genserver.call(@me, {:string, reveal})
  	end

	#########################
	# Server Implementation #
	#########################

	def init(args) do
		{:ok, Enum.into(args, %{})}
	end

	def handle_call({:move, guess}, _from, state) do
		{:reply, API.make_move(state, guess), state}
	end

	def handle_call({:length}, _from, state) do
		{:reply, API.word_length(state), state}
	end

	def handle_call({:letters}, _from, state) do
		{:reply, API.letters_used_so_far(state), state}
	end

	def handle_call({:turns}, _from, state) do
		{:reply, API.turns_left(state), state}
	end

	def handle_call({:string, reveal}, _from, state) do
		{:reply, API.word_as_string(state, reveal), state}
	end

end
