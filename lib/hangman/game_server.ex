defmodule Hangman.GameServer do
  use GenServer

  @me __MODULE__

  ##############
  # Public API #
  ##############

  def start_link(word \\ Hangman.Dictionary.random_word) do
    GenServer.start_link(@me, word, name: @me)
  end

  def new_game(word \\ Hangman.Dictionary.random_word) do
    GenServer.cast(@me, { :new_game, word })
  end

  def word_as_string(reveal \\ false) do
    GenServer.call(@me, { :word_as_string, reveal })
  end

  def word_length do
    GenServer.call(@me, { :word_length })
  end

  def turns_left do
    GenServer.call(@me, { :turns_left })
  end

  def letters_used_so_far do
    GenServer.call(@me, { :letters_used_so_far })
  end

  def make_move(letter) do
    GenServer.call(@me, { :make_move, letter })
  end

  def crash(reason) do
    GenServer.cast(@me, { :crash, reason})
  end

  #########################
  # Server Implementation #
  #########################

  def init(word) do
    { :ok, Hangman.Game.new_game(word) }
  end

  def handle_cast({ :new_game, word }) do
    { :noreply, Hangman.Game.new_game(word) }
  end

  def handle_call({ :word_as_string, reveal }, _from, state) do
    { :reply, Hangman.Game.word_as_string(state, reveal), state }
  end

  def handle_call({ :word_length }, _from, state) do
    { :reply, Hangman.Game.word_length(state), state }
  end

  def handle_call({ :turns_left }, _from, state) do
    { :reply, Hangman.Game.turns_left(state), state }
  end

  def handle_call({ :letters_used_so_far }, _from, state) do
    { :reply, Hangman.Game.letters_used_so_far(state), state }
  end

  def handle_call({ :make_move, letter }, _from, state) do
    { updated_state, status, _letter } = Hangman.Game.make_move(state, letter)
    { :reply, status, updated_state }
  end

  def handle_cast({ :crash, reason }, _from, state) do
    { :stop, reason, state }
  end
end
