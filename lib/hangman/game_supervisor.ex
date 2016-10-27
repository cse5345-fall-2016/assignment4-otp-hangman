defmodule Hangman.GameSupervisor do
  @moduledoc false


  def start_link(opts \\ []) do

    import Supervisor.Spec, warn: false
    #
    children = [
        worker(Hangman.GameServer, [],restart: :permanent),
    ]
    #
    opts = [
        strategy: :rest_for_one,
        name: Hangman.GameSupervisor
    ]
    Supervisor.start_link(children, opts)
  end

end