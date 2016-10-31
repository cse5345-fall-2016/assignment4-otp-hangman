defmodule Hangman.GameSupervisor do
  use Application

  @name :"Hangman.GameServer"

  #####
  # Developer note: I get a warning for undefined behavior in this function,
  # but I don't know why. It erred when I tried to name it "start"
  # like in hangman.ex. Comments with explanation are appreciated.
  #####

  def start_link(args \\ []) do

    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.GameServer, args, restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: @name]
    Supervisor.start_link(children, opts)
  end
end

