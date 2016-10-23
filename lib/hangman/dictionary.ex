defmodule Hangman.Dictionary do
  use GenServer

  @servername :dictionary
  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"

  def start_link(default \\ []) do
    GenServer.start(__MODULE__, default, name: @servername)
  end

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """

  @spec random_word() :: binary
  def random_word do
    GenServer.call(@servername, {:random_word})
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(@servername, {:words_of_length, len})
  end


  ###########################
  # End of public interface #
  ###########################
  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end

  #########################
  # Server Implementation #
  #########################

  def init(args) do
    { :ok, args }
  end

  def handle_call({:random_word}, _from, state) do
    { :reply,
      word_list
              |> Enum.random
              |> String.trim,
      state
    }
  end

  def handle_call({:words_of_length, len}, _from, state) do
    { :reply,
      word_list
              |> Stream.map(&String.trim/1)
              |> Enum.filter(&(String.length(&1) == len)),
      state
    }
  end

end
