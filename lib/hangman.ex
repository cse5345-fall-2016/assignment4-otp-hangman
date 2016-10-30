defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...

# The root level supervisor is main supervisor which monitors the dictionary server and the
# game supervisor. The game server is the child process of the game supervisor, that is to say, the
# game supervisor monitors the game server. 
# I chose the rest_for_one for the supervisor strategy, if the dictionary crashes, then the game
# supervisor will be restarted. And the restart option is permenant.
# The game supervisor strategy is one_for_one. So when the game server crashes, game supervisor 
# will restart it. The restart option is transient.


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

