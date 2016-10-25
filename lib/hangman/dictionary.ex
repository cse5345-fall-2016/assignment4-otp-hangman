defmodule Hangman.Dictionary do

  use GenServer

  @me :dictionary

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"

  def start_link(default \\ word_list) do
    GenServer.start_link(__MODULE__, default, name: @me)
  end

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """

  @spec random_word() :: binary
  def random_word do
    GenServer.call(@me, { :random_word })
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(length) do
    GenServer.call(@me, { :words_of_length, length })
  end

  ###############################
  # Begin Server Implementation #
  ###############################

  # GenServer Init
  def init(args), do: { :ok, args }

  def handle_call { :random_word }, _from, list do
    { :reply, list |> random_word, list }
  end

  def handle_call { :words_of_length, length }, _from, list do
    { :reply, list |> words_of_length(length), list }
  end

  ###########################
  # End of public interface #
  ###########################

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end

  defp random_word do
    list
    |> Enum.random
    |> String.trim
  end

  defp words_of_length(len) do
    list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
  end

end
