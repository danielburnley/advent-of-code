-module(day10).
-export([start_a/0, start_b/0]).
-compile(nowarn_unused_function).
-compile(nowarn_unused_vars).
-include("../helpers/helper.hrl").

safe_fetch(K, Default, F) ->
	case dict:is_key(K, F) of 
		true -> dict:fetch(K, F);
		_Else -> Default
	end.
check_bot_exists(Bot, F) ->
	K = "bot-"++Bot,
	case dict:is_key(K, F) of
		true -> F;
		false ->
			F2 = dict:append(K, [], F),
			case dict:is_key("bots", F2) of 
				false -> dict:append("bots", K, F2);
				true -> dict:update("bots", fun(Arr) -> Arr ++ [K] end,  F2)
			end
	end.

give_value_to_bot(Value, Bot, F) ->
	F2 = check_bot_exists(Bot, F),

	I1 = "bot-" ++ Bot ++ "-item1",
	case safe_fetch(I1, no_item, F) of
		no_item ->
			F3 = dict:append(I1, Value, F2),
			F3;
		_Else ->
			I2 = "bot-" ++ Bot ++ "-item2",
			F3 = dict:append(I2, Value, F2),
			F3
	end.

bot_key_distribute(BK, F) ->
	bot_distribute(string:substr(BK, 5), F).
bot_distribute(Bot, F) ->
	% io:fwrite("Bot[~p] distribute\n", [Bot]),

	BK = "bot-" ++ Bot,

	I1V = dict:fetch(BK ++ "-item1", F),
	I2V = dict:fetch(BK ++ "-item2", F),

	{I1, I2} = get_low_high_strings(I1V, I2V),

	case ((I1 == "61") or (I2 == "61")) and ((I1 == "17") or (I2 == "17")) of
		true -> io:fwrite("Bot [~p] comparing [~p, ~p]\n", [BK, I1, I2]);
		_ -> ok
	end,

	FRemovedKeys = dict:erase(BK ++ "-item1", dict:erase(BK ++ "-item2", F)),

	LB = lists:flatten(dict:fetch(BK ++ "-low", FRemovedKeys)),
	HB = lists:flatten(dict:fetch(BK ++ "-high", FRemovedKeys)),

	FBotsExist = check_bot_exists(LB, check_bot_exists(HB, FRemovedKeys)),

	FBotsWithValues = give_value_to_bot(I1, LB, give_value_to_bot(I2, HB, FBotsExist)),
	FBotsWithValues.

factory_distribute(F) ->
	Bots = dict:fetch("bots", F),

	HasChanged = false,

	case Bots of 
		false -> F;
		_Else ->
			BotsWhichHave2Items = lists:filtermap(fun(X) -> 
				I1 = safe_fetch(X ++ "-item1", no_item, F),
				I2 = safe_fetch(X ++ "-item2", no_item, F),

				(I1 /= no_item) and (I2 /= no_item)
			end, Bots),

			Length = length(BotsWhichHave2Items),
			case Length of
				0 -> F;
				_ ->
					Bot = lists:nth(1, BotsWhichHave2Items),
					F3 = bot_key_distribute(Bot, F),
					factory_distribute(F3)
			end
	end.




bot_set_instruction(Bot, Low, High, F) ->
	BK = "bot-" ++ Bot,
	F1 = dict:append(BK ++ "-low", Low, dict:append(BK ++ "-high", High, F)).


print_factory(F) ->
	io:fwrite("\nPrint Factory:\n"),
	Bots = dict:fetch("bots", F),

	case Bots of 
		false -> io:fwrite("No bots.\n");
		_Else ->
			lists:map(fun(BK) -> 	
				I1 = safe_fetch(BK ++ "-item1", no_item, F),
				I2 = safe_fetch(BK ++ "-item2", no_item, F),
				io:fwrite("\nBot ~p\n", [BK]),
				io:fwrite("Item1: ~p\n", [I1]),
				io:fwrite("Item2: ~p\n", [I2])
			end, Bots)
	end,
	io:fwrite("\n").

process_command(S, F) ->
	Tokens = string:tokens(S, " "),
	First = lists:nth(1, Tokens),

	case First of 
		"value" ->
			Value = lists:nth(2, Tokens),
			Bot = lists:nth(6, Tokens),
			give_value_to_bot(Value, Bot, F);
		"bot" ->
			Bot = lists:nth(2, Tokens),
			WhereLow = lists:nth(6, Tokens),
			WhereValLow = lists:nth(7, Tokens),

			case WhereLow of 
				"bot" -> DestLow = WhereValLow;
				"output" -> DestLow = "o"++WhereValLow
			end,

			WhereH = lists:nth(11, Tokens),
			WhereHVal = lists:nth(12, Tokens),

			case WhereH of 
				"bot" -> DestHigh = WhereHVal;
				"output" -> DestHigh = "o"++WhereHVal
			end,
			bot_set_instruction(Bot, DestLow, DestHigh, F);
		_Else ->
			io:fwrite("Unkown command [~p]\n", [First])
	end.

process_commands([H|[]], F) ->
	process_command(H, F);
process_commands([H|T], F) ->
	process_commands(T, process_command(H, F)).

start_a() ->
	Commands = helper_read_file("10"),

	F = dict:new(),
	F2 = process_commands(Commands, F),
	F3 = factory_distribute(F2).


start_b() ->
	Commands = helper_read_file("10"),

	F = dict:new(),
	F2 = process_commands(Commands, F),
	F3 = factory_distribute(F2),

	[Out0] = safe_fetch("bot-o0-item1", no_item, F3),
	[Out1] = safe_fetch("bot-o1-item1", no_item, F3),
	[Out2] = safe_fetch("bot-o2-item1", no_item, F3),

	OutValue = s2i(Out0) * s2i(Out1) * s2i(Out2),

	io:fwrite("Output 0/1/2 multiplied: ~p\n", [OutValue]).


