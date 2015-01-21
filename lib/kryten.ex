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

  def add_host(uri) do
    uri
    |> URI.parse
    |> build_robots_path
    |> get_robots
    |> add_to_server
  end

  def allow?(botname, uri) do
    {botname, uri}
    |> parse_uri
    |> get_paths
    |> path_allowed?
  end

  defp build_robots_path(uri), do: { uri.scheme <> "://" <> uri.host <> "/robots.txt", uri }

  defp get_robots({ get_from, uri }), do: { HTTPoison.get(get_from), uri }

  defp add_to_server({ { :ok, %HTTPoison.Response{ status_code: 200, body: body } }, uri }), do: Kryten.Server.accept(uri.host, body)
  defp add_to_server(result), do: IO.puts result

  defp parse_uri({ botname, uri }), do: { botname, URI.parse(uri) }

  defp get_paths({botname,uri}), do: { botname, uri, Kryten.Server.paths(uri.host) }

  defp path_allowed?({ _botname, _uri, err={ :error, _ } }), do: err
  defp path_allowed?({ botname, uri, { :ok, paths } }) do
    botname
    |> paths_for_bot(paths)
    |> Enum.map(fn p -> path_exists?(p, uri.path) end)
    |> Enum.reduce(fn v, acc -> acc && v end)
    |> inverse
  end

  defp inverse(value), do: !value

  defp path_exists?(paths, path), do: Enum.find_value(paths, false, fn p -> p == path || (String.ends_with?(p, "/") && String.starts_with?(path, p)) end)

  defp paths_for_bot(botname, paths), do: _paths_for_bot(botname, paths, [])

  defp _paths_for_bot(_name, [], output), do: Enum.reverse(output)
  defp _paths_for_bot(name, [{ name, paths }|tail], output), do: _paths_for_bot(name, tail, [paths|output])
  defp _paths_for_bot(name, [{ "*", paths }|tail], output), do: _paths_for_bot(name, tail, [paths|output])
  defp _paths_for_bot(name, [{ _, _paths }|tail], output), do: _paths_for_bot(name, tail, output)

end
