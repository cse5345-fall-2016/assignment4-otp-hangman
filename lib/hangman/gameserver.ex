defmodule Hangman.GameServer do

  use GenServer

  alias Hangman.Game, as: Impl
  @me __MODULE__

  #######
  # Api #
  #######

  def start_link(word \\ []) do
    GenServer.start(__MODULE__, word, name: @me)
  end

  def make_move(guess) do
    GenServer.cast( @me, { :make_move, guess })
  end

  def word_length() do
    GenServer.call( @me, { :word_length })
  end

  def letters_used_so_far() do
    GenServer.call( @me, { :letters_used_so_far })
  end

  def turns_left() do
    GenServer.call( @me, { :turns_left })
  end

  def word_as_string(reveal \\ false) do
    GenServer.call( @me, { :word_as_string, reveal })
  end

  #######################
  # Server Implemention #
  #######################

  def init(word \\ Hangman.Dictionary.random_word) do
    { :ok, %{
              word:        String.codepoints(word) |> Enum.map(&{&1, false}),
              turns_left:  10,
              guessed:     MapSet.new,
            }
    }
  end

  def handle_cast( { :make_move, guess }, _from, state) do
    { :noreply, Impl.make_move(state, guess) }
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
