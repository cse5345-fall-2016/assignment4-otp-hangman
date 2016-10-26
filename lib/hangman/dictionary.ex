defmodule Hangman.Dictionary do
  use GenServer

  @me :dictionary

  #######
  # API #
  #######

  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: @me)
  end

  def set(key, value) do
    GenServer.cast(@me, {:set, key, value})
  end

  def get(key) do
    GenServer.call(@me, {:get, key})
  end

  #########################
  # Server Implementation #
  #########################

  def init(args) do
    {:ok, Enum.into(args, %{})}
  end

  def handle_cast({:set, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, state[key], state}
  end


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

  @spec random_word() :: binary
  def random_word do
    word_list
    |> Enum.random
    |> String.trim
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  def words_of_length(len) do
    word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
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
