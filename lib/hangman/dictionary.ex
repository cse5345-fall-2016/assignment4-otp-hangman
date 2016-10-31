defmodule Hangman.Dictionary do
use GenServer

# Define global variable  
@word_list_file_name "assets/words.8800"
@me __MODULE__

# Client API
def start_link(list \\ word_list) do 
    GenServer.start_link(@me, list, name: @me) 
end 

def random_word() do
    GenServer.call(@me, { :random_word }) 
end
 
 def words_of_length(length) do
    GenServer.call(@me, { :words_of_length, length }) 
end

# GenServer Callbacks
def handle_call { :random_word }, _from, list do 
    { :reply, list |> Enum.random |> String.trim, list } 
end 

def handle_call { :words_of_length, length }, _from, list do 
    { :reply, 
    word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == length)) ,list    } 
end 
 
 # Main Modules
defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
end

def init(args), do: { :ok, args }
end


  # Individual module testing 
  #  How to run this  #
  #  build -> iex Dictionary.ex
  #  start process ->  {:ok, pid} = Hangman.Dictionary.start_link
  #  Random word -> Hangman.Dictionary.random_word
  #  Rando word length -> Dictionary.words_of_length(3)
  ###########################
