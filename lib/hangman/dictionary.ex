defmodule Hangman.Dictionary do

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :dictionary)
  end

  def random_word do
    GenServer.call :dictionary, :random_word
  end

  def words_of_length(len) do
    GenServer.call :dictionary, {:words_of_length, len} 
  end


  @word_list_file_name "assets/words.8800"
  
  def handle_call(:random_word, _from, _) do
    wd = word_list
    |> Enum.random
    |> String.trim
    { :reply, wd, []}
  end

  def handle_call({:words_of_length, len}, _from, _) do
    ct = word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
    { :reply, ct, []}
  end

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end
  

end
