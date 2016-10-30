defmodule Hangman.GameServer do
    use GenServer
	alias Hangman.Game, as: Impl
	
	@me __MODULE__
	
	#####
	#API#
	#####
	
	def start_link(word \\ Hangman.Dictionary.Server.random_word) do
        GenServer.start_link(__MODULE__, word, name: @me)
	end
    
    def new_game()do
        GenServer.cast(@me, {:new})
	end
	
	def new_game(word)do
        GenServer.cast(@me, {:new, word})
	end
	
	def make_move( guess)do
        GenServer.call(@me, {:move, guess})
	end
	
	def word_length() do
        GenServer.call(@me, {:length})
	end
	
	def letters_used_so_far() do
        GenServer.call(@me, {:letters_used})
	end
	
	def turns_left() do
        GenServer.call(@me, {:turns})
	end
	
	def word_as_string( reveal \\ false) do
        GenServer.call(@me, {:word_string, reveal})
	end
    
    def crash(reason) do
        GenServer.cast(@me, {:crash, reason})
    end
	
	################
	#Implementation#
	################
	
	def init(word)do 
        { :ok, Impl.new_game(word)}
	end
    
    def handle_cast({:new}, state)do
        { :noreply, Impl.new_game()} 
	end
	
	def handle_cast({:new, word}, state)do
        { :noreply, Impl.new_game(word)} 
	end
    
    def handle_cast({ :crash, reason}, state)do
        { :stop, reason, state} 
	end
    
	def handle_call({:move, guess}, _from, state)do
        { s, a, _optional_ch } = Impl.make_move(state, guess)
        { :reply, Impl.make_move(state, guess), s}
	end
	
	def handle_call({:length}, _from, state)do
        { :reply, Impl.word_length(state), state}
	end
	
	def handle_call({:letters_used}, _from, state) do
        { :reply, Impl.letters_used_so_far(state), state}
	end
	
	def handle_call({:turns}, _from, state) do
        { :reply, Impl.turns_left(state), state}
	end
	
	def handle_call({:word_string, reveal}, _from, state) do
        { :reply, Impl.word_as_string(state, reveal), state}
	end
    
    
    
end