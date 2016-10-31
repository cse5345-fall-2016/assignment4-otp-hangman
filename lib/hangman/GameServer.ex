defmodule Hangman.GameServer do

  use GenServer
  @game :GameServer
  alias Hangman.Game, as: HG
  alias Hangman.Dictionary, as: HD

  #API

  def start_link(word \\ HD.random_word) do
    GenServer.start_link(__MODULE__, word, name: :game)
  end

  def make_move(guess) do
    GenServer.call :game, {:make_move, guess}
  end

  def letters_used_so_far() do
    GenServer.call :game, :letters_used_so_far
  end

  def word_length() do
    GenServer.call :game, :word_length
  end

  def word_as_string(revert \\ false) do
    GenServer.call :game, {:word_as_string, revert}
  end

  def turns_left() do
    GenServer.call :game, :turns_left
  end

  def crash(issue \\ :normal) do
    GenServer.cast(@game, { :crash, issue })
  end
  #GenServer Handle Call and Init

  def init(word) do
    {:ok, HG.new_game(word)}
  end

  def handle_call({:make_move, guess},  _from, state) do
    {new_state, res, _guess} = HG.make_move(state, guess)
    { :reply, res, new_state}
  end

  def handle_call(:letters_used_so_far,  _from, state) do
    { :reply, HG.letters_used_so_far(state), state}
  end

  def handle_call(:word_as_string,  _from, state) do
    { :reply, HG.word_as_string(state), state}
  end

  def handle_call(:turns_left,  _from, state) do
    { :reply, HG.turns_left(state), state}
  end

  def handle_call(:word_length,  _from, state) do
    { :reply, HG.word_length(state), state}
  end

  def handle_call({:word_as_string, revert},  _from, state) do
    { :reply, HG.word_as_string(state, revert), state}
  end


end
