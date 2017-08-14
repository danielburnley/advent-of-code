defmodule DaySixTest do
  use ExUnit.Case

  defp test_grid(size), do: for _ <- 1..size, do: (for _ <- 1..size, do: 0)
  defp convert(grid), do: Enum.map(grid, &(Enum.with_index(&1)))

  defp assert_grid(input, grid, expected), do: assert AdventOfCode.DaySix.solve(input, grid) == count_on(expected)
  defp count_on(input), do: List.flatten(input) |> Enum.count(&(is_on(&1)))
  defp is_on({1, _}), do: true
  defp is_on(_), do: false

  test "it should turn on all the lights given the instruction" do
    start_grid = test_grid(5) |> convert()
    expected_grid = (for _ <- 1..5, do: (for _ <- 1..5, do: 1)) |> convert()

    assert_grid("turn on 0,0 through 4,4", start_grid, expected_grid)
  end

  test "it should turn on all the lights in the top row given the instruction" do
    start_grid = test_grid(3) |> convert()
    expected_grid = [[1,1,1],[0,0,0],[0,0,0]] |> convert()

    assert_grid("turn on 0,0 through 2,0", start_grid, expected_grid)
  end

  test "it should turn off all the lights in the top row given the instruction" do
    start_grid = [[1,1,1],[1,1,1],[1,1,1]] |> convert()
    expected_grid = [[0,0,0],[1,1,1],[1,1,1]] |> convert()

    assert_grid("turn off 0,0 through 2,0", start_grid, expected_grid)
  end

  test "it should turn on all of the lights given the instruction"do 
    start_grid = test_grid(3) |> convert()
    expected_grid = [[1,1,1],[1,1,1],[1,1,1]] |> convert()

    assert_grid("turn on 0,0 through 2,2", start_grid, expected_grid)
  end

  test "it should execute multiple instructions correctly" do
    start_grid = test_grid(3) |> convert()
    expected_grid = [[1,1,1],[0,0,0],[1,1,1]] |> convert()
    input = "turn on 0,0 through 2,2\nturn off 0,1 through 2,1"

    assert_grid(input, start_grid, expected_grid)
  end

  test "it should toggle the lights correctly" do
    start_grid = [[1,0,1]] |> convert()
    expected_grid = [[0,1,0]] |> convert()

    assert_grid("toggle 0,0 through 2,0", start_grid, expected_grid)
  end
end