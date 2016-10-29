defmodule Hangman.Dictionary.Server do
  use GenServer
  @me __MODULE__
  
  
  #######
  # API #
  #######
  
  def start_link() do
        GenServer.start_link(__MODULE__, [], name: @me)
	end
  
  def random_word do
    GenServer.cast(@me, { :random})
  end
  
  def words_of_length(len) do
    GenServer.cast(@me, {:words_of_length, len})
  end
  
  
  ################
  #Implementation#
  ################
  
  def init(args)do 
    { :ok, Enum.into(args, %{})}
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
  def handle_call({:random}, _from, state)do
    { 
    :reply,
    word_list |> Enum.random |> String.trim, 
    state
    }
  end

  @doc """
  Return a list of all the words in our word list of a given length.
  Whitespace and newlines will have been removed.
  """
  @spec words_of_length(integer)  :: [ binary ]
  
  def handle_call({:words_of_length, len}, state) do
    { 
    :reply, 
    word_list |> Stream.map(&String.trim/1) |> Enum.filter(&(String.length(&1) == len)), 
    state
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
