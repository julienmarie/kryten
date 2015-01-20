defmodule Kryten.Server do
  use GenServer

  def start_link, do: GenServer.start(__MODULE__, %{}, name: __MODULE__)

  def paths(hostname) do
    GenServer.call(__MODULE__, { :paths, hostname })
    |> reply_paths
  end

  def clear, do: GenServer.cast(__MODULE__, :clear)

  def accept(hostname, robots_txt) do
    robots_txt
    |> Kryten.Parser.parse
    |> save_at(hostname)
  end

  defp save_at(paths, hostname), do: GenServer.cast(__MODULE__, { :save, hostname, paths })

  defp reply_paths(nil), do: { :error, :unknown_host }
  defp reply_paths(paths), do: { :ok, paths }

  def handle_call({ :paths, hostname }, _from, dict), do: { :reply, Dict.get(dict, hostname), dict }

  def handle_cast(:clear, _dict), do: { :noreply, %{} }

  def handle_cast({ :save, hostname, paths }, dict), do: { :noreply, Dict.put(dict, hostname, paths) }

end
