defmodule Hangman.GameServer do

  @me :game

  use GenServer

  def start_link(word \\ Hangman.Dictionary.random_word) do
    IO.puts "Here is start link arg #{word}"
    GenServer.start_link(__MODULE__, word, name: @me)
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
    GenServer.cast(@me, {:guess, letter})
  end

  # imple

  def init(word) do
    IO.puts "Here are the init args #{word}"
    {
      :ok,
      Hangman.Game.new_game(word)
    }
  end

  def handle_call({:word_length}, _from, state) do
    IO.puts "WORD LENGTH JHBSJHGAJHGAJDSHGSJH"
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
    IO.puts "TURNS LEFT"
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

  def handle_cast({:guess, letter}, state) do
    {
      :noreply,
      Hangman.Game.make_move(state, letter),
    }
  end


end
