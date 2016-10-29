defmodule Hangman.GameServer do

  use GenServer
  alias Hangman.Game, as: Gm 

  def start_link(word) do
    GenServer.start_link(__MODULE__, word, name: :game)
  end

  def start_link() do
    GenServer.start_link(__MODULE__, GenServer.call(:dictionary, :random_word), name: :game)
  end

  def make_move(guess) do
    GenServer.call :game, {:make_move, guess}
  end

  def letters_used_so_far() do
    GenServer.call :game, :letters_used_so_far
  end

  def turns_left() do
    GenServer.call :game, :turns_left
  end

  def word_as_string() do
    GenServer.call :game, :word_as_string
  end

  def word_length() do
    GenServer.call :game, :word_length
  end
  
  def word_as_string(reverse) do
    GenServer.call :game, {:word_as_string, reverse}
  end

  def crash(:normal) do
    GenServer.stop(:game, :normal)
  end
  
  #________________________________

  def init(word) do
    {:ok, Gm.new_game(word)}    
  end

  def handle_call({:make_move, guess},  _from, state) do
    {new_state, res, _} = Gm.make_move(state, guess)
    { :reply, res, new_state}
  end

  def handle_call(:letters_used_so_far,  _from, state) do
    { :reply, Gm.letters_used_so_far(state), state}
  end
  
  def handle_call(:turns_left,  _from, state) do
    { :reply, Gm.turns_left(state), state}
  end

  def handle_call(:word_as_string,  _from, state) do
    { :reply, Gm.word_as_string(state), state}
  end

  def handle_call(:word_length,  _from, state) do
    { :reply, Gm.word_length(state), state}
  end

  def handle_call({:word_as_string, reverse},  _from, state) do
    { :reply, Gm.word_as_string(state, reverse), state}
  end


end
