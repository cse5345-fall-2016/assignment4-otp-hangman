defmodule Hangman.GameServer do
  use GenServer
  alias Hangman.Game, as: Game
  @me :gameserver

  #######
  # API #
  #######

  def start_link do
    GenServer.start_link(__MODULE__, Game.new_game, name: @me)
  end

  def start_link(word) do
    GenServer.start_link(__MODULE__, Game.new_game(word), name: @me)
  end

  def make_move(guess) do
    GenServer.call(@me, {:make_move, guess})
  end

  def word_length do
    GenServer.call(@me, :length)
  end

  def letters_used_so_far do
    GenServer.call(@me, :letters_used)
  end

  def turns_left do
    GenServer.call(@me, :turns_left)
  end

  def word_as_string(reveal \\ false) do
    GenServer.call(@me, {:word, reveal})
  end

  def crash(reason) do
    GenServer.cast(@me, {:crash, reason})
  end

  ##################
  # IMPLEMENTATION #
  ##################

  def handle_call({:make_move, guess}, _from, state) do
    {new_state, status, _} = Game.make_move(state, guess)
    {:reply, status, new_state}
  end

  def handle_call(:length, _from, state) do
    {:reply, Game.word_length(state), state}
  end

  def handle_call(:letters_used, _from, state) do
    {:reply, Game.letters_used_so_far(state), state}
  end

  def handle_call(:turns_left, _from, state) do
    {:reply, Game.turns_left(state), state}
  end

  def handle_call({:word, reveal}, _from, state) do
    {:reply, Game.word_as_string(state, reveal), state}
  end

  def handle_cast({:crash, reason}, state) do
    {:stop, reason, state}
  end
end
