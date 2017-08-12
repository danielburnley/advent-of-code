defmodule DayFiveTest do
  defmodule PartOne do
    use ExUnit.Case

    def assert_count(input, expected), do: assert AdventOfCode.DayFive.PartOne.solve(input) == expected

    test "should return 0 given an empty string" do
      assert_count("", 0)
    end

    test "should return 0 given a string with only three vowels" do
      assert_count("aei", 0)
    end

    test "should return 0 given a string with only double letters" do
      assert_count("aa", 0)
    end

    test "should return 0 given a string with three vowels, double letters, and disallowed string" do
      assert_count("aaeeiiab", 0)
      assert_count("aaeeiicd", 0)
      assert_count("aaeeiipq", 0)
      assert_count("aaeeiixy", 0)
    end

    test "should return true given three vowels, double letters, and no disallowed string" do
      assert_count("aaeeii", 1)
    end

    test "given one naughty and one nice word return 1" do
      assert_count("aaa\nbad", 1)
    end

    test "given three nice words return 3" do
      assert_count("aaa\neee\nuuu", 3)
    end
  end

  defmodule PartTwo do
    use ExUnit.Case

    def assert_count(input, expected), do: assert AdventOfCode.DayFive.PartTwo.solve(input) == expected

    test "should return 0 given an empty string" do
      assert_count("", 0)
    end

    test "should return 0 given a string with only two letter pairs" do
      assert_count("abxxab", 0)
    end

    test "should return 0 given a string with only one repeating letter" do
      assert_count("aba", 0)
    end

    test "should return 1 given a nice string" do
      assert_count("abab", 1)
    end

    test "should return 2 given two nice strings and one naughty string" do
      assert_count("abab\nabab\nabxxab", 2)
    end
  end
end