defmodule Hangman.GameServer do
  use GenServer
  require Logger

  # Implementation module alias
  alias Hangman.Game, as: Impl
  @serverName :GameServer

    ##########
    #  API   #
    ##########
    def start_link(word \\nil) do
      Logger.info "Word #{word}"
      GenServer.start_link(__MODULE__, Impl.new_game(word), name: @serverName)
    end

    def new_game(word \\ Hangman.Dictionary.random_word) do
      Logger.info "Word #{word}"
      GenServer.call(@serverName, {:new_game, word})
    end

    def word_length do
      GenServer.call(@serverName, :word_length)
    end

    def letters_used_so_far do
      GenServer.call(@serverName, :letters_used)
    end

    def turns_left do
      GenServer.call(@serverName, :turns_left)
    end

    def make_move(guess) do
      GenServer.call(@serverName, {:make_move, guess})
    end

    def word_as_string(boolean \\false) do
      GenServer.call(@serverName, {:word_as_string, boolean})
    end

  ############################
  #  Server Implementation   #
  ############################

  def handle_call({:new_game, word}, _from, state) do
    {:reply, Impl.new_game(state, word), state}
  end

  def handle_call(:word_length, _from, state) do
    {:reply, Impl.word_length(state), state}
  end

  def handle_call(:letters_used, _from, state) do
    {:reply, Impl.letters_used_so_far(state), state}
  end

  def handle_call(:turns_left, _from, state) do
    {:reply, Impl.turns_left(state), state}
  end

  def handle_call({:make_move,guess}, _from, state) do
     { game, status, guess } = Impl.make_move(state,guess)
    {:reply, status, game}
  end

  def handle_call({:word_as_string,boolean}, _from, state) do
    {:reply, Impl.word_as_string(state,boolean), state}
  end

end
