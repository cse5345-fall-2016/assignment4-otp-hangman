defmodule Hangman do
  use Application

  @moduledoc """

  There are two supervisor.
  1. One supervisor for Dictionary is the root supervisor, its child server is
  Dictionary Server. We need to use the ":one_for_all" strategy here because
  once the Dictionary Server is down, all processes will be terminate. The
  restart strategy is ":permanent". This strategy will always restart the child
  process.
  2. Another supervisor for Game Server is stored in the "supevisor.ex" file.
  This supervisor is a sub-supervisor of the root supervisor.
  Its child server(worker) is Game Server. We need to use the ":one_for_one"
  strategy because if one Game Server is down, we don't want to terminate other
  Game Server. The restart strategy is ":transient". This strategy will restart
  the child process only if it terminates abnormally. This means the child
  process will not restart with some normal exit reason, such as, ":normal",
  ":shutdown".
  """

  def start(_type, _args) do

    # Uncomment and complete this:

    # import Supervisor.Spec, warn: false
    #
    # children = [
    # ]
    #
    # opts = [strategy: :you_choose_a_strategy, name: Hangman.Supervisor]
    # Supervisor.start_link(children, opts)
    import Supervisor.Spec, warn: false

    children = [
      worker(Hangman.Dictionary, [], restart: :permanent),
      supervisor(Hangman.GameSupervisor, [])
    ]

    opts = [strategy: :one_for_all, name: Hangman.GameSupervisor]
    Supervisor.start_link(children, opts)

  end
end
