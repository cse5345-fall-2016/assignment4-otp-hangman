defmodule Hangman.Dictionary do
  use GenServer

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @name :dictionary
  @word_list_file_name "assets/words.8800"

  
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: @name)
  end

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """
  @spec random_word() :: binary
  def random_word do
    GenServer.call(@name, { :random_word })
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(@name, { :words_of_length, len })
  end

  def handle_call( { :random_word }, _from, state) do
    { :reply , _random_word, state }
  end

  def handle_call( {:words_of_length, len}, _from, state) do
    { :reply , _words_of_length(len), state }
  end

  ###########################
  # End of public interface #
  ###########################

  defp _random_word() do
    _word_list
    |> Enum.random
    |> String.trim
  end

  defp _words_of_length(len) do
    _word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
  end

  defp _word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end

end
