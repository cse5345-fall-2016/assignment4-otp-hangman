defmodule Hangman.Dictionary do
  use GenServer

  @me :dictionary

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"

  @doc """
  Start the GenServer and initialize with default word list
  """
  def start_link(words \\ word_list) do
    GenServer.start_link(__MODULE__, words, name: @me)
  end
  
  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """
  @spec random_word() :: binary
  def random_word do
    GenServer.call(@me, :random_word)
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(@me, { :words_of_length, len })
  end


  #######################
  # Server Implemention #
  #######################

  @doc """
  GenServer.init/1 callback
  """
  def init(words), do: { :ok, words }

  @doc """
  GenServer.handle_call/3 callback
  """
  def handle_call(:random_word, _from, words) do
    { :reply, words |> random_word, words }
  end
  def handle_call({ :words_of_length, len }, _from, words) do
    { :reply, words |> words_of_length(len), words }
  end


  ###########################
  # End of public interface #
  ###########################

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
    |> Enum.to_list
  end

  defp random_word(words) do
    words
    |> Enum.random
    |> String.trim
  end

  defp words_of_length(words, len) do
    words
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
  end

end
