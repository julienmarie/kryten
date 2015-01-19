defmodule ParserTest do
  use ExUnit.Case

  test "parsing empty file returns no exclusions" do
    file = ""
    result = Kryten.Parser.parse file
    assert length(result) == 0
  end
end
