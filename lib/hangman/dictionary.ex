defmodule Hangman.Dictionary do
  use GenServer

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"

  
  def start_link(words \\ []) do
    GenServer.start(__MODULE__, words, name: :dictionary)
  end

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """

  @spec random_word() :: binary
  def random_word do
    GenServer.call(:dictionary, {:word})
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(:dictionary, {:words_of_length,len})
  end

  def crash(reason) do
    GenServer.cast(:dictionary, {:crash, reason})
  end


  ###########################
  # End of public interface #
  ###########################

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end

  def init(words) do
    {:ok, words}
  end

  def handle_call({:word}, _from, words) do
    {
      :reply,
      word_list |> Enum.random
                |> String.trim,
      words
    }
  end
  def handle_call({:words_of_length,len}, _from, words) do
    {
      :reply,
      word_list |> Stream.map(&String.trim/1)
                |> Enum.filter(&(String.length(&1) == len)),
      words
    }
  end

  def handle_cast({:crash, reason}, state) do
    {:stop,reason,state}
  end
end
