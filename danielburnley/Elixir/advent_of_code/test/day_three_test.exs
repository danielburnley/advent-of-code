defmodule DayThreeTest do
  defmodule PartOne do
    use ExUnit.Case

    defp assert_house(input, expected) do
      assert AdventOfCode.DayThree.PartOne.solve(input) == expected
    end

    test "it should return 1 given no input" do
      assert_house("", 1)
    end

    test "it should return 2 given an input of >" do
      assert_house(">", 2)
    end

    test "it should return 2 given an input of ^" do
      assert_house("^", 2) 
    end

    test "it should return 2 given an input of <" do
      assert_house("<", 2)
    end

    test "it should return 2 given an input of v" do
      assert_house("v", 2)
    end

    test "it should return 3 given an input of >>" do
      assert_house(">>", 3)
    end

    test "it should return 2 given ><" do
      assert_house("><", 2)
    end

    test "it should return 4 given ^>v<" do
      assert_house("^>v<", 4)
    end
  end

  defmodule PartTwo do
    use ExUnit.Case

    defp assert_house(input, expected) do
      assert AdventOfCode.DayThree.PartTwo.solve(input) == expected
    end

    test "it should return 1 given no input" do
      assert_house("", 1)
    end

    test "it should return 2 given an input of >" do
      assert_house(">", 2)
    end

    test "it should return 2 given an input of ^" do
      assert_house("^", 2) 
    end

    test "it should return 2 given an input of <" do
      assert_house("<", 2)
    end

    test "it should return 2 given an input of v" do
      assert_house("v", 2)
    end

    test "it should return 3 given an input of v^" do
      assert_house("v^", 3)
    end

    test "it should return 11 given an input of ^v^v^v^v^v" do
      assert_house("^v^v^v^v^v", 11)
    end
  end
end