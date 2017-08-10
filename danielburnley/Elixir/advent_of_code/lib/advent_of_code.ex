defmodule AdventOfCode do
  def run do
    :inets.start

    input = AdventOfCode.GetInput.for_day(2015, 1)
    IO.puts "Day 1.1 - #{AdventOfCode.DayOne.PartOne.solve(input)}"
    IO.puts "Day 1.2 - #{AdventOfCode.DayOne.PartTwo.solve(input)}"
    input = AdventOfCode.GetInput.for_day(2015, 2)
    IO.puts "Day 2.1 - #{AdventOfCode.DayTwo.PartOne.solve(input)}"
    IO.puts "Day 2.2 - #{AdventOfCode.DayTwo.PartTwo.solve(input)}"
    input = AdventOfCode.GetInput.for_day(2015, 3)
    IO.puts "Day 3.1 - #{AdventOfCode.DayThree.PartOne.solve(input)}"
    IO.puts "Day 3.2 - #{AdventOfCode.DayThree.PartTwo.solve(input)}"
    input = "ckczppom"
    IO.puts "Day 4.1 - #{AdventOfCode.DayFour.solve(input)}"
    IO.puts "Day 4.2 - #{AdventOfCode.DayFour.solve2(input)}"
  
    :inets.stop
  end
end