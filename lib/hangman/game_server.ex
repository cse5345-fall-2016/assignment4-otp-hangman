defmodule Hangman.GameServer do
  use GenServer

  @moduledoc """
  Server Implementation for hangman.
  Very helpful site: http://culttt.com/2016/08/24/understanding-genserver-elixir/
  """

  def start_link do
    state = Game.new_game(Hangman.Dictionary.random_word)
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # API

  def make_move(guess) do
   GenServer.call __MODULE__, { :make_move, guess }
  end

  def word_length do
   GenServer.call __MODULE__, :word_length
  end

  def letters_used_so_far do
   GenServer.call __MODULE__, :letters_used_so_far
  end

  def turns_left do
   GenServer.call __MODULE__, :turns_left
  end

  def word_as_string(reveal \\ false) do
   GenServer.call __MODULE__, { :word_as_string, reveal }
  end

  def crash(reason) do
   GenServer.cast __MODULE__, { :crash, reason }
  end

  # Implementation

  def handle_call({ :make_move, guess }, _from, state) do
    {new_state, status, _ch} = Game.make_move state, guess
    { :reply, status, new_state }
  end

  def handle_call(:word_length, _from, state) do
    { :reply, Game.word_length(state), state }
  end

  def handle_call(:letters_used_so_far, _from, state) do
    { :reply, Game.letters_used_so_far(state), state }
  end

  def handle_call(:turns_left, _from, state) do
    { :reply, Game.turns_left(state), state }
  end

  def handle_call({ :word_as_string, reveal }, _from, state) do
    { :reply, Game.word_as_string(state, reveal), state }
  end

  def handle_cast({ :crash, reason }, state) do
    { :stop, reason, state }
  end



end
