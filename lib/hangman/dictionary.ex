defmodule Hangman.Dictionary do
  use GenServer

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"

  @serverName :dictionary

  ##########
  #  API   #
  ##########

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @serverName)
  end

  @spec random_word() :: binary
  def random_word do
    GenServer.call(@serverName, :get_word)
  end

  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(@serverName, {:get_word_with_length, len})
  end

  ############################
  #  Server Implementation   #
  ############################

  def handle_call(:get_word, _from, state) do
    {:reply, get_random_word, state}
  end

  def handle_call({:get_word_with_length, len}, _from, state) do
    {:reply, words_with_length(len), state}
  end

  ###########################
  # private meethods        #
  ###########################

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """
  defp get_random_word do
    word_list
    |> Enum.random
    |> String.trim
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  defp words_with_length(len) do
    word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
  end

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end

end
