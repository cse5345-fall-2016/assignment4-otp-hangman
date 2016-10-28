defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...

  The way I chose to layout my supervision scheme is by having the hangman supervisor 
  look over the dictionary server and the game supervisor. The dictionary server restart 
  strategy I decided to go with is permanent restart. This way the dictionary is 
  always restarted in the event that it crashes or stops. The supervisor strategy I 
  chose is rest_for_one. After discussing strategies with Dr. Thomas, we decided that 
  rest_for_one is an optimal strategy because if a game supervisor goes down, it will not
  take the dictionary down with it. Rest_for_one only kills and restarts the children
  that have started after the process that has crashed or died. Under my game supervisor
  I have the game server, and under that I have the actual games themselves. My strategy
  for restarting children of the game server is transient. I thought this would be best
  so that games wouldnt be continually restarting if they exit for a normal reason. If
  a player finishes a game or quits the process will not be restarted. For my game 
  supervisor strategy I went with one for one. I had discussed simple one for one, 
  but came to the conclusion that it would be too deep to try and implement this
  strategy for now even though it is superior for real world implementation. Out of
  the box tools are a better option when it comes to this implementation. One for one
  is these context allow a game server to restart without effecting other servers that
  are currently operating. This means gamers will not be interrupted should one server 
  of the bunch fall out of line.

  (As a side note: we had discussed using a call for the crash function. When I implemented
  the callback in this way there were several errors that resulted from the test. When I 
  used a cast the errors disappeared. I am curious why that is if you can think of a better
  reason. Thanks!)

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

