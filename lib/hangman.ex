defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...
  
  Here the dictionary server is providing the word for the user to play. Its
  sole job is to provide the word and also it doesn't need to store the word
  it provided as that information is maintained in the game session. Hence the
  dictionary server can work independently.
  The supervisor that monitors the gameserver workers needs to be monitoring
  the game workers as long as the application is running.
  Hence the supervision strategy followed is as follows -
  Dictionary and the Supervisor for game workers would be restared always under
  all circumstances and they are independent to each other.

  The game workers do not share any data between their processes, as each of
  the game worker fetches a word from the dictionary and the remaining game
  progresses with the state that is maintained in the gameserver. A user should
  be able to naturally exit from the game once he is done playing, in all other
  cases it needs to be restarted.

  Below is a pictorial structure of the supervision strategy

                    #######################
                    # Hangman.Supervisor  #
                    #######################
                      |                  |
                      |                  |
      #####################             ################### Supervisor Strategy:
      # Dictionary Server #             # Game Supervisor # :one_for_one
      #####################             ################### Restart Strategy:
                                          |                 :permanent
                                          |
                                          |
                                        ###############  Supervisor Strategy:
                                        # Game Server #   :one_for_one
                                        ###############  Restart Strategy:
                                                          :transient
  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false

    children = [
        worker( Hangman.Dictionary,
                [],
                id: :dictionary,
                restart: :permanent),
        supervisor( Hangman.GameSupervisor,
                    [self],
                    id: :gamesupervisor,
                    restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
