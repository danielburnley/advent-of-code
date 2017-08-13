-module(day12).
-export([start_a/0, start_b/0]).
-compile(nowarn_unused_function). 
-compile(nowarn_unused_vars).
-include("../helpers/helper.hrl").

registers() -> ["a", "b", "c", "d"].

register_copy(From, To, R) ->  dict:store(To, From, R).
register_increase(To, R) -> register_update(To, 1, R).
register_decrease(To, R) -> register_update(To, -1, R).
register_update(K, V, R) -> dict:store(K, dict:fetch(K, R) + V, R).

process_instruction([], R) -> {R, 0};
process_instruction(I, R) ->
	Tokens = string:tokens(I, " "),
	case lists:nth(1,Tokens) of
		"cpy" ->
			Second = lists:nth(2, Tokens),
			Third = lists:nth(3, Tokens),
			case lists:member(Second,registers()) of
				true -> {register_copy(dict:fetch(Second, R), Third, R), 1};
				false -> {register_copy(s2i(Second), Third, R), 1}
			end;
		"inc" -> {register_increase(lists:nth(2, Tokens), R), 1};
		"dec" -> {register_decrease(lists:nth(2, Tokens), R), 1};
		"jnz" ->
			RegVal = safe_fetch(lists:nth(2, Tokens), no_value, R),
			case RegVal of 
				0 -> {R, 1};
				_ -> {R, s2i(lists:nth(3, Tokens))}	
			end;				
		_ -> {R, 9999999}
	end.

process_instructions(Instr, R, I) when length(Instr) < I -> R;
process_instructions(Instr, R, I) ->
	NthInstr = lists:nth(I, Instr),
	{NewR, Jmp} = process_instruction(NthInstr, R),
	process_instructions(Instr, NewR, I + Jmp).	

process_instructions(Instr, R) ->
	process_instructions(Instr, R, 1).

print_registers(R) ->
	io:fwrite("Register Values:\n"),
	lists:foreach(fun(V) -> io:fwrite("~p: ~p\n", [V, safe_fetch(V, "[no value]", R)]) end, registers()).

start_a() ->
	R = dict:new(),
	R2 = lists:foldl(fun(V, Reg) -> dict:store(V, 0, Reg) end, R, ["a","b","c","d"]),

	R3 = process_instructions(helper_read_file("12"), R2),
	print_registers(R3).

start_b() ->
	
	R = dict:new(),
	R2 = lists:foldl(fun(V, Reg) -> dict:store(V, 0, Reg) end, R, ["a","b","c","d"]),
	R3 = dict:store("c", 1, R2),
	R4 = process_instructions(helper_read_file("12"), R3),
	print_registers(R4),

	a.