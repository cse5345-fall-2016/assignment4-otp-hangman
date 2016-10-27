defmodule Hangman.GameServer do

  #######################
  #         API         #
  #######################

  import Supervisor.Spec, warn: false
  use GenServer

  def start_link(word \\ GenServer.call(:dictionary,{:get_word}),opts \\ []) do

    #
    children = [
        worker(Hangman.Game, [[word: word]],restart: :permanent),
    ]
    #
    opts = [
        strategy: :rest_for_one,
        name: Hangman.GameServer
    ]
    Supervisor.start_link(children, opts)
  end

  #def make_move(guess) do
  #  GenServer.call(:game,{:make_move,guess})
  #end

  def letters_used_so_far() do
    GenServer.call(:game,{:letters_used})
  end


end
