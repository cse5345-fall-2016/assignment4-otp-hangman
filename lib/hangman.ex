defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...
  mix new --sub

  This is if you want to use your own project
  need to do change in mix.exs and hangman.ex

  temp directory
  mix new --sup hangman

  Supervisor scheme:
  
  The top level supervisor monitors the game's Dictionary and SubSupervisor
  A rest_for_one strategy for the the main supervisor is used because it will
  restart both the dictionary and Game when the dictionary crashes. However, the
  Game will not have any effect on the dictionary.

  The SubSupervisor is using a :one_for_one strategy so if the game crashes,
  it should not affect other games. Also it is monitoring only one child.

  Dictionary is using a :permanent restart so any exits will trigger a restart.
  Subsupervisor is using a transient restart because the process should restart
  if the game crashes.


  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, [], restart: :permanent),
      worker(Hangman.SubSupervisor, [], restart: :transient)
    ]

    opts = [strategy: :rest_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
