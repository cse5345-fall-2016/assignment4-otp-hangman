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
  ###########################
  #   API Implementation    #
  ###########################
  def init(args) do
    {:ok, args}
  end

  @spec random_word() :: binary
  def random_word do
    GenServer.call(@name, :getWord) 
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(@name, {:length_of_words, len})
  end
  ###########################
  # Private Functions       #
  ###########################
  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end
  ###########################
  # Server Implementation   #
  ###########################

  def start_link(default\\ []) do
    GenServer.start_link(__MODULE__, default, name: @name)
  end

  def handle_call(:getWord, _from, _state) do
    word= word_list
    |> Enum.random
    |> String.trim
    {:reply, word}
  end

  def handle_call({:length_of_words, len}, _from, _state) do
    words= word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
    {:reply, words}
  end
  
end
