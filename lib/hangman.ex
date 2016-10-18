defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...

  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.Dictionary, [])
    ]
    
    opts = [strategy: :rest_for_one, name: Hangman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

