defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...

  """

  def start(_type, _args) do

    # Uncomment and complete this:

    import Supervisor.Spec, warn: false
    
    children = [
      worker(Hangman.Dictionary, []), 
      supervisor(Hangman.SubSupervisor, [])
    ]
    
    opts = [
      strategy: :rest_for_one, 
      name: __MODULE__
    ]

    Supervisor.start_link(children, opts)
  end
end

