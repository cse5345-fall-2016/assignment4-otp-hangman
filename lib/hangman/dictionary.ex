defmodule Hangman.Dictionary do
  use GenServer

  @me __MODULE__
  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "assets/words.8800"

  def start_link() do
    GenServer.start(__MODULE__, name: @me)
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
    GenServer.call(@me, {:words_of_length, len})
  end


  ###########################
  # End of public interface #
  ###########################

  defp word_list do
    GenServer.cast(@me, {:word_list})
  end

  #########################
  # Server Implementation #
  #########################

  def init() do
    { :ok }
  end

  def handle_call({:random_word}, _from, _state) do
    { :reply, word_list
              |> Enum.random
              |> String.trim
    }
  end

  def handle_call({:words_of_length, len}, _from, _state) do
    { :reply, word_list
              |> Stream.map(&String.trim/1)
              |> Enum.filter(&(String.length(&1) == len))
    }
  end

  def handle_cast({:word_list}, _state) do
    { :noreply, @word_list_file_name
                |> File.open!
                |> IO.stream(:line)
    }
  end

end
