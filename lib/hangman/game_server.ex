defmodule Hangman.GameServer do
  use GenServer

  @moduledoc """
  We act as an interface for the hangman game.
  """

  alias Hangman.Game, as: G
  alias Hangman.Dictionary, as: D

  @name :game

  def new_game(word) do
    GenServer.call(@name, { :new_game, word })
  end

  def make_move(guess) do
    GenServer.call(@name, { :make_move, guess })
  end

  def word_length() do
    GenServer.call(@name, { :word_length })
  end

  def letters_used_so_far() do
    GenServer.call(@name, { :letters_used_so_far })
  end

  def turns_left() do
    GenServer.call(@name, { :turns_left })
  end

  def word_as_string(reveal \\ false) do
    GenServer.call(@name, { :word_as_string, reveal})
  end


  def start_link(word \\ D.random_word) do
    GenServer.start_link(__MODULE__, word, name: @name)
  end

  def crash(reason) do
    GenServer.cast(@name, { :crash, reason })
  end

  def init(word) do
    { :ok, G.new_game(word) }
  end

  def handle_call({ :new_game, word }, _from, state) do
    game = G.new_game(word)
    { :reply, game, state }
  end

  def handle_call({ :make_move, guess}, _from, state) do
    { g, s, _} = G.make_move(state, guess)
    {:reply, s, g}
  end

  def handle_call({ :word_length }, _from, state) do
    { :reply, G.word_length(state), state }
  end

  def handle_call({ :letters_used_so_far }, _from, state) do
    { :reply, G.letters_used_so_far(state), state}
  end

  def handle_call({ :turns_left }, _from, state) do
    { :reply, G.turns_left(state), state }
  end

  def handle_call({ :word_as_string, reveal }, _from, state) do
    { :reply, G.word_as_string(state, reveal), state}
  end
end
