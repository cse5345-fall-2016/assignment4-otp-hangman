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
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """

  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: @me)
  end

  def random_word() do
    GenServer.call(@me, { :random_word })
  end

  def words_of_length(len)  do
    GenServer.call(@me, { :words_of_length, len })
  end

  #######################
  # Server Implemention #
  #######################

  def handle_call({ :random_word }, _from, state) do
    { :reply, p_random_word, state }
  end

  def handle_call({ :words_of_length, len }, _from, state) do
    { :reply, p_words_of_length(len), state }
  end


  ###########################
  # End of public interface #
  ###########################

  defp p_random_word do
    word_list
    |> Enum.random
    |> String.trim
  end

  defp p_words_of_length(len) do
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
