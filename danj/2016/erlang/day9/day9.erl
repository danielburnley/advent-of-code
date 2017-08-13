-module(day9).
-export([start_a/0, start_b/0]).
-compile(nowarn_unused_function).
-compile(nowarn_unused_vars).
-include("../helpers/helper.hrl").

command_string_to_values(Command) ->
	{_, [{X,Y}]} = re:run(Command, "x"),
	Val1 = s2i(string:substr(Command, 1, X)),
	Val2 = s2i(string:substr(Command, X + 2)),
	{Val1, Val2}.

run_command({NextChars, Length}, RestOfString) ->
	PartToMultiply = helper_multiply_string(string:substr(RestOfString, 1, NextChars), Length),
	RestOfString2 = string:substr(RestOfString, NextChars + 1),
	[PartToMultiply | decompress_string(RestOfString2)]. 

find_next_command(String) ->	
	Regex = "\\(\\d+x\\d+\\)",
	Match = re:run(String, Regex),

	case Match of 
		{match, [{Pos, Length}]} ->
			Before = string:substr(String, 1, Pos),
			Substr = command_string_to_values(string:substr(String, Pos + 2, Length - 2)),
			After = string:substr(String, Pos + 1 + Length),
			{Before, Substr, After};
		_Else ->
			{"", no_command, String}
	end.

decompress_string(Str) ->
	{Prev, Command, RestOfString} = find_next_command(Str),
	case Command of 
		no_command ->
			[RestOfString];
		{NextChars, Length} ->
			[Prev | run_command({NextChars, Length}, RestOfString)];
		_Else ->
			[RestOfString]		
	end.


start_a() ->
	Input = lists:nth(1, helper_read_file("9")),
	Decompressed = lists:flatten(decompress_string(Input)),
	DecomLength = length(Decompressed),
	io:fwrite("Day 9A:\nLen: ~p\n", [DecomLength]).


decompress_string2(Str) ->
	{Prev, Command, RestOfString} = find_next_command(Str),
	PrevLength = length(Prev),
	case Command of 
		no_command ->
			length(RestOfString);
		{NextChars, Multiplier} ->
			StringToMultiply = string:substr(RestOfString, 1, NextChars),
			NotMultipliedString = string:substr(RestOfString, NextChars + 1),
			PrevLength + decompress_string2(StringToMultiply) * Multiplier + decompress_string2(NotMultipliedString);
		_Else ->
			length(RestOfString)
	end.

run_command2({NextChars, Length}, RestOfString) ->
	PartToMultiply = decompress_string2(string:substr(RestOfString, 1, NextChars)), %, Length),
	RestOfString2 = string:substr(RestOfString, NextChars + 1),
	case PartToMultiply of 
		no_command ->
			length(helper_multiply_string(string:substr(RestOfString, 1, NextChars), Length));
		_Else ->
			PartToMultiply * decompress_string2(RestOfString2)
	end.
	

start_b() ->
	Input = lists:nth(1, helper_read_file("9")),
	Decompressed = decompress_string2(Input),
	io:fwrite("Day 9B:\nDecom: ~p\n", [Decompressed]).


	% A: 123908
	% B: 10755693147
