defmodule Hangman do
  use Application

  @moduledoc """

  At the root of the supervisor tree is a Main supervisor that has two children: 
  a Dictionary server, and a Game supervisor. The Game supervisor has the Game 
  server as its child. The Main supervisor’s strategy is :rest_for_one, so if the 
  Dictionary exits, both Dictionary and Game exit, but the Game exiting doesn’t 
  affect the Dictionary. The restart option is :permanent, because we want the 
  children to be restarted for any exit reason. The Game supervisor’s strategy 
  is :one_for_one (although since there is only one child it doesn’t matter what 
  we pick, but in case more Game servers are added as the supervisor’s children, 
  one game crashing shouldn’t affect the other games). The restart option is 
  :transient, because we only want it to restart if it crashes.

  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.Dictionary, [], restart: :permanent),
      worker(Hangman.GameServer, [], restart: :transient)
    ]
    
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

