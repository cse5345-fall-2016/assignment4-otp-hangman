defmodule Hangman do
  use Application

  @moduledoc """

  In this assignment, we are trying to implement supervisor based on OTP( Open Telecom Platform), for the whole project, we have two supervisors: main supervisor and subsupervisor which is specifically game supervisor.
  Main supervisor: top level supervisor which is responsible for the dictionary server and subsupervisor - game supervisor. In this case, when dictionary server crashes, all the process will be terminately stoped, the dictionary server and the sequence worker(game server) will restart. If the game superivisor crashes, it will also restart. Here, I choose the "rest_for_one" stragety.
  Game supervisor: this supervisor is mainly used for manage the game server which generates the sequence. when game server crashes, game supervisor will restart it and back to work. Because of lots of game server processes, in order to not influence the other processes when one process crashes, here I choose the" one_for_one" stragety.
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(Hangman.Dictionary,[]),
      supervisor(Hangman.GameSupervisor,[])
    ] 
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

