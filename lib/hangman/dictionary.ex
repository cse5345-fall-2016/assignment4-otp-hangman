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
    GenServer.call(@me, { :random })
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(@me, { :length, len })
  end


  ###########################
  # End of public interface #
  ###########################

  def init(_args) do
    { :ok, [] }
  end

  def handle_call({ :length, len }, _from, state) do
    { :reply, get_words_of_length(len), state }
  end

  def handle_call({ :random }, _from, state) do
    { :reply, get_random_word, state }
  end

  defp get_words_of_length(len) do
    word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
  end

  defp get_random_word do
    word_list
    |> Enum.random
    |> String.trim
  end

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end

end
