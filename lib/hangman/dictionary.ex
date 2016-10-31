defmodule Hangman.Dictionary do
  use GenServer
  @me __MODULE__

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"
  def start_link(default \\ []) do
  	GenServer.start_link(@me, default, name: @me)
  end

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """

  @spec random_word() :: binary
  def random_word do
  	GenServer.call(@me, {:random_word})
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
  	GenServer.call(@me, {:words_of_length, len})
  end
  
  #########################
  # Server Implementation #
  #########################
  
  def init(_) do
  	{:ok, random_word}
  end
  
  def handle_call({:random_word}, _from, words_list) do
  	{:reply, 
  	word_list
    |> Enum.random
    |> String.trim, 
    words_list}
  end
  
  def handle_call({:words_of_length, len}, _from, words_list) do
  	{:reply, 
  	word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len)), 
    words_list}
  end
  
  ###########################
  # End of Public Interface #
  ###########################

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end
end