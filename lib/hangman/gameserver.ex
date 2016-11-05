defmodule Hangman.GameServer do
  use GenServer
  alias Hangman.Game, as: Game


  @me __MODULE__
  import Hangman.Crasher

  #############
  ##   API   ##
  #############
   def start_link(word \\ Hangman.Dictionary.random_word) do
     GenServer.start_link(__MODULE__, word)
   end
  def new_game do
    GenServer.call(@me, {:new_game})
  end
  def word_as_string(pid \\ @me, reveal \\ false) do
    GenServer.call(pid, {:word_as_string, reveal})
  end
  def make_move(pid \\ @me, guess) do
    GenServer.call(pid, {:make_move, guess})
  end

  def word_length(pid \\ @me) do
    GenServer.call(pid, {:word_length})
  end
  def letters_used_so_far(pid \\ @me) do
    GenServer.call(pid, {:letters_used_so_far})
  end
  def turns_left(pid \\ @me) do
    GenServer.call(pid, {:turns_left})
  end

  #misc. func.s
  def stop(pid \\ @me) do
    GenServer.stop(pid)
  end
  def show_state(pid \\ @me) do
    GenServer.call(pid, {:show_state})
  end
  def crash(pid \\ @me, reason) do
    GenServer.cast(pid, {:crash, reason})
  end

  ########################
  ##   Implementation   ##
  ########################
  def init(word) do
    { :ok, Game.new_game(word) }
  end

  #calls
  def handle_call({:show_state}, _from, state) do
    { :reply, state, state}
  end
  def handle_call({:new_game}, _from, state) do
    { :reply, Game.new_game, state}
  end
  def handle_call({:word_as_string, reveal}, _from, state) do
    { :reply, Game.word_as_string(state, reveal), state}
  end
  def handle_call({:make_move, guess}, _from, state) do
    {state,  status, guess} = Game.make_move(state, guess)
   { :reply, status, state }
  end
  def handle_call({:word_length}, _from, state) do
    {:reply, Game.word_length(state), state}
  end
  def handle_call({:letters_used_so_far}, _from, state) do
    {:reply, Game.letters_used_so_far(state), state}
  end
  def handle_call({:turns_left}, _from, state) do
    {:reply, Game.turns_left(state), state}
  end


  #casts
  # def handle_cast({:new_game}, state) do
  #   { :noreply, Game.new_game}
  # end
  def handle_cast({:crash, reason}, state) do
    {:stop, reason, state}
  end


end
