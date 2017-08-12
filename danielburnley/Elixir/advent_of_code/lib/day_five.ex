defmodule AdventOfCode.DayFive do
  defmodule PartOne do
    def solve(input) do
      String.split(input, "\n", trim: true)
      |> Enum.filter(&(!has_disallowed_pattern?(&1)))
      |> Enum.filter(&(has_three_vowels?(&1)))
      |> Enum.filter(&(has_double_letters?(&1)))
      |> Enum.count 
    end

    defp has_disallowed_pattern?(input) do
      Regex.match?(~r/(ab|cd|pq|xy)/, input)
    end

    defp has_three_vowels?(input) do
      Regex.match?(~r/(.*[aeiou].*){3,}/, input)
    end

    defp has_double_letters?(input) do
      Regex.match?(~r/(.)\1/, input)
    end
  end

  defmodule PartTwo do
    def solve(input) do
      String.split(input, "\n", trim: true)
      |> Enum.filter(&(has_double_pair?(&1)))
      |> Enum.filter(&(has_pair_separated_by_single_letter?(&1)))
      |> Enum.count
    end

    defp has_double_pair?(input) do
      Regex.match?(~r/(.{2}).*\1/, input)
    end

    defp has_pair_separated_by_single_letter?(input) do
      Regex.match?(~r/(.).\1/, input)
    end
  end
end