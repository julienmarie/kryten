defmodule ServerTest do
  use ExUnit.Case

  test "unknown host fails" do
    { :error, :unknown_host } = Kryten.Server.paths("http://example.com")
  end

  test "parse file and load paths" do
    Kryten.Server.accept "http://localhost.com", "User-agent: *\nDisallow: /"

    { :ok, [{ "*", ["/"] }] } = Kryten.Server.paths("http://localhost.com")
  end

end
