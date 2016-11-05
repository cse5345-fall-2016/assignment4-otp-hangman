#in place just in case. Inline implementation in dictionary.ex
#supervisor will not supervise this. It will supervise dictionary.ex

defmodule Hangman.Dictserver do
  use GenServer
  alias Hangman.Dictionary, as: Dictionary

    @me __MODULE__

  #API#
  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: @me)
  end
  def random_word do
    GenServer.call(@me, {:random})
  end
  def words_of_length(len) do
    GenServer.call(@me, {:word_length, len})
  end

  def stop do
    GenServer.stop(@me)
  end
  #implementation#
  def init(args) do
    { :ok, Dictionary.random_word }
  end
  def handle_call({:random}, _from, state) do
    {:reply, Dictionary.random_word, state}
  end
  def handle_call({:word_length, len}, _from, state) do
    {:reply, Dictionary.words_of_length(len), state}
  end

end
