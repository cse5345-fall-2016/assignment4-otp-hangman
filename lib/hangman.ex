defmodule Hangman do
  use Application

  @moduledoc """

  Write your description of your supervision scheme here...

  Answer:
  We use two levels of supervisor - Root Supervisor  is at the top or
  parent consisting of Game Supervisor and Dictionary Supervisor as
  Child processes. The Game Supervisor is the second level consisting
  of Game server as Child.

  On any failure, Root Supervisor utlilize rest for one and permanent restart
  as strategy to optimize any downtime. For the children GameSupervisor -
  It utilize one for one and transient restart for continous production
  environment of multi-user. Transient would be better option for
  safe closing the running process, if the the client is not in session.
  One for one is better option if the access to given functionality is
  end-user for concurrent functioning of other processes in disconnecting client.
  """

  def start(_type, _args) do

    import Supervisor.Spec, warn: false

      children = [
        worker(Hangman.Dictionary, [], restart: :permanent),
        worker(Hangman.GameSupervisor, [])
      ]

      opts = [strategy: :rest_for_one,
              name: Hangman.Supervisor]

      Supervisor.start_link(children, opts)
  end
end
