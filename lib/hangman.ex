defmodule Hangman do
    use Application

    # For my supervisor scheme I used two supervisors, one as the main
    # supervisor and one for the game. The main supervisor has the all for one
    # strategy so that whenever the dictionary crashes, all of the games
    # (children) crash as well, and with the permanent restart option they all
    # restart. The game server has the one for one strategy so that as per the
    # instructions, if the game crashes it will restart itself ONLY, and I used
    # the transient restart option so that it would only restart when it crashes
    # or errors out and not if it just exits.

    def start(_type, _args) do

        import Supervisor.Spec, warn: false

        # Define workers and child supervisors to be supervised
        children = [
            worker(Hangman.Dictionary, [], restart: :permanent),
            supervisor(Hangman.GameSuper, [])
        ]

        opts = [strategy: :all_for_one, name: Hangman.Supervisor]
        Supervisor.start_link(children, opts)

    end
end
