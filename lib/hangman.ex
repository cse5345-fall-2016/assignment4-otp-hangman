#Explaination about supervision structure


# Strategy Used: I have 2 supervisors. Game Server Supervisor uses Simple one for one so that if a game crashes only it is restarted. We dont want the Dictionary to crash,  when the game crashes, we simply restart it but we want the game to crash when the dictionary crashes, so Dictionary is permanent.
#For Game Server workers transient strategy is used to only restart it in case of an unexpected abonormal exit.


defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...

  """

  def start(_type, _args) do

     import Supervisor.Spec, warn: false
    #
     children = [
       worker(Hangman.Dictionary[], restart: :permanent),
       supervisor(Hangman.GameSupervisor, [])
     ]
    #
     opts = [strategy: :rest_for_one, name: Hangman.Supervisor]

     Supervisor.start_link(children, opts)
  end
end
