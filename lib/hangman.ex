defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...
  In my own opinion I think the structure of this supervisor is use two supervisor.
  The first is Root supervisor the task of this one is monitor the Dictionary module
  and the Game.supervisor. So it had child supervisor and the strategy of Root
  supervisor is rest_for_one. Also the Game.supervisor handle the Game Server
  and the strategy is one_for_one.
  """

  def start(_type, _args) do

    # Uncomment and complete this:

     import Supervisor.Spec, warn: false

     children = [
       worker(Hangman.Dictionary, [], id: :dictionary, restart: :permanent),
       supervisor(GameServerSupervisor, [])
     ]

     opts = [strategy: :one_for_all, name: Hangman.Supervisor]
     Supervisor.start_link(children, opts)
  end
end
