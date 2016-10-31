defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...
  The strategy I have used here is :rest_for_one, because when dictionary
  crashes it will restart for both dictionary and game but if Game crashes
  it will only restart the Game and not the dictionary. I have used :permanent
  to restart the dictionary, because it restarts when it crashes or exists.
  :simple_one_for_one is used to dynamically add child for the game.
  I have used :transient so that game only restarts when it crashes
  and not when it terminates normally.

  """

  def start(_type, _args) do

    # Uncomment and complete this:

     import Supervisor.Spec, warn: false

     children = [
       worker(Hangman.Dictionary, [], restart: :permanent),
       supervisor(Hangman.GameSupervisor, [])
     ]

     opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
     Supervisor.start_link(children, opts)
  end

end
