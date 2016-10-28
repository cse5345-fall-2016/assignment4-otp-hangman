defmodule Hangman.Dictionary do
  @moduledoc false

  @me :dictionary

  use GenServer


  #######################
  #         API         #
  #######################


  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__,opts,name: @me)
  end

  def get_word() do
    GenServer.call(@me,{ :get_word })
  end

  def init(args) do
    { :ok, Enum.into(args, %{}) }
  end

  def handle_call({ :get_word }, _from, state) do
    {:reply, random_word(), state}
  end

  #######################
  #    Implementation   #
  #######################

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

  defp word_list do
    @word_list_file_name
    |> File.open!
    |> IO.stream(:line)
  end
  
end