defmodule Hangman do
  use Application

@moduledoc """

                  -------------------
                  | Main Supervisor |
                    (strategy: rest_for_one)
                  -------------------            

                 .                         . 
                 .                         .
                 .                         .
                 .                         .
                 .                         .
                 .                         .
     -------------------            -------------------         
     | Dictonary Server |            | Game Supervisor |
                                      (strategy: one_for_one)
     -------------------            -------------------     
                                            .
                                            .
                                            .
                                            .
                                     -------------------
                                     |   Game Server   |   
                                     -------------------



    1. Main supervisor being the top-level supervisor, manages the dictonary server and game supervisor.  
       Rest_for_one strategy is implemented to help the model to restart all in case of failure.  

    2. Game supervisor monitors the game server processes. To achieve the functionality of restarting the game sever 
      when it carshes, it will be restarted by this supervisor. Keeping in mind that there would be multiple instance of
      game which should be independant and should not impact on another process, one_for_one strategy would be ideal.  
       
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
     
    children = [
      worker(Hangman.Dictionary, [],  restart: :permanent ),
      worker(Hangman.GameSupervisor, [])
    ]
     
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)

  end
end

