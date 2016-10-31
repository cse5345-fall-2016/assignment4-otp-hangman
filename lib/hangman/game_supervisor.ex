defmodule Hangman.GameSupervisor do
  use Application

  #####
  # Developer note: I sometimes get a warning for undefined behavior in this function,
  # but I don't know why. It erred when I tried to name it "start"
  # like in hangman.ex. Comments with explanation are appreciated.
  #####

  def start_link(default \\ []) do

    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.GameServer, default, restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end

