defmodule Hangman.Dictionary do
  use GenServer

  @me __MODULE__ 

  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: @me)
  end

  @doc """
  Return a random word from our word list. Whitespace and newlines
  will have been removed.
  """
  def random_word() do
    GenServer.call(@me, :random)
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  def words_of_length(len) do
    GenServer.call(@me, {:length, len})
  end

  #########################
  # Server Implementation #
  #########################
  @word_list_file_name "assets/words.8800"

  def init(args) do
    {:ok, args }
  end

  def handle_call(:random, _from, []) do
   word = word_list
    |> Enum.random
    |> String.trim
    {:reply, word, []}
  end

  def handle_call({:length, len}, _from, []) do
    word = word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
    {:reply, word, []}
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
