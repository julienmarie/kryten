defmodule Kryten.Store do
  use GenServer

  def start_link(starting_value), do: GenServer.start_link(__MODULE__, starting_value, name: __MODULE__)

  def save(value), do: GenServer.cast(__MODULE__, { :save, value })

  def load, do: GenServer.call(__MODULE__, { :load })

  def handle_cast({ :save, value }, _current), do: { :noreply, value }

  def handle_call({ :load }, _from, value), do: { :reply, value, value }

end
