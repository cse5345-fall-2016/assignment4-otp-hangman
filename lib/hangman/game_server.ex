defmodule Hangman.GameServer do
  use GenServer
  alias Hangman.Game, as: GameImpl
  @me __MODULE__

  ################
  # External API #
  ################

  def start_link(word \\ Hangman.Dictionary.get_current_word) do
    GenServer.start_link(__MODULE__, word, name: @me)
  end

  def make_move(guess) do
    GenServer.call(@me, {:make_move, guess})
  end

  def word_length() do
    GenServer.call(@me, {:get_length})
  end

  def letters_used_so_far() do
    GenServer.call(@me, {:get_letters_used})
  end

  def turns_left() do
    GenServer.call(@me, {:get_count})
  end

  def word_as_string(reveal \\ false) do
    GenServer.call(@me, {:get_word, reveal})
  end

  def crash(reason) do
    GenServer.cast(@me, {:crash, reason})
  end

  ##################
  # Implementation #
  ##################

  def init(word) do
    game = GameImpl.new_game(word)
    {:ok, game}
  end

  def handle_call({:make_move, guess}, _from, state) do
    {new_state, status, _guess} = GameImpl.make_move(state, guess)
      {:reply, status, new_state}
  end

  def handle_call({:get_length},_from, state) do
    len = GameImpl.word_length(state)
    {:reply, len, state}
  end

  def handle_call({:get_letters_used},_from, state) do
    letters_used = GameImpl.letters_used_so_far(state)
    {:reply, letters_used, state}
  end

  def handle_call({:get_count}, _from, state) do
    turns = GameImpl.turns_left(state)
    {:reply, turns, state}
  end

  def handle_call({:get_word, reveal}, _from, state) do
    word_str = GameImpl.word_as_string(state, reveal)
    {:reply, word_str, state}
  end

  def handle_cast({:crash, reason}, state) do
    {:stop, reason, state}
  end

end
