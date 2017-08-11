defmodule AdventOfCode.DayTwo do
  defmodule PartOne do
    def solve(input) do
      String.trim(input)
      |> String.split("\n")
      |> Enum.reduce(0, &(calculate_box(&1) + &2))
    end

    def calculate_box(measurements) do
      String.split(measurements, "x") 
      |> Enum.map(&(String.to_integer &1)) 
      |> get_products
      |> Enum.sort
      |> calculate
    end

    defp get_products([l,w,h]), do: [l*w,l*h,w*h]
    defp calculate([a,b,c]), do: 2*a + 2*b + 2*c + a
  end

  defmodule PartTwo do
    def solve(input) do
      String.trim(input)
      |> String.split("\n")
      |> Enum.reduce(0, &(calculate_box(&1) + &2))
    end

    defp calculate_box(measurements) do 
      measurements = String.split(measurements, "x")
                     |> Enum.map(&(String.to_integer &1)) 

      smallest_perimeter = calculate_perimeters(measurements)
                           |> Enum.sort
                           |> hd

      volume = calculate_volume(measurements)

      smallest_perimeter + volume
    end

    defp calculate_perimeters([l,w,h]) do 
      [
        calculate_perimeter(l,w), 
        calculate_perimeter(l,h), 
        calculate_perimeter(w,h)
      ]
    end

    defp calculate_perimeter(a,b), do: a + a + b + b
    defp calculate_volume([l,w,h]), do: l*w*h
  end
end