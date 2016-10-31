defmodule Hangman.GameServer do
  use GenServer
  alias Hangman.Game, as: Game
  @me __MODULE__

  #######
  # API #
  #######

  #NOTE TO CALEB:
  # Don't be stupid
  # Remember to freaking match your parameter types... if you send in a tuple make
  # sure that the handle_call() accepts the tuple instead of just the atom
  # Watch out for differences when some functions need to send a tuple and some needs
  # to just send an atom. I recommend just doing everything with a tuple and making
  # it one element or more as necessary.

  #starts the game server passing in a random word to initialize
  def start_link(word \\ Hangman.Dictionary.random_word) do
    GenServer.start_link(@me, word, name: @me)
  end

  def new_game(word \\ Hangman.Dictionary.random_word) do
    GenServer.cast(@me, {:new_game, word})
  end

  def make_move(guess) do
    GenServer.call(@me, {:make_move, guess})
  end

  def word_length do
    GenServer.call(@me, {:word_length})
  end

  def letters_used_so_far do
    GenServer.call(@me, {:letters_used_so_far})
  end

  def turns_left do
    GenServer.call(@me, {:turns_left})
  end

  def word_as_string(reveal \\ false) do
    GenServer.call(@me, {:word_as_string, reveal})
  end

  def crash(reason) do
    GenServer.cast(@me, {:crash, reason})
  end

  #########################
  # Server Implementation #
  #########################

  # this custom defined init() function is called when start_link() is called
  # and has to execute before start_link() can finish execution
  def init(default) do
    { :ok, Game.new_game(default) }
  end

  # this implementation is needed for when the "cast" version is called, that
  # sends back the :noreply atom
  def handle_cast({:new_game, default}) do
    { :noreply, Game.new_game(default) }
  end
  
  def handle_cast({:crash, reason}) do
    {:stop, reason}
  end

  # handle_call() is the only function that returns an updated state because it
  # is the only one that actually mutates the game state, all of the other
  # handle_call() functions just return something about the state
  def handle_call({:make_move, guess}, _from, state) do
    {updated_state, status, _letter} = Game.make_move(state, guess)
    {:reply, status, updated_state} # this line returns status back to the API call and continues with the updated_state
  end

  # word_length only returns the original state instead of updated_state because
  # it doesn't mutate state at all, so returns the passed in state as a default
  def handle_call({:word_length}, _from, state) do
    {:reply, Game.word_length(state), state}
  end

  def handle_call({:letters_used_so_far}, _from, state) do
    {:reply, Game.letters_used_so_far(state), state}
  end

  def handle_call({:turns_left}, _from, state) do
    {:reply, Game.turns_left(state), state}
  end

  def handle_call({:word_as_string, reveal}, _from, state) do
    {:reply, Game.word_as_string(state, reveal), state}
  end

end
