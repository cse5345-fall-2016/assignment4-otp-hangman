defmodule Hangman do
  use Application
    @moduledoc """
    Here in Hangman (the highest level of supervision) we use the :rest_for_one strategy
    on the children list. This means that if one child fails, the rest of the childeren
    that come after it in the children list die with the failing child. In this case
    this means that HangmanSupervisor will only fail if the Dictionary fails, but the Dictionary
    won't be affected if HangmanSupervisor fails. The dictionary restart is set to permanent,
    which means it will restart no matter what, but the HangmanSupervisor is set to transient,
    meaning it will only restart on error, but will not restart on normal exit.

    The HangmanSupervisor implements a one_for_one strategy on its children list, because
    it only has one child in the list (so it doesn't really matter which strategy is chosen
    but we choose one_for_one by convention). The GameServer is given a transient restart
    because we only want it to restart on an actual error.

    That's it!

    """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    # The order matters! Make sure ot put dictionary first because HangmanSupervisor
    # needs dictionary to exist before it starts!
    children = [
      worker(Hangman.Dictionary, [], restart: :permanent),
      supervisor(Hangman.HangmanSupervisor, [], restart: :transient)
    ]
    # need :rest_for_one at this level, because if Dictionary fails, we need to
    # restart HangmanSupervisor > GameServer > Game along with the Dictionary;
    # However, if just the HangmanSupervisor we don't need to restart the Dictionary
    # This is why HangmanSupervisor has no restart strategy, because we don't want
    # it restarting to effect the Dictionary
    opts = [strategy: :rest_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
