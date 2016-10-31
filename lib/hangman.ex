defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...
  mix new --sub

  This is if you want to use your own project
  need to do change in mix.exs and hangman.ex

  temp directory
  mix new --sup hangman

  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Game, []),
      worker(Hangman.Dictionary, [])
    ]

    opts = [strategy: :you_choose_a_strategy, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
