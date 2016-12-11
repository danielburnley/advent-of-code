-module(day6).
-export([start_a/0, start_b/0]).

day6_input() ->
    {ok, Data} = file:read_file("day6/day6-input.txt"),
    Input = binary:split(Data, [<<"\n">>], [global]),
    lists:map(fun(W) -> binary_to_list(W) end, Input).

letterFrequency(Str) ->
	lists:reverse(lists:keysort(2, lists:foldl(fun(X,[{[X],I}|Q]) -> [{[X],I+1}|Q] ; (X,Acc) -> [{[X],1}|Acc] end , [], lists:sort(Str)))).

get_column_frequency([], _Col) -> [];
get_column_frequency([H|T], Col) ->
	[string:substr(H, Col, 1) | get_column_frequency(T, Col)].


solution_a(_Words, 9) -> "";
solution_a(Words, N) ->
	ColFreq = letterFrequency(get_column_frequency(Words, N)),
	{Letter, _Freq} = lists:nth(1, ColFreq),
	[Letter | solution_a(Words, N + 1)].

solution_a(Words) ->
	lists:flatten(solution_a(Words, 1)).

start_a() ->
	Words = day6_input(),
	io:fwrite("Day 6A:\nMost frequant letter password [~p]\n", [solution_a(Words)]).


solution_b(_Words, 9) -> "";
solution_b(Words, N) ->
	ColFreq = letterFrequency(get_column_frequency(Words, N)),
	{Letter, _Freq} = lists:last(ColFreq),
	[Letter | solution_b(Words, N + 1)].

solution_b(Words) ->
	lists:flatten(solution_b(Words, 1)).

start_b() ->
	Words = day6_input(),
	io:fwrite("Day 6B:\nLeast frequent letter password [~p]\n", [solution_b(Words)]).
	%Potentially map [1,2..7,8] [getXLetter from Col N]

 	% A = qoclwvah
 	% B = ryrgviuv