defmodule AdventOfCode do
  def run do
    input = get_input(2015, 1)
    IO.puts "Day 1.1 - #{AdventOfCode.DayOne.PartOne.solve(input)}"
    IO.puts "Day 1.2 - #{AdventOfCode.DayOne.PartTwo.solve(input)}"
    input = get_input(2015, 2)
    IO.puts "Day 2.1 - #{AdventOfCode.DayTwo.PartOne.solve(input)}"
    IO.puts "Day 2.2 - #{AdventOfCode.DayTwo.PartTwo.solve(input)}"
    input = get_input(2015, 3)
    IO.puts "Day 3.1 - #{AdventOfCode.DayThree.PartOne.solve(input)}"
    IO.puts "Day 3.2 - #{AdventOfCode.DayThree.PartTwo.solve(input)}"
    input = get_input(2015, 4)
    IO.puts "Day 4.1 - #{AdventOfCode.DayFour.solve(input)}"
    IO.puts "Day 4.2 - #{AdventOfCode.DayFour.solve2(input)}"
    input = get_input(2015, 5)
    IO.puts "Day 5.1 - #{AdventOfCode.DayFive.PartOne.solve(input)}"
    IO.puts "Day 5.2 - #{AdventOfCode.DayFive.PartTwo.solve(input)}"
    input = get_input(2015, 6)
    IO.puts "Day 6.1 - #{AdventOfCode.DaySix.PartOne.solve(input)}"
    IO.puts "Day 6.2 - #{AdventOfCode.DaySix.PartTwo.solve(input)}"
  end

  defp get_input(year, day) do
    {:ok, input} = AdventOfCodeHelper.get_input(year, day)
    String.trim(to_string input)
  end
end
