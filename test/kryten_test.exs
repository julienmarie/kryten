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

  test "allowed path to file specific rule" do
    Kryten.Server.clear
    Kryten.Server.accept("localhost.com", "User-agent: BadBot\nDisallow: /test.html")

    assert Kryten.allow? "BadBot", "http://localhost.com/allowed.html"
  end

  test "not allowed path to file specific rule" do
    Kryten.Server.clear
    Kryten.Server.accept("localhost.com", "User-agent: BadBot\nDisallow: /test.html")

    false = Kryten.allow? "BadBot", "http://localhost.com/test.html"
  end

  test "allowed subpath all rule" do
    Kryten.Server.clear
    Kryten.Server.accept("localhost.com", "User-agent: *\nDisallow: /secret/")

    assert Kryten.allow? "BadBot", "http://localhost.com/public/test.html"
  end

  test "not allowed subpath all rule" do
    Kryten.Server.clear
    Kryten.Server.accept("localhost.com", "User-agent: *\nDisallow: /secret/")

    false = Kryten.allow? "BadBot", "http://localhost.com/secret/password.html"
  end

  test "allowed subpath specific rule" do
    Kryten.Server.clear
    Kryten.Server.accept("localhost.com", "User-agent: BadBot\nDisallow: /secret/")

    false = Kryten.allow? "BadBot", "http://localhost.com/secret/password.html"
  end

  test "not allowed subpath all rule" do
    Kryten.Server.clear
    Kryten.Server.accept("localhost.com", "User-agent: BadBot\nDisallow: /secret/")

    false = Kryten.allow? "BadBot", "http://localhost.com/secret/password.html"
  end


end
