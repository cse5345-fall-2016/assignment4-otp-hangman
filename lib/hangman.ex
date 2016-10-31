# Using the :rest_for_one will shut down only GameServer if it were to crash but
# would crash both Dictionary and GameServer (as per the instructions) since
#  GameServer is on the right of Dictionary in the list. Again, the instructions
#  asked to restart Dictionary no matter what the crash :reason is so it is given
#  a :restart of permanent. GameServer on the other hand is given a :transient
#  restart option since it should automaticaly restart only if given a "bad"
#  reason for crashing.

defmodule Hangman do
  use Application


  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Hangman.Dictionary, [], restart: :permanent),
      worker(Hangman.GameSupervisor, [], restart: :transient)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
