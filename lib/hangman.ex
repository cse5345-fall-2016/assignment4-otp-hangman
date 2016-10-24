defmodule Hangman do
  use Application
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, args) do
    import Supervisor.Spec, warn: false

    # The main supervisor monitors the dictionary and the GameSupervisor.
    #I choee a rest_for_one supervising strategy because we want to kill all Games running  
    # if the Dictionary server crashes and both servers to restart, but if the game crashes.
    # we don't want to kill the Dictionary server. rest_for_one is good for this, since we start
    # the  Dictionary Server first, which means that all the processes started after it will die if
    #it crashes and won't die if any of the processes after it crash. I chose a transient restart
    #restart strategy for both processes because we only wnat the processes to restart if they die
    # abnormally. Since the GameServer Superivsor is only monitoring one Server, I chose a one_for_one
    # supervision strategy. I chose a transient restart because we only wnat the game to restart if it dies
    # abnormally. 
    children = [
      worker(Hangman.Dictionary, args, restart: :transient),
      worker(Hangman.GameSupervisor, args, restart: :transient)
      # Starts a worker by calling: HangmanOtp.Worker.start_link(arg1, arg2, arg3)
      # worker(HangmanOtp.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
