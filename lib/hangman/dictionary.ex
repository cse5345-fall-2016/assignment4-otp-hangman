defmodule Hangman.Dictionary do
    use GenServer


    ###################
    # External API

#    def start_link(default) do
#       IO.puts("start link")
#      GenServer.start_link(__MODULE__, default, name: :dictionary)
#    end

#    def random_word do
#      IO.puts "random words "
#      GenServer.call :dictionary, :random_word
#    end
#
#    def words_of_length(integer) do
#       GenServer.call :dictionary, {:words_of_length, integer}
#    end

    ###################
    # GenServer implementation

    def handle_call(:random_word, _from, default) do
        { :reply, random_word, default }
    end

    def handle_call({:words_of_length, integer}, _from, default) do
        { :reply, words_of_length(integer), default }
    end

  @moduledoc """
  We act as an interface to a wordlist (whose name is hardwired in the
  module attribute `@word_list_file_name`). The list is formatted as
  one word per line.
  """

  @word_list_file_name "/Users/stekula/smu/assignment4-otp-hangman/assets/words.8800"

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
