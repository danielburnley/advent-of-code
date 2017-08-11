defmodule AdventOfCode.DayOne do
  defmodule PartOne do
    def solve(input), do: calculate(input)
    defp calculate(")" <> tail), do: -1 + calculate(tail) 
    defp calculate("(" <> tail), do: 1 + calculate(tail)
    defp calculate(""), do: 0
  end

  defmodule PartTwo do
    def solve(input), do: calculate(input, 0, 0)
    defp calculate(_, -1, pos), do: pos
    defp calculate(")" <> tail, floor, pos), do: calculate(tail, floor-1, pos+1) 
    defp calculate("(" <> tail, floor, pos), do: calculate(tail, floor+1, pos+1)
    defp calculate(_, floor, _), do: floor
  end
end