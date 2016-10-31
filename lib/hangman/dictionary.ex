defmodule Hangman.Dictionary do
  use GenServer
  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """
  @me :dictionary
  @word_list_file_name "assets/words.8800"

  #######
  # API #
  #######

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """
  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: @me)
  end

  @spec random_word() :: binary
  def random_word do
    GenServer.call(@me,:random_word)
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    GenServer.call(@me,{:words_of_length, len})
  end

  def crash(reason) do
    GenServer.cast(@me, {:crash, reason})
  end

    #######################
    # Server Implemention #
    #######################

  def init(args) do
    {:ok, args}
  end

  def handle_cast({:crash, reason}, state) do
    {:stop, reason, state}
  end

  def handle_call(:random_word, _from, state) do
      random = word_list
      |> Enum.random
      |> String.trim
      {:reply, random, state}
  end

  def handle_call({:words_of_length,len}, _from, state) do
    length = word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
    {:reply, length, state}
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
