defmodule DayFourTest do
  use ExUnit.Case

  test "Given abcdef return 609043" do
    assert AdventOfCode.DayFour.solve("abcdef") == 609043
  end

  test "Given pqrstuv return 1048970" do
    assert AdventOfCode.DayFour.solve("pqrstuv") == 1048970
  end
end