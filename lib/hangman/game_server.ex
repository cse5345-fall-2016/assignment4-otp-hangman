defmodule Hangman.GameServer do
  use GenServer

##################
#       API      #
##################

def start_link(word \\ dict.random_word) do
  GenServer.start __MODULE__,word, name: :game_server
end

##################
#       SERVER      #
##################

def init()do
end

end
