defmodule Hangman.GameServer do
  use GenServer
  alias Hangman.Game, as: Game
  @me :gameServer

  #########################
  #         API           #
  #########################

  def start_link do
    GenServer.start_link(__MODULE__, Game.new_game, name: @me)
  end

  def start_link(word) do
    GenServer.start_link(__MODULE__, Game.new_game(word), name: @me)
  end

  def crash(reason), do: GenServer.cast(@me, { :crash, reason })

  def make_move(guess) do
    GenServer.call(@me, { :make_move, guess })
  end

  def word_length do
    GenServer.call(@me, { :word_length })
  end

  def letters_used_so_far do
    GenServer.call(@me, { :letters_used_so_far })
  end

  def turns_left do
    GenServer.call(@me, { :turns_left })
  end

  def word_as_string(reveal \\ false) do
    GenServer.call(@me, { :word_as_string, reveal })
  end

  #############################
  #  GenServer implementation #
  #############################

  ####GenServer init call back####
  def init(state) do
    { :ok, state }
  end

  ######GenServer handle_call########
  def handle_call({ :make_move, guess }, _from, state) do
    response = state |> Game.make_move(guess)
    { :reply, elem(response, 1), elem(response, 0)}
  end

  def handle_call({ :word_length }, _from, state) do
    { :reply, Game.word_length(state), state }
  end

  def handle_call({ :letters_used_so_far }, _from, state) do
    { :reply, Game.letters_used_so_far(state), state }
  end

  def handle_call({ :turns_left }, _from, state) do
    { :reply, Game.turns_left(state), state }
  end

  def handle_call({ :word_as_string, reveal }, _from, state) do
    { :reply, Game.word_as_string(state, reveal), state }
  end


  def handle_cast({ :crash, reason }, state) do
    { :stop, reason, state }
  end



end
