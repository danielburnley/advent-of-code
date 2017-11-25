defmodule DaySevenTest do
  defmodule Acceptance do
    use ExUnit.Case

    test "Given example, return correct wire values" do
      config = [
        "123 -> x",
        "456 -> y",
        "x AND y -> d",
        "x OR y -> e",
        "x LSHIFT 2 -> f",
        "y RSHIFT 2 -> g",
        "NOT x -> h",
        "NOT y -> i"
      ]
      wire_values = AdventOfCode.DaySeven.solve(config)
      assert wire_values["d"] == 72
      assert wire_values["e"] == 507
      assert wire_values["f"] == 492
      assert wire_values["g"] == 114
      assert wire_values["h"] == 65412
      assert wire_values["i"] == 65079
      assert wire_values["x"] == 123
      assert wire_values["y"] == 456
    end
  end

  defmodule Unit do
    use ExUnit.Case
    def get_wire_values(config) do
      AdventOfCode.DaySeven.solve(config)
    end

    test "given signal provided to X set value correctly" do
      wire_values = get_wire_values(["123 -> x"])
      assert wire_values["x"] == 123
    end

    test "given signal provided to x and y set values correctly" do
      wire_values = get_wire_values(["234 -> x", "567 -> y"])
      assert wire_values["x"] == 234
      assert wire_values["y"] == 567
    end

    test "given set x to y" do
      wire_values = get_wire_values([
        "123 -> y",
        "y -> x"
      ])
      assert wire_values["x"] == 123
    end

    test "given z is x AND y" do
      wire_values = get_wire_values([
        "123 -> x",
        "456 -> y",
        "x AND y -> z"
      ])
      assert wire_values["z"] == 72
    end

    test "given z is x OR y" do
      wire_values = get_wire_values([
        "123 -> x",
        "456 -> y",
        "x OR y -> z"
      ])
      assert wire_values["z"] == 507
    end

    test "given z is x LSHIFT 2" do
      wire_values = get_wire_values([
        "123 -> x",
        "x LSHIFT 2 -> z"
      ])
      assert wire_values["z"] == 492
    end

    test "given z is x RSHIFT 2" do
      wire_values = get_wire_values([
        "456 -> x",
        "x RSHIFT 2 -> z"
      ])
      assert wire_values["z"] == 114
    end

    test "given x NOT y" do
      wire_values = get_wire_values(["123 -> y", "NOT y -> x"])
      assert wire_values["x"] == 65412
    end

    test "given x NOT 123" do
      wire_values = get_wire_values(["NOT 123 -> x"])
      assert wire_values["x"] == 65412
    end

    test "given chained values" do
      wire_values = get_wire_values([
        "123 -> y",
        "NOT y -> x",
        "NOT x -> z"
      ])
      assert wire_values["x"] == 65412
      assert wire_values["z"] == 123
    end
  end
end
