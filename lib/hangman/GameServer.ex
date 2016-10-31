defmodule Hangman.GameServer do
  use GenServer
  alias Hangman.Game

  #######
  # API #
  #######

  def start_link(word \\ Hangman.Dictionary.random_word) do
    GenServer.start_link(__MODULE__, word)
  end

  def make_move(pid, guess) do
    GenServer.call(pid, {:make_move, guess})
  end

  def word_length(pid) do
    GenServer.call(pid, :word_length)
  end

  def letters_used_so_far(pid) do
    GenServer.call(pid, :letters_used_so_far)
  end

  def turns_left(pid) do
    GenServer.call(pid, :turns_left)
  end

  def word_as_string(pid, reveal \\ false) do
    GenServer.call(pid, {:word_as_string, reveal})
  end

  def crash(pid, reason) do
    GenServer.cast(pid, {:crash, reason})
  end

  #######################
  # Server Implemention #
  #######################

  def init(word) do
    {:ok,  Game.new_game(word)}
  end

  def handle_call({:make_move, guess}, _from, state) do
    {state, status, guess} = Game.make_move(state, guess)
    {:reply, status, state}
  end

  def handle_call(:word_length, _from, state) do
    {:reply, Game.word_length(state), state}
  end

  def handle_call(:letters_used_so_far, _from, state) do
    {:reply, Game.letters_used_so_far(state), state}
  end

  def handle_call(:turns_left, _from, state) do
    {:reply, Game.turns_left(state), state}
  end

  def handle_call({:word_as_string, reveal}, _from, state) do
    {:reply, Game.word_as_string(state, reveal), state}
  end

  def handle_cast({:crash, reason}, state) do
    {:stop, reason, state}
  end

end
