defmodule Hangman.GameServer do

  #######################
  #         API         #
  #######################


  import Supervisor.Spec, warn: false
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__,opts,name: :game)
  end

  def init([]) do
    { :ok,   GenServer.call(:dictionary,{:get_word})
            |> Hangman.Game.new_game()
    }
  end

  def init(word) do
    { :ok, Hangman.Game.new_game(word) }
  end

  def handle_call({:make_move, guess},_from,state) do
    {game, status, _guessed_letter} = Hangman.Game.make_move(state,guess)
    {:reply, status , game}
  end

  def handle_call({ :letters_used },_from,state) do
    {:reply,  Hangman.Game.letters_used_so_far(state), state}
  end

  def handle_call({:word_as_string, reveal},_from,state) do
    {:reply,  Hangman.Game.word_as_string(state,reveal), state}
  end

  def handle_call({:turns_left},_from,state) do
    {:reply,  Hangman.Game.turns_left(state), state}
  end

  def handle_call({:word_length},_from,state) do
    {:reply,  Hangman.Game.word_length(state), state}
  end

  def make_move(guess) do
    GenServer.call(:game,{:make_move,guess})
  end

  def letters_used_so_far() do
    GenServer.call(:game,{:letters_used})
  end

  def turns_left() do
    GenServer.call(:game,{:turns_left})
  end

  def word_as_string(reveal \\ false) do
    GenServer.call(:game,{:word_as_string, reveal})
  end

  def word_length() do
    GenServer.call(:game,{:word_length})
  end

  def crash(reason \\ :normal) do
    GenServer.stop(:game,reason)
  end

end
