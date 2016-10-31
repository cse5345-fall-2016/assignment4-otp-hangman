defmodule Hangman.GameServer do
  use GenServer
  alias Hangman.Game, as: G
  @me __MODULE__
  
  #######
  # API #
  #######
    
  def start_link(word \\ Hangman.Dictionary.random_word) do
  	GenServer.start_link(@me, word, name: @me)
  end
  
  def new_game(word \\ Hangman.Dictionary.random_word) do
  	GenServer.cast(@me, {:new_game, word})
  end
  
  def make_move(guessed) do
  	GenServer.call(@me, {:make_move, guessed})
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
  
  def init(word) do
    {:ok, G.new_game(word)}
  end

  def handle_cast({:new_game, word}, state) do
  	{:noreply, G.new_game(word)}
  end
  
  def handle_cast({:crash, reason}, state) do
  	{:stop, reason}
  end
  
  def handle_call({:make_move, guessed}, _from, state) do
	{new_state, status, guessed} = G.make_move(state, guessed)
	{:reply, status, new_state}
  end
  
  def handle_call({:word_length}, _from, state) do
  	{:reply, G.word_length(state), state}
  end
  
  def handle_call({:letters_used_so_far}, _from, state) do
  	{:reply, G.letters_used_so_far(state), state}
  end
  
   def handle_call({:turns_left}, _from, state) do
   	{:reply, G.turns_left(state), state}
   end
   
   def handle_call({:word_as_string, reveal}, _from, state) do
   	{:reply, G.word_as_string(state, reveal), state}
   end
end