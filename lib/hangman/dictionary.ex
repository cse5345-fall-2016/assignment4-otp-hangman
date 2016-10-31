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
    GenServer.call(@me, { :r_w})
  end
  
  def words_of_length(len) do
    GenServer.call(@me, {:words_of_length, len})
  end
  
  
  ################
  #Implementation#
  ################
  
  def init(args)do 
    { :ok, Enum.into(args, %{})}
  end
  
  
  @word_list_file_name "assets/words.8800"

  
  @spec random_word() :: binary
  def handle_call({ :r_w}, _from, state)do
    {
    :reply,
    (word_list |> Enum.random |> String.trim), 
    state
    }
  end

  
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
