defmodule AdventOfCode.DayFour do
  def solve(input), do: _solve(String.trim(input), 2, get_md5(input, 1))
  def solve2(input), do: _solve2(String.trim(input), 2, get_md5(input, 1))

  defp _solve(_, num, "00000"<>_), do: num - 1
  defp _solve(input, num, _), do: _solve(input, num+1, get_md5(input, num))

  defp _solve2(_, num, "000000"<>_), do: num - 1
  defp _solve2(input, num, _), do: _solve2(input, num+1, get_md5(input, num))

  defp get_md5(input, number), do: :crypto.hash(:md5, input<>Integer.to_string number) |> Base.encode16
end