defmodule DayOneTest do
  defmodule PartOne do
    use ExUnit.Case

    def assert_result(input, expected) do
      assert AdventOfCode.DayOne.PartOne.solve(input) == expected
    end

    defmodule Acceptance do
      use ExUnit.Case

      test "given examples correctly calculate ending floor" do
        DayOneTest.PartOne.assert_result("(())", 0)
        DayOneTest.PartOne.assert_result("(((", 3)
        DayOneTest.PartOne.assert_result("))(((((", 3)
        DayOneTest.PartOne.assert_result("))(", -1)
        DayOneTest.PartOne.assert_result(")())())", -3)
      end
    end

    defmodule Unit do
      use ExUnit.Case
      
      test "given empty input return 0" do
        DayOneTest.PartOne.assert_result("", 0)
      end

      test "given input with one left bracket return 1" do
        DayOneTest.PartOne.assert_result("(", 1)
      end

      test "given input with one right bracket return -1" do
        DayOneTest.PartOne.assert_result(")", -1)
      end

      test "given () return 0" do
        DayOneTest.PartOne.assert_result("()", 0)
      end

      test "given (( return 2" do
        DayOneTest.PartOne.assert_result("((", 2)
      end
    end
  end

  defmodule PartTwo do
    use ExUnit.Case

    def assert_result(input, expected) do
      assert AdventOfCode.DayOne.PartTwo.solve(input) == expected
    end 

    defmodule Acceptance do
      use ExUnit.Case

      test "given examples correctly calculate position of basement entry" do
        DayOneTest.PartTwo.assert_result(")", 1)
        DayOneTest.PartTwo.assert_result("()())", 5)
      end
    end
  end
end