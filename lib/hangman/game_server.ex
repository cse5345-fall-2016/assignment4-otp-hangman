defmodule GameServer do
	use GenServer
	@name :hangman
	alias Hangman.Dictionary as Dict
	alias Hangman.Game as Game
  ###########################
  #   API Implementation    #
  ###########################
  def init(word) do
    Game.new_game(word)
  end

  def make_move(guess) do
  	GenServer.call(@me, {:move, guess})
  end
  ###########################
  # Server Implementation   #
  ###########################
  def start_link(word \\Dictionary.random_word) do
    GenServer.start_link(__MODULE__, word, name: @name)
  end

  def handle_call({:move, guess}, _from, state) do
  	{game, status, guess}=Game.make_move(state, guess)
  	{:reply, status,  game}
  end
end