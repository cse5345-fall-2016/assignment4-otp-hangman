defmodule Hangman.Crasher do
  def crash(server, reason) do
    GenServer.cast(server, {:crash, reason})
  end

  def handle_cast({:crash, reason}, state) do
    {:stop, reason, state}
  end
end
