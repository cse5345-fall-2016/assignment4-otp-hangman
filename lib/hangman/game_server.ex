defmodule Hangman.GameServer do
 
    use GenServer
	
	# API implementation
	
    def init(word) do
       {:ok, Hangman.Game.new_game(word)}
    end
       
    def make_move(guess) do
        GenServer.call(:game, {:make_move, guess})
    end

    def word_length do
        GenServer.call(:game, {:word_length})
    end
    
    def word_as_string(reveal \\ false) do
        GenServer.call(:game, {:word_as_string, reveal})
    end
  
    def letters_used_so_far do
        GenServer.call(:game, {:letters_used_so_far})
    end
  
    def turns_left() do
        GenServer.call(:game, {:turns_left})
    end

    def crash(reason) do
        GenServer.cast(:game, { :crash, reason})
    end

  # GenServer Implementation 
  
    def start_link(word) do
        GenServer.start_link(__MODULE__, word, name: :game)
    end
	
    def start_link() do 
        GenServer.start_link(__MODULE__, GenServer.call(:dictionary, :random_word), name: :game)
    end
 
    def handle_call({:make_move, guess}, _from, state) do
        {new_state, status, _} = Hangman.Game.make_move(state, guess)
        {:reply, status, new_state}
    end

    def handle_call({ :word_length}, _from, state) do
        {:reply, Hangman.Game.word_length(state), state}
    end
   
    def handle_call({ :word_as_string, reveal}, _from, state) do
        {:reply, Hangman.Game.word_as_string(state, reveal), state}
    end

    def handle_call({ :letters_used_so_far}, _from, state) do
        {:reply, Hangman.Game.letters_used_so_far(state), state}
    end
  
    def handle_call({ :turns_left}, _from, state) do
        {:reply, Hangman.Game.turns_left(state), state}
    end

    def handle_call({ :crash, reason}, state) do
        {:stop, reason, state}
    end

end