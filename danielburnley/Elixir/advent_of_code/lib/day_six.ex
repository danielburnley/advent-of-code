defmodule AdventOfCode.DaySix do
  def solve(input, grid \\ get_grid()) do
    String.split(input, "\n", trim: true)
    |> _solve(grid)
    |> List.flatten
    |> Enum.count(&(&1 ==1))
  end

  defp _solve([], grid), do: grid
  defp _solve([input|rest], grid) do
    [x_start, x_end] = get_x_range(input)
    [y_start, y_end] = get_y_range(input)
    instruction = get_instruction(input)
    _solve(rest, update_grid(grid, instruction, y_start, y_end, x_start, x_end))
  end

  defp update_grid(grid, instruction, y, y, x_from, x_to) do
    List.replace_at(
      grid, y, update_row(Enum.at(grid, y), instruction, x_from, x_to)
    )
  end

  defp update_grid(grid, instruction, y_from, y_to, x_from, x_to) do
    List.replace_at(
      grid, y_from, update_row(Enum.at(grid, y_from), instruction, x_from, x_to)
    )
    |> update_grid(instruction, y_from+1, y_to, x_from, x_to)
  end

  defp update_row(row, instruction, index, index), do: List.replace_at(row, index, update_light(instruction, Enum.at(row, index)))
  defp update_row(row, instruction, from, to) do
    List.replace_at(row, from, update_light(instruction, Enum.at(row, from)))
    |> update_row(instruction, from+1, to)
  end

  defp get_x_range(input) do
    Regex.scan(~r/(\d+),/, input, capture: :all_but_first) 
    |> List.flatten
    |> Enum.map(&(String.to_integer &1))
  end

  defp get_y_range(input) do 
    Regex.scan(~r/,(\d+)/, input, capture: :all_but_first) 
    |> List.flatten
    |> Enum.map(&(String.to_integer &1))
  end

  defp get_instruction("turn on"<>_),   do: :on
  defp get_instruction("turn off"<>_),  do: :off
  defp get_instruction("toggle"<>_),    do: :toggle

  defp update_light(:on, _), do: 1
  defp update_light(:off, _), do: 0
  defp update_light(:toggle, 1), do: 0
  defp update_light(:toggle, 0), do: 1

  defp get_grid, do: for _ <- 1..1000, do: (for _ <- 1..1000, do: 0)
end