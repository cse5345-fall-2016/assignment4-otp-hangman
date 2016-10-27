defmodule Hangman do
  use Application

  @moduledoc """

  I chose the all_for_one supervison scheme because Dictionary will be the first child to be declared.
  I want for the Game supervisor to be killed if the Dictionary module dies for some reason. If the Games supervisor
  dies, I have no reason to believe the Dictionary module should be forced to restart as well. Given that the Dictionary
  module's state doesn't change, I am assuming that if it is on a safe state when it is started, it will always be.

  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false
    # 
    children = [
        worker(Hangman.Dictionary, [],restart: :permanent),
        worker(Hangman.GameServer, [],restart: :permanent)
    ]
    #
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

