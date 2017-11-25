defmodule AdventOfCode.DaySeven do
  defmodule Cache do
    def start, do: Task.start_link(fn -> loop(%{}) end)

    def loop(cache) do
      receive do
        {:put, wire, value, caller} ->
          cache = Map.put(cache, wire, value)
          send caller, :ok
          loop(cache)
        {:in, wire, caller} ->
          case Map.has_key?(cache, wire) do
            true ->
              send caller, {true, cache[wire]}
            false ->
              send caller, {false}
          end
          loop(cache)
      end
    end
  end
  use Bitwise

  def solve(config) do
    {:ok, cache} = AdventOfCode.DaySeven.Cache.start
    Process.register(cache, :cache)
    compile(config)
    |> execute
  end

  defp compile(instructions, compiled_instructions \\ %{})
  defp compile([], compiled_instructions), do: compiled_instructions
  defp compile([instruction|rest], compiled_instructions) do
    compiled_instruction = parse_instruction(instruction)
    |> Map.merge(compiled_instructions)
    compile(rest, compiled_instruction)
  end

  defp parse_instruction(instruction) do
    [wire_instruction, wire] = String.split(instruction, " -> ", trim: true)
    %{ wire => parse_wire_instruction(String.split(wire_instruction, " ")) }
  end

  defp parse_wire_instruction(["NOT",input]), do: {:not, input}
  defp parse_wire_instruction([one, "AND", two]), do: {:and, one, two}
  defp parse_wire_instruction([one, "OR", two]), do: {:or, one, two}
  defp parse_wire_instruction([value, "LSHIFT", amount]), do: {:lshift, value, String.to_integer(amount)}
  defp parse_wire_instruction([value, "RSHIFT", amount]), do: {:rshift, value, String.to_integer(amount)}
  defp parse_wire_instruction([value]), do: {:set, value}

  defp execute(instructions) do
    Map.keys(instructions)
    |> execute_instructions(instructions)
  end

  defp store_in_cache(wire, value) do
    send :cache, {:put, wire, value, self()}
    receive do
      :ok -> :ok
    end
  end

  defp execute_instructions(wires, instructions, wire_values \\ %{})
  defp execute_instructions([], _, wire_values), do: wire_values
  defp execute_instructions([wire|rest], instructions, wire_values) do
    send :cache, {:in, wire, self()}
    receive do
      {true, value} ->
        wire_values = Map.merge(wire_values, %{wire => value})
        execute_instructions(rest, instructions, wire_values)
      {false} ->
        wire_values = execute_instruction(wire, instructions)
        |> Map.merge(wire_values)
        execute_instructions(rest, instructions, wire_values)
    end
  end

  defp execute_instruction(wire, instructions) do
    send :cache, {:in, wire, self()}
    receive do
      {true, value} ->
        %{wire => value}
      {false} ->
        case instructions[wire] do
          {:set, value} ->
            case Integer.parse(value) do
              :error ->
                wire_value = execute_instruction(value, instructions)[value]
                store_in_cache(wire, wire_value)
                %{wire => wire_value}
              {int_value, _} ->
                store_in_cache(wire, int_value)
                %{wire => int_value}
            end
          {:not, input_wire} ->
            value = execute_instruction(input_wire, instructions)[input_wire]
            store_in_cache(wire, 65535 - value)
            %{wire => 65535 - value}
          {:and, input_one, input_two} ->
            value_one = execute_instruction(input_one, instructions)[input_one]
            value_two = execute_instruction(input_two, instructions)[input_two]
            store_in_cache(wire, value_one &&& value_two)
            %{wire => value_one &&& value_two}
          {:or, input_one, input_two} ->
            value_one = execute_instruction(input_one, instructions)[input_one]
            value_two = execute_instruction(input_two, instructions)[input_two]
            store_in_cache(wire, value_one ||| value_two)
            %{wire => value_one ||| value_two}
          {:lshift, input_wire, amount} ->
            value = execute_instruction(input_wire, instructions)[input_wire]
            store_in_cache(wire, value <<< amount)
            %{wire => value <<< amount}
          {:rshift, input_wire, amount} ->
            value = execute_instruction(input_wire, instructions)[input_wire]
            store_in_cache(wire, value >>> amount)
            %{wire => value >>> amount}
          nil ->
            %{wire => String.to_integer(wire)}
        end
    end
  end

end
