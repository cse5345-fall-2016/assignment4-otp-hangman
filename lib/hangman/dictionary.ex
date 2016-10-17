defmodule Hangman.Dictionary do

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"
  @me __MODULE__

  use GenServer

  ###API
  def start_link(name) do
    GenServer.start_link(__MODULE__, @me, name: name)
  end

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """

  @spec random_word() :: binary
  def random_word do
    GenServer.call(@me, {:random_word})
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(@me, {:words_of_length})
  end


  defp handle_call({:random_word}, _from, _state) do
    { :reply,
      word_list
      |> Enum.random
      |> String.trim
    }
  end

  defp handle_call({:words_of_length}, _from, _state) do
    { :reply,
      word_list
      |> Stream.map(&String.trim/1)
      |> Enum.filter(&(String.length(&1) == len))
    }
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
