defmodule ParserTest do
  use ExUnit.Case

  test "parsing empty file returns no exclusions" do
    file = ""
    result = Kryten.Parser.parse file
    assert length(result) == 0
  end

  test "parsing disallow all for all bots" do
    file = """
    User-agent: *
    Disallow: /
    """

    result = Kryten.Parser.parse file
    assert result == [{"*", ["/"]}]
  end
end
