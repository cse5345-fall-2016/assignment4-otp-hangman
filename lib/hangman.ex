defmodule Hangman do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Hangman.Worker.start_link(arg1, arg2, arg3)
      # worker(Hangman.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hangman.Supervisor]
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
