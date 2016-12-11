-module(day8).
-export([start_a/0, start_b/0]).

day8_input() ->
	Day = "8",
	Folder = "day" ++ Day ++ "/",
	File = "day"++Day++"-input.txt",
	IsFile = filelib:is_regular(Folder ++ File),
	if
		IsFile ->
			FilePath = Folder ++ File;
		true ->
			FilePath = File
	end,
    {ok, Data} = file:read_file(FilePath),
    lists:map(fun(W) -> binary_to_list(W) end, binary:split(Data, [<<"\n">>], [global])).

single_product(Item, ListB) ->
	lists:foldl(fun(ItemB, Arr) -> [{integer_to_list(Item) ++","++ integer_to_list(ItemB)} | Arr] end, [], ListB).
cartesian_product(ListA, ListB) ->
	lists:foldl(fun(Item, Arr) -> [single_product(Item, ListB) | Arr] end, [], ListA).

create_grid(W, H) ->
	Grid = dict:append("W", W, dict:append("H", H, dict:new())),

	SeqW = lists:seq(1, W),
	SeqH = lists:seq(1, H),
	Cartesian = lists:flatten(cartesian_product(SeqW, SeqH)),

	NewGrid = lists:foldl(fun(NumXY, Grid2) -> dict:append(NumXY, ".", Grid2) end, Grid, Cartesian),

	% io:fwrite("NewGrid? [~p]\n", [NewGrid]),

	% NewGrid = lists:foldl(fun(NumH, Grid) -> 
	% 	lists:foldl(fun(NumW, Grid) ->
	% 		io:fwrite("["++integer_to_list(NumW)++","++integer_to_list(NumH)++"]"), 
	% 		dict:append("["++integer_to_list(NumW)++","++integer_to_list(NumH)++"]", ".", Grid)
	% 	end, Grid, SeqW),
	% 		io:fwrite("\n")
	% end, Grid, SeqH),

	% io:fwrite("W[~p]\n", [Num]) 
	NewGrid.

get_W_H_of_grid(Grid) ->
	[W] = dict:fetch("W", Grid),
	[H] = dict:fetch("H", Grid),
	[W, H].

print_grid(Grid) ->
	[W,H] = get_W_H_of_grid(Grid),

	SeqW = lists:seq(1, W),
	SeqH = lists:seq(1, H),

	lists:foldl(fun(Y, _Arr) -> 
		lists:foldl(fun(X, _Arr2) ->
			Str = {integer_to_list(X)++","++integer_to_list(Y)},
			Data = dict:fetch(Str, Grid),
			io:fwrite("~s", [Data])
		end, [], SeqW),
		io:fwrite("\n")
	end, [], SeqH),

	
	ok.

%%% Commands
build_rect(Command, Grid) ->
	[XStr, YStr] = string:tokens(Command, "x"),
	{X, _} = string:to_integer(XStr),
	{Y, _} = string:to_integer(YStr),

	SeqX = lists:seq(1, X),
	SeqY = lists:seq(1, Y),

	Cartesian = lists:flatten(cartesian_product(SeqX, SeqY)),

	lists:foldl(fun(NumXY, Grid2) -> dict:update(NumXY, fun(_) -> "#" end,  Grid2) end, Grid, Cartesian).

rotate_column(WhichColumnStr, Grid) ->
	WhichColumn = list_to_integer(string:substr(WhichColumnStr, 3)) + 1,
	[_W, H] = get_W_H_of_grid(Grid),
	SeqH = lists:seq(1, H),

	%% Get the current column data
	CurrentCol = lists:reverse(lists:foldl(fun(Y, Arr) ->
		Key = {integer_to_list(WhichColumn) ++ "," ++ integer_to_list(Y)},
		[dict:fetch(Key, Grid) | Arr]
	end, [], SeqH)),

	% io:fwrite("CurCol [~p]\n", [CurrentCol]),


	%% Moving things down
	Offset = H - 1,
	CurrentCol2 = [lists:nthtail(Offset, CurrentCol) | lists:sublist(CurrentCol, 1, Offset)],

	NewGrid = lists:foldl(fun(Y, Grid2) -> 
		Key = {integer_to_list(WhichColumn) ++ "," ++ integer_to_list(Y)},
		Data = lists:nth(Y, CurrentCol2),
		dict:update(Key, fun(_) -> Data end,  Grid2) 
	end, Grid, SeqH),

	NewGrid.
	
	%%ROTATE ROW
rotate_row(WhichRowStr, Grid) ->
	WhichRow = list_to_integer(string:substr(WhichRowStr, 3)) + 1,
	[W, _H] = get_W_H_of_grid(Grid),
	SeqW = lists:seq(1, W),

	%% Get the current column data
	CurrentCol = lists:reverse(lists:foldl(fun(X, Arr) ->
		Key = {integer_to_list(X) ++ "," ++ integer_to_list(WhichRow)},
		[dict:fetch(Key, Grid) | Arr]
	end, [], SeqW)),


	%% Moving things down
	Offset = W - 1,
	CurrentCol2 = [lists:nthtail(Offset, CurrentCol) | lists:sublist(CurrentCol, 1, Offset)],

	NewGrid = lists:foldl(fun(X, Grid2) -> 
		Key = {integer_to_list(X) ++ "," ++ integer_to_list(WhichRow)},
		Data = lists:nth(X, CurrentCol2),
		dict:update(Key, fun(_) -> Data end,  Grid2) 
	end, Grid, SeqW),

	NewGrid.


	%%END ROW
	
rotate(ColOrRow, WhichColOrRow, Amount, Grid) ->
	case ColOrRow of
		"column" -> 
			AmountSeq = lists:seq(1, list_to_integer(Amount)),
			lists:foldl(fun(_X, Grid2) ->
				rotate_column(WhichColOrRow, Grid2)
			end, Grid, AmountSeq);
			
		"row" -> 
			AmountSeq = lists:seq(1, list_to_integer(Amount)),
			lists:foldl(fun(_Y, Grid2) ->
				rotate_row(WhichColOrRow, Grid2)
			end, Grid, AmountSeq);

		_Else -> io:fwrite("not a column or a row....? [~p]\n", [ColOrRow]), Grid
	end.

process_command(Command, Grid) ->
	Tokens = string:tokens(Command, " "),

	TokenCommand = lists:nth(1, Tokens),

	case TokenCommand of 
		"rect" -> build_rect(lists:nth(2, Tokens), Grid);
		"rotate" -> rotate(lists:nth(2, Tokens), lists:nth(3, Tokens), lists:nth(5, Tokens), Grid);

		_Else -> 
			io:fwrite("no command? ["++TokenCommand++"]"),
			Grid
	end.

is_grid_XY_on(Data) when Data == "#" -> 1;
is_grid_XY_on(_) -> 0.

count_on_switches(Grid) ->
	[W, H] = get_W_H_of_grid(Grid),
	SeqW = lists:seq(1, W),
	SeqH = lists:seq(1, H),

	Cartesian = lists:flatten(cartesian_product(SeqW, SeqH)),

	OnSwitches = lists:foldl(fun(NumXY, Total) -> 
		Total + is_grid_XY_on(lists:flatten(dict:fetch(NumXY, Grid))) 
	end, 0, Cartesian),

	io:fwrite("On switches [~p]\n", [OnSwitches]).

start_a() ->
	Input = day8_input(),
	Grid = create_grid(50, 6),
	
	io:fwrite("Day 8A:\n[~p]\n", [Input]),
	Grid2 = lists:foldl(fun(I,G) -> process_command(I, G) end, Grid, Input),
	print_grid(Grid2),
	count_on_switches(Grid2),

	%%% TEST DATA:

	% TestGrid = create_grid(7, 3),
	% io:fwrite("Grid2 [0,0] {~p}\n", [dict:fetch("W", TestGrid)]),
	% print_grid(TestGrid),

	% Grid2 = process_command("rect 3x2", TestGrid),
	% print_grid(Grid2),

	% Grid3 = process_command("rotate column x=1 by 1", process_command("rotate column x=0 by 1", Grid2)),
	% print_grid(Grid3),

	% Grid4 = process_command("rect 1x1", Grid3),
	% print_grid(Grid4),

	% Grid5 = process_command("rotate column y=3 by 1",process_command("rotate row x=0 by 1", process_command("rotate row x=1 by 3", Grid4))),
	% print_grid(Grid5),

	% count_on_switches(Grid5),

	a.

start_b() ->
	io:fwrite("Day 8B:\nScreen code: [ZJHRKCPLYJ]").

	%% A = 110
	%% B = ZJHRKCPLYJ