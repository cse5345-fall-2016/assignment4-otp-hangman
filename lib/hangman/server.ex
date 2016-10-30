defmodule Hangman.GameServer do
  use GenServer

  alias Hangman.Game, as: Game
  alias Hangman.Dictionary, as: Dictionary

  #####
  #External API
  def start_link do
    GenServer.start(__MODULE__, Game.new_game, name: :server)
  end
  def start_link(word) do
    GenServer.start(__MODULE__, Game.new_game(word) , name: :server)
  end

  def new_game(word \\ Dictionary.random_word) do
    GenServer.cast(:server, {:newGame,word})
  end

  def make_move(guess) do
    GenServer.call(:server, {:make_move, guess})
  end

  def word_length do
    GenServer.call(:server, {:word_length})
  end

  def letters_used_so_far do
    GenServer.call(:server, {:letters})
  end

  def turns_left do
    GenServer.call(:server, {:turns_left})
  end

  def word_as_string(reveal \\ false) do
    GenServer.call(:server, {:word_as_string, reveal})
  end

  def crash(status) do
    GenServer.cast(:server, {:crash, status})
  end

  #####
  #GenServer implementation
  def init(state) do
    {:ok, state}
  end


  def handle_call({:make_move, guess}, _from, state) do
    response = Game.make_move(state,guess)
    {:reply, elem(response, 1), elem(response , 0)}
  end

  def handle_call({:word_length},_from, state) do
    {:reply, Game.word_length(state), state}
  end

  def handle_call({:letters},_from, state) do
    {:reply, Game.letters_used_so_far(state), state}
  end

  def handle_call({:turns_left}, _from, state) do
    {:reply, Game.turns_left(state), state}
  end

  def handle_call({:word_as_string,reveal}, _from, state) do
    { :reply, state |> Game.word_as_string(reveal), state}
  end

  def handle_cast({:crash,status},state) do
    {:stop, status, state}
  end
end
