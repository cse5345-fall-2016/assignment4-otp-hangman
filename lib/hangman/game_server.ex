defmodule Hangman.GameServer do
  use GenServer
  alias Hangman.Game, as: Impl
  @me __MODULE__

  def start_link(module, default \\ []) do
    GenServer.start_link(module, default, name: @me)
  end

  #def new_game(word) do
  #  GenServer.call(@me, { :new_game, word })
  #end

  def make_move(guess) do
    game_state = GenServer.call(@me, { :new_game, nil })
    GenServer.call(@me, { :make_move, game_state, guess })
  end

  def word_length(game_state) do
    GenServer.call(@me, { :word_length, game_state })
  end

  def letters_used_so_far(game_state) do
    GenServer.call(@me, { :letters_used_so_far, game_state })
  end

  def turns_left(game_state) do
    GenServer.call(@me, { :turns_left, game_state })
  end

  def word_as_string(game_state, boolean) do
    GenServer.call(@me, { :word_as_string, game_state, boolean})
  end

  #######################
  # Server Implemention #
  #######################

  def init(state) do
    { :ok, state }
  end

  def handle_call({ :new_game, word }, _from, state) do
    { :reply, Impl.new_game(word), state }
  end

  def handle_call({ :make_move, game_state, guess }, _from, state) do
    { :reply, Impl.make_move(game_state, guess), state }
  end

  def handle_call({ :word_length, game_state }, _from, state) do
    { :reply, Impl.word_length(game_state), state }
  end

  def handle_call({ :letters_used_so_far, game_state }, _from, state) do
    { :reply, Impl.letters_used_so_far(game_state), state }
  end

  def handle_call({ :turns_left, game_state }, _from, state) do
    { :reply, Impl.turns_left(game_state), state }
  end

  def handle_call({ :word_as_string, game_state, boolean }, _from, state) do
    { :reply, Impl.word_as_string(game_state, boolean), state }
  end

end
