defmodule DaySixTest do
  use ExUnit.Case

  defp test_grid(size), do: for _ <- 1..size, do: (for _ <- 1..size, do: 0)

  defp assert_grid(input, grid, expected), do: assert AdventOfCode.DaySix.solve(input, grid) == count_on(expected)
  defp count_on(input), do: List.flatten(input) |> Enum.count(&(&1 == 1))

  test "it should turn on all the lights given the instruction" do
    start_grid = test_grid(5)
    expected_grid = for _ <- 1..5, do: (for _ <- 1..5, do: 1)

    assert_grid("turn on 0,0 through 4,4", start_grid, expected_grid)
  end

  test "it should turn on all the lights in the top row given the instruction" do
    start_grid = test_grid(3)
    expected_grid = [[1,1,1],[0,0,0],[0,0,0]]

    assert_grid("turn on 0,0 through 2,0", start_grid, expected_grid)
  end

  test "it should turn off all the lights in the top row given the instruction" do
    start_grid = [[1,1,1],[1,1,1],[1,1,1]]
    expected_grid = [[0,0,0],[1,1,1],[1,1,1]]

    assert_grid("turn off 0,0 through 2,0", start_grid, expected_grid)
  end

  test "it should turn on all of the lights given the instruction"do 
    start_grid = test_grid(3)
    expected_grid = [[1,1,1],[1,1,1],[1,1,1]]

    assert_grid("turn on 0,0 through 2,2", start_grid, expected_grid)
  end

  test "it should execute multiple instructions correctly" do
    start_grid = test_grid(3)
    expected_grid = [[1,1,1],[0,0,0],[1,1,1]]
    input = "turn on 0,0 through 2,2\nturn off 0,1 through 2,1"

    assert_grid(input, start_grid, expected_grid)
  end

  test "it should toggle the lights correctly" do
    start_grid = [[1,0,1]]
    expected_grid = [[0,1,0]]

    assert_grid("toggle 0,0 through 2,0", start_grid, expected_grid)
  end
end