defmodule Hangman do
  use Application
    @moduledoc """

    !!! Write your description of your supervision scheme here...

    """
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    # The order matters! Make sure ot put dictionary first because HangmanSupervisor
    # needs dictionary to exist before it starts!
    children = [
      worker(Hangman.Dictionary, [], restart: :permanent),
      supervisor(Hangman.HangmanSupervisor, [], restart: :transient)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options

    # need :rest_for_one at this level, because if Dictionary fails, we need to
    # restart HangmanSupervisor > GameServer > Game along with the Dictionary;
    # However, if just the HangmanSupervisor we don't need to restart the Dictionary
    # This is why HangmanSupervisor has no restart strategy, because we don't want
    # it restarting to effect the Dictionary
    opts = [strategy: :rest_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end










# defmodule Hangman do
#   use Application
#
#   @moduledoc """
#
#   Write your description of your supervision scheme here...
#
#   """
#
#   def start(_type, _args) do
#
#     # Uncomment and complete this:
#
#     # import Supervisor.Spec, warn: false
#     #
#     # children = [
#     # ]
#     #
#     # opts = [strategy: :you_choose_a_strategy, name: Hangman.Supervisor]
#     # Supervisor.start_link(children, opts)
#   end
# end
#
