-module(day2).
-export([start_a/0, start_b/0]).

input_day2() ->
    {ok, Data} = file:read_file("day2-input.txt"),
    binary:split(Data, [<<"\n">>], [global]).

isDigitInList(Digit, List) ->
	X = string:str(List, [Digit]),
	% io:fwrite("iDIL [~p]\n", [X]),
	if
		X == 0 ->
			false;
		true ->
			true
	end.

processDigitA(StartDigit, Code) ->

	if
		Code == "U" ->
			Is123 = isDigitInList(StartDigit, [1,2,3]),
			if 
				Is123 ->
					NewDigitValue = StartDigit;
				true ->
					NewDigitValue = StartDigit - 3
			end;
		Code == "R" ->
			Is369 = isDigitInList(StartDigit, [3,6,9]), 
			if
				Is369 ->
					NewDigitValue = StartDigit;
				true ->
					NewDigitValue = StartDigit + 1
			end;
		Code == "D" ->
			Is789 = isDigitInList(StartDigit, [7,8,9]),
			if 
				Is789 ->
					NewDigitValue = StartDigit;
				true ->
					NewDigitValue = StartDigit + 3
			end;
		true ->
			Is147 = isDigitInList(StartDigit, [1,4,7]),
			if
				Is147 ->
					NewDigitValue = StartDigit;
				true ->
					NewDigitValue = StartDigit - 1
			end
	end,
	NewDigitValue.


forEachInstruction([Instruction | []], StartDigit, WhichProcess) ->
	if
		WhichProcess == "a" ->
			Digit = processDigitA(StartDigit, [Instruction]);
		true ->
			Digit = processDigitB(StartDigit, [Instruction])
	end,
	% io:fwrite("fEI e[~p, ~p]\n", [[Instruction], Digit]),
	Digit;

forEachInstruction([Instruction | Tail], StartDigit, WhichProcess) ->
	if
		WhichProcess == "a" ->
			Digit = processDigitA(StartDigit, [Instruction]);
		true ->
			Digit = processDigitB(StartDigit, [Instruction])
	end,
	% io:fwrite("fEI t[~p, ~p]\n", [[Instruction], Digit]),
	forEachInstruction(Tail, Digit, WhichProcess).

processCodeString(Instruction, StartDigit, WhichProcess) ->
	InstructionStr = binary_to_list(Instruction),
	% io:fwrite("processing instruction [~p]\n", [InstructionStr]),

	forEachInstruction(InstructionStr, StartDigit, WhichProcess).


findCode([Line | []], StartDigit, WhichProcess) ->
	processCodeString(Line, StartDigit, WhichProcess);
findCode([Line | Tail], StartDigit, WhichProcess) ->
	[processCodeString(Line, StartDigit, WhichProcess)] ++ [findCode(Tail, StartDigit, WhichProcess)].
	

start_a() ->
	io:format("\e[H\e[J"), %Clear screen
	io:fwrite("Day 2: A\n"),

	Input = input_day2(),

	Code = lists:flatten(findCode(Input, 5, "a")),

	io:fwrite("Code ~p\n", [Code]).



processDigitB(StartDigit, Code) ->
	if
		Code == "U" ->
			Is52149 = isDigitInList(StartDigit, [5,2,1,4,9]),
			if 
				Is52149 ->
					NewDigitValue = StartDigit;
				true ->
					Is678ABC = isDigitInList(StartDigit, [6,7,8,10,11,12]),
					if
						Is678ABC ->
							NewDigitValue = StartDigit - 4;
						true ->
							NewDigitValue = StartDigit - 2
					end
			end;
		Code == "R" ->
			Is149CD = isDigitInList(StartDigit, [1,4,9,12,13]),
			if 
				Is149CD ->
					NewDigitValue = StartDigit;
				true ->
					NewDigitValue = StartDigit + 1
			end;
		Code == "D" ->
			Is5ACD9 = isDigitInList(StartDigit, [5,10,12,13,9]),
			if 
				Is5ACD9 ->
					NewDigitValue = StartDigit;
				true ->
					Is234678 = isDigitInList(StartDigit, [2,3,4,6,7,8]),
					if
						Is234678 ->
							NewDigitValue = StartDigit + 4;
						true ->
							NewDigitValue = StartDigit + 2
					end
			end;
		true ->
			Is125AD = isDigitInList(StartDigit, [1,2,5,10,13]),
			if 
				Is125AD ->
					NewDigitValue = StartDigit;
				true ->
					NewDigitValue = StartDigit - 1
			end
	end,
	NewDigitValue.

start_b() ->
	io:format("\e[H\e[J"), %Clear screen
	io:fwrite("Day 2: B\n"),

	Input = input_day2(),

	Code = lists:flatten(findCode(Input, 5, "b")),

	io:fwrite("Code ~p\n", [Code]).


%% 2A = 12578
%% 2B = 516DD