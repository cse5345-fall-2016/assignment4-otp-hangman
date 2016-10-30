defmodule Hangman do
  use Application

  @strategy :one_for_all

  @restart :transient

  @moduledoc """

  The top Supervisor has Hangman.Dictionary as its worker and GameServe as
  subsupervisor.
  if the Hangman.Dictionary crashes it is configured to one_for_all strategy
  and transient as restart. If the Dictionary crashes i.e. stops under
  abnormal condition it will restart both worker and subsupervisor.

  The subsupervisor has GameServer as worker it uses one_for_one and transient
  restart. If the GameServer crashes i.e. stops under abnormal condions. It will
  start itself. It does not effect the Top Supervisor.

  """

  def start(_type, _args) do

    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, [], restart: @restart),
      supervisor(GameServer_SubSupervisor, [], restart: @restart)
    ]

    opts = [strategy: @strategy, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
