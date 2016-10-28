defmodule Hangman.GameServer do
  use GenServer

  alias Hangman.Game, as: Impl
  @me :gameserver

  def start_link(default \\ "") do
    GenServer.start_link(__MODULE__, default, name: @me)
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

  def crash(reason) do
    GenServer.cast(@me, { :crash, reason })
  end

  #######################
  # Server Implemention #
  #######################

  def init(word) do
    word |> to_string
    is_empty_word = String.strip(word) == ""

    new_game =
      case is_empty_word do
      true  -> Impl.new_game()
      false -> Impl.new_game(word)
    end

    { :ok, new_game  }
  end

  def handle_call({ :make_move, guess }, _from, state) do
    { state, status, _guess} = Impl.make_move(state, guess)
    { :reply, status, state }
  end

  def handle_call({ :word_length }, _from, state) do
    { :reply, Impl.word_length(state), state }
  end

  def handle_call({ :letters_used_so_far }, _from, state) do
    { :reply, Impl.letters_used_so_far(state), state }
  end

  def handle_call({ :turns_left }, _from, state) do
    { :reply, Impl.turns_left(state), state }
  end

  def handle_call({ :word_as_string, reveal }, _from, state) do
    { :reply, Impl.word_as_string(state, reveal), state }
  end

  def handle_cast({ :crash, reason }, state) do
    { :stop, reason, state }
  end

end
