require Integer

defmodule AdventOfCode.DayThree do
  defmodule PartOne do
    def solve(input), do: _solve(String.split(input, "", trim: true), {1,1}, [{1,1}])

    defp _solve([], _, _), do: 1
    defp _solve([head|tail], position, visited) do 
      position = get_new_position(head, position)
      case Enum.member?(visited, position) do
        true  -> _solve(tail, position, visited)
        false -> 1 + _solve(tail, position, [position | visited])
      end
    end

    defp get_new_position("^", {x,y}), do: {x, y+1}
    defp get_new_position(">", {x,y}), do: {x+1, y}
    defp get_new_position("v", {x,y}), do: {x, y-1}
    defp get_new_position("<", {x,y}), do: {x-1, y}
  end

  defmodule PartTwo do
    def solve(input) do
      {santa, robot} = String.split(input, "", trim: true) 
                       |> Enum.with_index 
                       |> Enum.partition(fn({_, i}) -> Integer.is_even(i) end)
      santa = Enum.map(santa, fn({ch,_}) -> ch end)
      robot = Enum.map(robot, fn({ch,_}) -> ch end)
      {santa_count, santa_visited} = _solve(santa)
      {total_count, _} = _solve(robot, {1,1}, {santa_count, santa_visited})
      total_count
    end

    defp _solve(input, position \\ {1,1}, results \\ {1, [{1,1}]})
    defp _solve([], _, results), do: results
    defp _solve([head|tail], position, {total, visited}) do 
      position = get_new_position(head, position)
      case Enum.member?(visited, position) do
        true  -> _solve(tail, position, {total, visited})
        false -> _solve(tail, position, {total+1, [position | visited]})
      end
    end

    defp get_new_position("^", {x,y}), do: {x, y+1}
    defp get_new_position(">", {x,y}), do: {x+1, y}
    defp get_new_position("v", {x,y}), do: {x, y-1}
    defp get_new_position("<", {x,y}), do: {x-1, y}
  end
end