defmodule Hangman.GameServer do
	use GenServer
	@name :hangman
	alias Hangman.Dictionary, as: Dict
	alias Hangman.Game, as: Game
  ###########################
  #   API Implementation    #
  ###########################
  def init(word) do
    {:ok, Game.new_game(word)}
  end

  def make_move(guess) do
  	GenServer.call(@name, {:move, guess})
  end

  def word_as_string(reveal \\ false) do
  	GenServer.call(@name, {:word_as_string, reveal})
  end

  def letters_used_so_far do
  	GenServer.call(@name, {:letters_used})
  end

  def turns_left do
  	GenServer.call(@name, {:turns})
  end
  def word_length do
    GenServer.call(@name, {:length})
  end
  ###########################
  # Server Implementation   #
  ###########################
  def start_link(word \\Dict.random_word) do
    GenServer.start_link(__MODULE__, word, name: @name)
  end

  def handle_call({:move, guess}, _from, state) do
  	{game, status, guess}=Game.make_move(state, guess)
  	{:reply, status,  game}
  end

  def handle_call({:word_as_string, reveal}, _from, state) do
  	{:reply, Game.word_as_string(state, reveal), state}
  end

  def handle_call({:length}, _from, state) do
  	{:reply, Game.word_length(state), state}
  end

  def handle_call({:letters_used}, _from, state) do
  	{:reply, Game.letters_used_so_far(state), state}
  end

  def handle_call({:turns}, _from, state) do
  	{:reply, Game.turns_left(state), state}
  end

end