defmodule Hangman.GameServer do
  use GenServer

  @me :game_server

  def start_link(word \\ Hangman.Dictionary.random_word) do
    GenServer.start_link(__MODULE__, word, name: @me)
  end

  def crash(reason) do
    GenServer.cast(@me, { :crash, reason })
  end

  def new_game(word \\ Hangman.Dictionary.random_word) do
    GenServer.call(@me, { :new_game, word })
  end

  def make_move(guess) do
    GenServer.call(@me, { :make_move, guess })
  end

  def word_length() do
    GenServer.call(@me, { :word_length })
  end

  def letters_used_so_far() do
    GenServer.call(@me, { :letters_used_so_far })
  end

  def turns_left() do
    GenServer.call(@me, { :turns_left })
  end

  def word_as_string(reveal \\ false) do
    GenServer.call(@me, { :word_as_string, reveal })
  end

  #########################
  # Server Implementation #
  #########################

  def init(word) do
    game = Hangman.Game.new_game(word)
    { :ok, game }
  end

  def handle_call({ :crash, reason }, _from, state) do
    { :stop, reason, state }
  end

  def handle_call({ :new_game, word }, _from, state) do
    game = Hangman.Game.new_game(word)
    { :reply, game, game }
  end

  def handle_call({ :make_move, guess }, _from, state) do
    { game, status, _ } = Hangman.Game.make_move(state, guess)
    { :reply, status, game }
  end

  def handle_call({ :word_length }, _from, state) do
    { :reply, Hangman.Game.word_length(state), state}
  end

  def handle_call({ :letters_used_so_far }, _from, state) do
    { :reply, Hangman.Game.letters_used_so_far(state), state }
  end

  def handle_call({ :turns_left }, _from, state) do
    { :reply, Hangman.Game.turns_left(state), state }
  end

  def handle_call({ :word_as_string, reveal }, _from, state) do
    { :reply, Hangman.Game.word_as_string(state, reveal), state }
  end
end
