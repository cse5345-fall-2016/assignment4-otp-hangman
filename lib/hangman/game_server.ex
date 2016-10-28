defmodule Hangman.GameServer do
  use GenServer

  @me :game_server

  alias Hangman.Game, as: Game

  ## Client API

  @doc """
  Starts the game server.
  """
  def start_link(word \\ Hangman.Dictionary.random_word) do
    GenServer.start_link(__MODULE__, word, name: @me)
  end

  @doc """
  Stops the game server.
  """
  def stop(server) do
    GenServer.stop(server)
  end

  @doc """
  Gets errors if defined as a call instead of a cast
  """

  def crash(msg) do
    GenServer.cast(@me, { :crash, msg })
  end

  @doc """
  Gameplay API calls
  """

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
 	  GenServer.call(@me, { :word, reveal })
  end

  ## Server Callbacks

  def init(word) do
    {:ok, Game.new_game(word)}
  end

  def handle_cast({:crash, msg}, state) do
    {:stop, msg, state}
  end

  def handle_call({ :make_move, guess }, _from, state) do
   	{ new_state, status, _op_guess } = Game.make_move(state, guess)
   	{:reply, status, new_state}
  end

  def handle_call({ :word_length }, _from, state) do
 	  {:reply, Game.word_length(state), state}
  end
 
  def handle_call({ :letters_used_so_far }, _from, state) do
 	  {:reply, Game.letters_used_so_far(state), state}
  end
 
  def handle_call({ :turns_left }, _from, state) do
 	  {:reply, Game.turns_left(state), state}
  end
 
  def handle_call({ :word, reveal }, _from, state) do
 	  {:reply, Game.word_as_string(state, reveal), state}
  end

end 
