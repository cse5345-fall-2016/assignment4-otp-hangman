defmodule Hangman.GameServer do
    use GenServer

    alias Hangman.Game, as: Game
    @me __MODULE__
    
    def start_link(default \\ []) do
        GenServer.start_link(__MODULE__, default, name: @me)
    end

    def make_move(guess) do
        GenServer.call(@me, {:guess, guess})
    end

    def word_length() do
        GenServer.call(@me, :length)
    end

    def letters_used_so_far() do
        GenServer.call(@me, :letters_used)
    end

    def turns_left() do
        GenServer.call(@me, :turns_left)
    end

    def word_as_string(reveal \\ false) when is_boolean(reveal) do
        GenServer.call(@me, {:word, reveal})
    end

    #########################
    # Server Implementation #
    #########################

    def init(args) do
      state = Game.new_game()
      {:ok, state}
    end

    def handle_call({:guess, guess}, _from, state) do
        {state, status, _} = Game.make_move(state, guess)
        {:reply, status, state}
    end

    def handle_call(:length, _from, state) do
        len = Game.word_length(state)
        {:reply, len, state}
    end

    def handle_call(:letters_used, _from, state) do
        letters = Game.letters_used_so_far(state)
        {:reply, letters, state}
    end

    def handle_call(:turns_left, _from, state) do
        turns_left = Game.turns_left(state)
        {:reply, turns_left, state}
    end

    def handle_call({:word, reveal}, _from, state) do
        word_string = Game.word_as_string(state, reveal)
        {:reply, word_string, state}
    end

end