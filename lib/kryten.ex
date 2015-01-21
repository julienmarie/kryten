defmodule Kryten do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Kryten.Server, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kryten.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def allow?(botname, uri) do
    {botname, uri}
    |> parse_uri
    |> get_paths
    |> path_allowed?
  end

  defp parse_uri({ botname, uri }), do: { botname, URI.parse(uri) }

  defp get_paths({botname,uri}), do: { botname, uri, Kryten.Server.paths(uri.host) }

  defp path_allowed?({ _botname, _uri, err={ :error, _ } }), do: err
  defp path_allowed?({ botname, uri, { :ok, paths } }) do
    botname
    |> paths_for_bot(paths)
    |> Enum.map(fn p -> path_exists?(p, uri.path) end)
    |> Enum.reduce(fn v, acc -> acc && v end)
  end

  defp path_exists?(paths, path), do: Enum.find(paths, false, fn p -> p != path end)

  defp paths_for_bot(botname, paths), do: _paths_for_bot(botname, paths, [])

  defp _paths_for_bot(_name, [], output), do: Enum.reverse(output)
  defp _paths_for_bot(name, [{ name, paths }|tail], output), do: _paths_for_bot(name, tail, [paths|output])
  defp _paths_for_bot(name, [{ "*", paths }|tail], output), do: _paths_for_bot(name, tail, [paths|output])
  defp _paths_for_bot(name, [{ _, _paths }|tail], output), do: _paths_for_bot(name, tail, output)

end
