defmodule Hangman.Dictionary do
  use GenServer

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """

  @spec random_word() :: binary
  def random_word do
    GenServer.call(__MODULE__, :random_word)
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(__MODULE__, { :words_of_length, len })
  end

  def start_link() do
    state = word_list |> Enum.to_list
    {:ok,_pid} = GenServer.start_link( __MODULE__, state, name: __MODULE__)
  end 


  ###########################
  # End of public interface #
  ###########################

  def handle_call(:random_word, _from, words_state) do 
    word = words_state
           |> Enum.random
           |> String.trim

    { :reply, word, words_state }
  end

  def handle_call({:words_of_length, len}, _from, words_state) do
    words = words_state
            |> Stream.map(&String.trim/1)
            |> Enum.filter(&(String.length(&1) == len))

    { :reply, words, words_state }
  end

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end

end
