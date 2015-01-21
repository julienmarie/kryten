defmodule KrytenTest do
  use ExUnit.Case

  test "unknown host error propogates" do
    Kryten.Server.clear

    { :error, :unknown_host } = Kryten.allow? "Spidey", "http://example.com/thing"
  end

  test "allowed path to file all rule" do
    Kryten.Server.clear
    Kryten.Server.accept("localhost.com", "User-agent: *\nDisallow: /auth.json")

    assert Kryten.allow? "Spidey", "http://localhost.com/allowed.html"
  end

  test "not allow path to file all rule" do
    Kryten.Server.clear
    Kryten.Server.accept("localhost.com", "User-agent: *\nDisallow: /auth.json")

    false = Kryten.allow? "Spidey", "http://localhost.com/auth.json"
  end

end
