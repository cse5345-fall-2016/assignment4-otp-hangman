defmodule Hangman do
  use Application

  @strategy :rest_for_one

  @restart :permanent


  @moduledoc """

  As an out of the box application, the given Hangman code functions
  well as single player novelty. However, adding Genserver capabilities
  to each module would imply that some level of scalability is
  intentional. To scale this application multiple people would neeed to
  access the GameServer module, meaning multiple game server processes
  would need to be run. To the contrary, one Dictionary process is
  sufficient to give words to all of the processes/games. In order to
  achieve this, I implemented a supervisor for the GameServer module
  which can handle any number of GameServer children. The top level
  strategy for this will be one for rest, because if the dictionary
  (the first module) crashes, it should be restarted along with the
  game supervisor because the game supervisor depends on the dictionary.
  However, if the game supervisor crashes the dicionary process does
  not need to be restarted. Furthermore, on the top level both processes
  should be restated permanently, in order to maintain an operational
  system. Within the game server supervisor, the strategy will be one
  for one, since the game processes are independent. The restart strategy
  will be transient so that only games that crash abnormally are restarted.
  Normal exits may be intentional and should not be restarted.

  """

  def start(_type, _args) do

    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, [], id: :dictionary, restart: @restart),
      supervisor(Hangman.GameServerSup, [])
    ]

    opts = [strategy: @strategy, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
