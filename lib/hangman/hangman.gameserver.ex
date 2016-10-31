defmodule Hangman.GameServer do
 	use GenServer
	alias Hangman.Game, as:  HGame 
	alias Hangman.Dictionary, as: HDictionary 

    # Initialization
    def start_link(word \\ HDictionary.random_word) do 
        GenServer.start __MODULE__, word, name: GameServer
    end 

 	# Game Server API Implementation (as defined in Game.ex)
	 def new_game(secret_word \\ HDictionary.random_word) do
 		GenServer.cast :GameServer, { :newGame, secret_word }
 	end

 	def make_move(guess) do
 		GenServer.call(:GameServer, { :make_move, guess })
 	end

 	def word_length do
 		GenServer.call(:GameServer, { :word_length })
 	end

 	def letters_used_so_far do
 		GenServer.call(:GameServer, { :letters_used_so_far })
 	end

 	def turns_left do
 		GenServer.call(:GameServer, { :turns_left })
 	end

 	def word_as_string(reveal \\ false) do
 		GenServer.call(:GameServer, { :word_as_string, reveal })
 	end

 	def crash(exit_code) do
 		GenServer.cast(:GameServer, { :crash, exit_code })
 	end



 	# Server Implementation 
    def init(word) do
    {:ok, HGame.new_game(word)}    
    end
 	
     #def init(state) do
 	#	{:ok, state}     
 	#end

    # GenServer Callbacks
    def handle_cast({ :newGame, secret_word }, _from, state) do 
            {:no_reply, HGame.new_game(secret_word)} 
    end 

 	def handle_call({ :make_move, guess }, _from, state) do 
		# Status here is :won, :lost, :good_guess or :bad_guess 
		# Guess is the third param returned but is not needed 

 		{ new_state, status, _ } = Hangman.Game.make_move(state, guess) 
 		{:reply, status, new_state} 
    end 
 
    def handle_call({ :word_length }, _from, state) do
            {:reply, Hangman.Game.word_length(state), state}
    end

 	def handle_call({ :letters_used_so_far }, _from, state) do
 		{:reply, Hangman.Game.letters_used_so_far(state), state}
    end

 	def handle_call({ :turns_left }, _from, state) do
 		{:reply, Hangman.Game.turns_left(state), state}
    end

 	def handle_call({ :word_as_string, reveal }, _from, state) do
 		{:reply, Hangman.Game.word_as_string(state, reveal), state} 
    end 


    def handle_cast({ :crash, exit_code }, _from, state) do
 		{:stop, exit_code, state}
    end


end