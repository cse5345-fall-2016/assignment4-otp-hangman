defmodule Hangman.Dictionary do
  use GenServer

  ##############
  # INLINE API #
  ##############

  def start_link(word \\ random_word) do
    GenServer.start_link(__MODULE__, word, name: :dictionary)
  end

  def get_word() do
    GenServer.call(:dictionary, {:get_random})
  end

  def get_list(word_size) do
    GenServer.call(:dictionary, {:get_list, word_size})
  end

  def get_current_word() do
    GenServer.call(:dictionary, {:get_current})
  end

  ##################
  # Implementation #
  ##################

  # I included this override to the init function for clarity only.
  # The default init function works fine and this could be omitted.
  # def init(word) do
  #   {:ok, word}
  # end

  def handle_call({:get_random}, _from, _state) do
    new_word = random_word
    {:reply, new_word, new_word}
  end

  def handle_call({:get_list, word_size}, _from, state) do
    {:reply, words_of_length(word_size), state}
  end

  def handle_call({:get_current}, _from, state) do
    {:reply, state, state}
  end

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"
  #@word_list_file_name "../../assets/words.8800"
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
