defmodule Hangman.Dictionary do

  use GenServer
  @me :dictionary

  @word_list_file_name "assets/words.8800"
  def start_link do
    GenServer.start_link(__MODULE__,[],name: @me)
  end
  
  @spec random_word() :: binary
  def random_word do
    GenServer.call (@me, {:random_word})
  end
  def words_of_length(len) do
    GenServer.call (@me,{:word_of_length,len})
  end
  def handle_call(:random_word,_from,_) do
    words = word_list
    |> Enum.random
    |> String.trim
    {:reply,words,[]}
  end

  @spec words_of_length(integer)  :: [ binary ]
  def handle_call({words_of_length,len},_from,_) do
    returnwds = word_list
    |> Stream.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) == len))
    {:reply, returnwds,[]}
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
