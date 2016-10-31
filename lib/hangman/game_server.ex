defmodule Hangman.GameServer do
  @moduledoc false
  use GenServer
  def start_link(current_word\\Hangman.Dictionary.random_word) do
    game = Hangman.Game.new_game(current_word)
    GenServer.start_link(__MODULE__, game, name: :gameServer)
  end

 
  ###################
  # External API

  def new_game(current_word\\Hangman.Dictionary.random_word) do
    GenServer.cast(:gameServer, {:new_game, current_word})
  end

  def word_length do
    GenServer.call :gameServer, :word_length
  end

  def word_as_string(flag\\false) do
    GenServer.call :gameServer, {:word_as_string, flag}
  end

  def make_move(guess) do
      GenServer.call :gameServer, {:make_move, guess}
    end

  def make_move(_from, guess) do
    GenServer.call :gameServer, {:make_move, guess}
  end

  def letters_used_so_far() do
    GenServer.call :gameServer, :letters_used_so_far
  end

  def turns_left do
    GenServer.call :gameServer, :turns_left
  end

  def crash(:normal) do
    GenServer.cast :gameServer, {:crash, :normal}
  end

   ###################
   # GenServer implementation

   def handle_cast({:new_game, current_word}, game) do
     { :noreply, Hangman.Game.new_game(current_word)}
   end

  def handle_call(:word_length, _from, game) do
    { :reply, Hangman.Game.word_length(game), game }
  end

  def handle_call({:make_move, guess}, _from, game) do
    { new_game, status, _word } = Hangman.Game.make_move(game, guess)
    { :reply, status, new_game }
  end

  def handle_call({:word_as_string, flag}, _from, game) do
    { :reply, Hangman.Game.word_as_string(game, flag), game }
  end

  def handle_call(:letters_used_so_far, _from, game) do
    { :reply, Hangman.Game.letters_used_so_far(game), game}
  end

  def handle_call(:turns_left, _from, game) do
    { :reply, Hangman.Game.turns_left(game), game}
  end

  def handle_cast({:crash, :normal}, _from, game) do
    { :stop, :normal, game}
  end

end
