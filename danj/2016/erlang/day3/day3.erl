-module(day3).
-export([start_a/0, start_b/0]).

input_day3() ->
    {ok, Data} = file:read_file("day3/day3-input.txt"),
    binary:split(Data, [<<"\n">>], [global]).

isTriangleValid([A, B, C]) ->
	IntA = list_to_integer(A),
	IntB = list_to_integer(B),
	IntC = list_to_integer(C),
	AB = IntA + IntB > IntC,
	AC = IntA + IntC > IntB,
	BC = IntB + IntC > IntA,
	ABC = (AB and AC and BC),
	if
		(ABC) ->
			1;
		true -> 
			0
	end.

countValidTriangles([Head | []]) ->
	Triangle = string:tokens(binary_to_list(Head), " "),
	isTriangleValid(Triangle);

countValidTriangles([Head | Tail]) ->
	Triangle = string:tokens(binary_to_list(Head), " "),
	IsValid = isTriangleValid(Triangle),
	IsValid + countValidTriangles(Tail).
	

start_a() ->
	io:format("\e[H\e[J"), %Clear screen
	io:fwrite("Day 3A:\n"),

	Input = input_day3(),
	ValidTriangles = countValidTriangles(Input),
	io:format("Valid triangle count [~p]\n", [ValidTriangles]).


turnDataIntoArray([Head | []]) ->
	string:tokens(binary_to_list(Head), " ");
turnDataIntoArray([Head | Tail]) ->
	string:tokens(binary_to_list(Head), " ") ++ turnDataIntoArray(Tail).
	
countValidTrianglesCols(List) ->
	Col1 = [lists:nth(1, List), lists:nth(4, List), lists:nth(7, List)],
	Col2 = [lists:nth(2, List), lists:nth(5, List), lists:nth(8, List)],
	Col3 = [lists:nth(3, List), lists:nth(6, List), lists:nth(9, List)],

	ValidTriangleCount = isTriangleValid(Col1) + isTriangleValid(Col2) + isTriangleValid(Col3),

	if
		length(List) == 9 ->
			ValidTriangleCount;
		true ->
			ValidTriangleCount + countValidTrianglesCols(lists:nthtail(9, List))
	end.


start_b() ->
	io:format("\e[H\e[J"), %Clear screen
	io:fwrite("Day 3B:\n"),

	Input = input_day3(),
	Array = turnDataIntoArray(Input),
	ValidTriangles = countValidTrianglesCols(Array),
	io:fwrite("Valid triangles [~p]\n", [ValidTriangles]).