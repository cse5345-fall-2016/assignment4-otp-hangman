defmodule Hangman.Dictionary do
  # NEED TO START GENSERVER in dictionary
  use GenServer

  @doc """
  Start the server and provide location for server callbacks.
  """

  def start_link() do
    GenServer.call(__MODULE__, word_list, name: __MODULE__)
  end

  @doc """
  Handle incoming requests for random_word.
  """

  def handle_call(:random_word, _from, word_list) do
    word = word_list
    |> Enum.random
    |> String.trim
    { :reply, word, word_list }
  end

  @doc """
  Handle incoming requests for words_of_length.
  """

  def handle_call({:words_of_length, len}, _from, word_list) do
    wordlist = word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
    {:reply, wordlist, word_list}
  end

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed. Allows random_word request to be sent to process.
  """

  @spec random_word() :: binary
  def random_word do
    GenServer.call(__MODULE__, :random_word)
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed. Allows words_of_length
  to be sent to process.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(__MODULE__, {:words_of_length, len})
  end


  ###########################
  # End of public interface #
  ###########################

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end

end
