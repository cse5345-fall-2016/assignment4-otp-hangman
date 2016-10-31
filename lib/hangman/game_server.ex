defmodule Hangman.Game_Server do

    use GenServer
    @ai :game_server

    # ========================== Start ================================

    def start_link do
      GenServer.start(__MODULE__, Hangman.Game.new_game, name: @ai)
    end

    def start_link(word) do
      GenServer.start(__MODULE__, Hangman.Game.new_game(word), name: @ai)
    end

    # =================================================================
    # ========================== Casts ================================

    def new_game(word \\ Hangman.Dictionary.random_word) do
        GenServer.cast(@ai, {:new_game, word})
    end

    def crash(reason) do
        GenServer.cast(@ai, { :crash, reason})
    end

    # =================================================================
    # ========================== Calls ================================

    def word_length do
        GenServer.call(@ai, { :word_length})
    end

    def make_move(guess) do
        GenServer.call(@ai, { :make_move, guess})
    end

    def letters_used_so_far do
        GenServer.call(@ai, { :letters_used_so_far })
    end

    def turns_left do
        GenServer.call(@ai, { :turns_left })
    end

    def word_as_string(reveal \\ false) do
        GenServer.call(@ai, { :word_as_string, reveal})
    end

    # =================================================================
    # ====================== Handle Calls =============================

    def handle_call({ :word_length}, _from, state) do
        { :reply, Hangman.Game.word_length(state), state }
    end

    def handle_call({ :letters_used_so_far}, _from, state) do
        { :reply, Hangman.Game.letters_used_so_far(state), state }
    end

    def handle_call({ :turns_left}, _from, state) do
        { :reply, Hangman.Game.turns_left(state), state }
    end

    def handle_call({ :word_as_string, reveal}, _from, state) do
        { :reply, Hangman.Game.word_as_string(state, reveal), state }
    end

    def handle_call({ :make_move}, _from, state) do
        { new_state, win_status, guess} = Hangman.Game.make_move(state, guess)
        { :reply, Hangman.Game.turns_left(state), state }
    end

    # =================================================================
    # ====================== Handle Casts =============================

    def handle_cast({ :new_game, word }, _from, state) do
      { :no_reply, Hangman.Game.new_game(word) }
    end

    def handle_cast({ :crash, reason}, _from, state) do
        { :stop, reason, state}
    end

    # =================================================================

end
