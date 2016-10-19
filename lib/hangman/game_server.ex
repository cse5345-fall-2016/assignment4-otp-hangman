defmodule Hangman.GameServer do
    use GenServer
    alias Hangman.Game, as: Game

    @me :game_server

    @doc """
    Start the GenServer and initialize game state with a random word.
    """
    def start_link do
        GenServer.start_link(__MODULE__, Game.new_game, name: @me)
    end

    @doc """
    Start the GenServer and initialize game state with a chosen word.
    """
    def start_link(word) do
        GenServer.start_link(__MODULE__, Game.new_game(word), name: @me)
    end

    def make_move(guess),                do: GenServer.call(@me, { :make_move, guess })
    def word_length,                     do: GenServer.call(@me, { :word_length })
    def letters_used_so_far,             do: GenServer.call(@me, { :letters_used_so_far })
    def turns_left,                      do: GenServer.call(@me, { :turns_left })
    def word_as_string(reveal \\ false), do: GenServer.call(@me, { :word_as_string, reveal })


    #######################
    # Server Implemention #
    #######################

    @doc """
    GenServer.init/1 callback
    """
    def init(state), do: { :ok, state }

    @doc """
    GenServer.handle_call/3 callback
    """
    def handle_call({ :make_move, guess }, _from, state) do
        { new_state, status, _ } = state |> Game.make_move(guess)
        { :reply, status, new_state }
    end
    def handle_call({ :word_length }, _from, state) do
        { :reply, state |> Game.word_length, state }
    end
    def handle_call({ :letters_used_so_far }, _from, state) do
        { :reply, state |> Game.letters_used_so_far, state }
    end
    def handle_call({ :turns_left }, _from, state) do
        { :reply, state |> Game.turns_left, state }
    end
    def handle_call({ :word_as_string, reveal }, _from, state) do
        { :reply, state |> Game.word_as_string(reveal), state }
    end

end