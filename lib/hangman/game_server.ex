defmodule Hangman.GameServer do
  use GenServer
  @name :game_server

  def start_link do
    GenServer.start_link(__MODULE__, Hangman.Game.new_game, name: @name)
  end

  def start_link word do
    GenServer.start_link(__MODULE__, Hangman.Game.new_game(word), name: @name)
  end

  def make_move(guess) do
    GenServer.call(@name, {:make_move, guess})
  end

  def word_length do
    GenServer.call(@name, {:word_length})
  end

  def letters_used_so_far do
    GenServer.call(@name, {:letters_used_so_far})
  end

  def turns_left do
    GenServer.call(@name, {:turns_left})
  end
  def word_as_string do
    GenServer.call(@name, {:word_as_string})
  end
  def word_as_string reveal do
    GenServer.call(@name, {:word_as_string, reveal})
  end
  def crash reason do
    GenServer.cast(@name, {:crash, reason})
  end


  ######Implementation########

  def handle_call({:make_move, guess}, _from, state) do
    {state, response, _} = Hangman.Game.make_move(state, guess)
    {:reply, response, state}
  end
  def handle_call({:word_length}, _from, state) do
    {:reply, Hangman.Game.word_length(state), state}
  end
  def handle_call({:letters_used_so_far}, _from, state) do
    {:reply, Hangman.Game.letters_used_so_far(state), state}
  end
  def handle_call({:turns_left}, _from, state) do
    {:reply, Hangman.Game.turns_left(state), state}
  end
  def handle_call({:word_as_string}, _from, state) do
    {:reply, Hangman.Game.word_as_string(state), state}
  end
  def handle_call({:word_as_string, reveal}, _from, state) do
    {:reply, Hangman.Game.word_as_string(state, reveal), state}
  end
  def handle_cast({:crash, reason}, state) do
    {:stop, reason, state}
  end


end
