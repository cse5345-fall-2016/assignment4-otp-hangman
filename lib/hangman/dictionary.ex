defmodule Hangman.Dictionary do

  use GenServer
  @dict  :dictionary
  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.

  """

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @dict)
  end

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """
  # @word_list_file_name "assets/words.8800"
  # @spec random_word() :: binary
  def random_word do
    GenServer.call @dict, :random_word
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """

  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call @dict, {:words_of_length, len}
  end

  def handle_call({:random_word}, _from, _) do
    wd = word_list
    |> Enum.random
    |> String.trim
    { :reply, wd, []}
  end

  def handle_call({:words_of_length, len}, _from, words) do
    { :reply, words |> words_of_length(len), words }
  end


  defp words_of_length(words, len) do
    words
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
  end

  ###########################
  # End of public interface #
  ###########################

  defp word_list do
    # @word_list_file_name
    # |> File.open!
    # |> IO.stream(:line)
  end

end
