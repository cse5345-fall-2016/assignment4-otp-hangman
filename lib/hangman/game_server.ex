defmodule Hangman.GameServer do

  @me :game

  use GenServer

  def start_link(word \\ Hangman.Dictionary.random_word) do
    GenServer.start_link(__MODULE__, word, name: @me)
  end

  def new_game(word \\ Hangman.Dictionary.random_word) do
    GenServer.cast(@me, {:new_game, word})
  end

  def word_length do
    GenServer.call(@me, {:word_length})
  end

  def letters_used_so_far do
    GenServer.call(@me, {:letters_used_so_far})
  end

  def turns_left do
    GenServer.call(@me, {:turns_left})
  end

  def word_as_string(reveal \\ false) do
    GenServer.call(@me, {:word_as_string, reveal})
  end

  def make_move(letter) do
    GenServer.call(@me, {:guess, letter})
  end

  def crash(reason) do
    GenServer.cast(@me, {:crash, reason})
  end

  # imple

  def init(word) do
    {
      :ok,
      Hangman.Game.new_game(word)
    }
  end

  def handle_call({:word_length}, _from, state) do
    {
      :reply,
      Hangman.Game.word_length(state),
      state
    }
  end

  def handle_call({:letters_used_so_far}, _from, state) do
    {
      :reply,
      Hangman.Game.letters_used_so_far(state),
      state
    }
  end

  def handle_call({:turns_left}, _from, state) do
    {
      :reply,
      Hangman.Game.turns_left(state),
      state
    }
  end

  def handle_call({:word_as_string, reveal}, _from, state) do
    {
      :reply,
      Hangman.Game.word_as_string(state, reveal),
      state
    }
  end

  def handle_call({:guess, letter}, _from, state) do
    {new_state, reply_status, _word} = Hangman.Game.make_move(state, letter)
    {
      :reply,
      reply_status,
      new_state
    }
  end

  def handle_cast({:new_game, word}, _state) do
    {:noreply, Hangman.Game.new_game(word)}
  end

  def handle_cast({:crash, reason}, state) do
    {:stop, reason, state}
  end


end
