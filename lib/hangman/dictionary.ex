defmodule Hangman.Dictionary do
  use GenServer

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"
  @name :dictionary

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """
  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: @name)
  end

  def random_word do
    GenServer.call(@name, {:random_word})
  end
  def words_of_length len do
    GenServer.call(@name, {:words_of_length, len})
  end


  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]



  ###########################
  # End of public interface #
  ###########################

  def init(default) do
    {:ok, []}
  end

  def handle_call({:words_of_length, len}, _from, state) do
    words = word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
    {:reply, words, state}
  end
  #get random_word
  def handle_call({:random_word}, _from, state) do
    word = word_list
    |> Enum.random
    |> String.trim
    {:reply, word, state}
  end

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end

end
