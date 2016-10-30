defmodule Hangman.GameServer do

  use GenServer

  alias Hangman.Game, as: Impl
  @servername :gameserver

  #######
  # Api #
  #######

  def start_link(word \\ Hangman.Dictionary.random_word) do
    GenServer.start_link(__MODULE__, word, name: @servername)
  end

  def new_game(word \\ Hangman.Dictionary.random_word) do
    GenServer.cast( @servername, { :new_game, word })
  end

  def make_move(guess) do
    GenServer.call( @servername, { :make_move, guess })
  end

  def word_length do
    GenServer.call( @servername, { :word_length })
  end

  def letters_used_so_far do
    GenServer.call( @servername, { :letters_used_so_far })
  end

  def turns_left  do
    GenServer.call( @servername, { :turns_left })
  end

  def word_as_string(reveal \\ false) do
    GenServer.call( @servername, { :word_as_string, reveal })
  end

  def crash(reason) do
    GenServer.cast( @servername, { :crash, reason })
  end

  #######################
  # Server Implemention #
  #######################

  def init(word) do
    { :ok, Impl.new_game(word) }
  end

  def handle_cast({ :new_game, word }, _state) do
    { :noreply, Impl.new_game(word) }
  end

  def handle_cast({ :crash, reason }, state) do
    { :stop, reason, state }
  end

  def handle_call( { :make_move, guess }, _from, state) do
    {newstate, atom, _ch} = Impl.make_move(state, guess)
    { :reply, atom , newstate }
  end

  def handle_call( { :word_length }, _from, state) do
    { :reply, Impl.word_length(state), state }
  end

  def handle_call( { :letters_used_so_far }, _from, state) do
    { :reply, Impl.letters_used_so_far(state), state }
  end

  def handle_call( { :turns_left }, _from, state ) do
    { :reply, Impl.turns_left(state), state }
  end

  def handle_call( { :word_as_string, reveal }, _from, state ) do
    { :reply, Impl.word_as_string(state, reveal), state }
  end

end
