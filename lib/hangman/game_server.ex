defmodule Hangman.GameServer do
	use GenServer
	alias Hangman.Game, as: API

	@me :game_server
	
	#######
	# API #
	#######

	def start_link(arg) do
    	GenServer.start_link(__MODULE__, API.new_game(arg), name: @me)
  	end

  	def start_link do
  		GenServer.start_link(__MODULE__, API.new_game, name: @me)
  	end

  	def make_move(guess) do
  		GenServer.call(@me, {:move, guess})
  	end

  	def word_length do
  		GenServer.call(@me, {:length})
  	end

  	def letters_used_so_far do
  	  	GenServer.call(@me, {:letters})
  	end

  	def turns_left do
  		GenServer.call(@me, {:turns})
  	end

  	def word_as_string(reveal \\ false) do
  		GenServer.call(@me, {:string, reveal})
  	end

  	def crash(error) do
  		GenServer.cast(@me, {:crash, error})
  	end

	#########################
	# Server Implementation #
	#########################

	def init(args) do
		{:ok, Enum.into(args, %{})}
	end

	def handle_call({:move, guess}, _from, state) do
		{game, status, _} = state |> API.make_move(guess)
		{:reply, status, game}
	end

	def handle_call({:length}, _from, state) do
		{:reply, state |> API.word_length, state}
	end

	def handle_call({:letters}, _from, state) do
		{:reply, state |> API.letters_used_so_far, state}
	end

	def handle_call({:turns}, _from, state) do
		{:reply, state |> API.turns_left, state}
	end

	def handle_call({:string, reveal}, _from, state) do
		{:reply, state |> API.word_as_string(reveal), state}
	end

	def handle_cast({:crash, error}, _from, state) do
		{:stop, error, state}
	end

end
