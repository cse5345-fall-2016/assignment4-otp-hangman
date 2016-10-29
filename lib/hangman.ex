defmodule Hangman do
  use Application

  @moduledoc """
                  -------------------
                  | main supervisor |
                  -------------------        (strategy: rest_for_one)    
                      .         . 
                     .            .
                    .               .
                   .                  .
                  .                     .
                 .                        .
     ********************            -------------------         
     | dictonary server |            | game supervisor |
     ********************            -------------------    (strategy: one_for_one) 
                                            .
                                            .
                                            .
                                            .
                                     *******************
                                     |   game server   |   
                                     *******************

    1.Main supervisor is the top-level supervisor. It manages dictonary server and game supervisor.  
      Rest_for_one strategy is used. When game supervisor crashes, it will be restarted. When dictonary 
      server crashes, the dictonary server and game supervisor will be restarted. 
    2.Game supervisor is the sub supervisor. It monitors the game server processe. When gmae sever 
      carshes, it will be restarted by this supervisor. There can be lots of game server process. With this
      strategy, one process crash will not affect other processes.
  """

  def start(_type, _args) do

    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.Dictionary, []),
      worker(Hangman.GameSupervisor, [])
    ]
     
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
