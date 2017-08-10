defmodule DayTwoTest do
  defmodule PartOne do
    use ExUnit.Case

    defp assert_paper(input, expected) do
      assert AdventOfCode.DayTwo.PartOne.solve(input) == expected
    end

    test "given one box with sides of all 0, return 0" do
      assert_paper("0x0x0", 0)
    end

    test "given one box with sides of all 1, return 7" do
      assert_paper("1x1x1", 7)
    end

    test "given box with measurements 1x1x2, return 11" do
      assert_paper("1x1x2", 11)
    end

    test "given box with measurements 2x3x4, return 58" do
      assert_paper("2x3x4", 58)
    end

    test "given two boxes with measurements of all 1, return 14" do
      assert_paper("1x1x1\n1x1x1", 14)
    end
  end

  defmodule PartTwo do
    use ExUnit.Case
    
    defp assert_ribbon(input, expected) do
      assert AdventOfCode.DayTwo.PartTwo.solve(input) == expected
    end

    test "given one box with sides of all 0, return 0" do
      assert_ribbon("0x0x0", 0)
    end

    test "given one box with sides of all 1, return 5" do
      assert_ribbon("1x1x1", 5)
    end

    test "given one box with sides of 2x3x4, return 34" do
      assert_ribbon("2x3x4", 34)
    end

    test "given two boxes with mesurements of all 1, return 10" do
      assert_ribbon("1x1x1\n1x1x1", 10)
    end
  end
end