-module(day13).
-export([start_a/0, start_b/0, list/1]).
-compile(nowarn_unused_function). 
-compile(nowarn_unused_vars).
-include("../helpers/helper.hrl").

coordinate_calculation(X,Y,N) -> X*X + 3*X + 2*X*Y + Y + Y*Y + N.

bitcount(V) -> bitcount(V, 0).
bitcount(0, C) -> C;
bitcount(V, C) -> bitcount( (V band (V - 1)), (C + 1)).
bce(Num) when Num rem 2 == 0 -> true;
bce(_) -> false.
is_bit_count_even(Num) -> bce(bitcount(Num)).

print_map(M) ->
	W = dict:fetch("W", M),
	H = dict:fetch("H", M),

	io:fwrite("W: ~p\nH: ~p\n", [W,H]),

	lists:foreach(fun(Y) ->
		lists:foreach(fun(X) ->
			K = i2s(X)++"-"++i2s(Y),
			io:fwrite("~s", [dict:fetch(K, M)])
		end, lists:seq(0, W - 1)),
		io:fwrite("\n")
	end, lists:seq(0, H - 1)).

% Manhatten distance
calculate_h_score({X1,Y1}, {X2, Y2}) -> abs(X1 - X2) + abs(Y1 - Y2).

% Removes a node from a list if the X,Y position matches
remove_node_from_list(N = {{X,Y},_,_}, [Head = {{X2,Y2},_,_}|Tail]) when (X == X2) and (Y == Y2) -> Tail;
remove_node_from_list(_, [H|[]]) -> H;
remove_node_from_list(N, [H|T]) -> lists:flatten([H|remove_node_from_list(N, T)]).

% If the key in the map is (#) then it's not walkble - else (.) means it is (default.. )
is_walkable(V) when V == "#" -> false;
is_walkable(_) -> true.
is_walkable(K, M) ->  is_walkable(dict:fetch(K, M)).

% Checks whether an XY is within the Map bounds
is_xy_within_bounds(X, Y, _) when (X < 0) or (Y < 0) -> false;
is_xy_within_bounds(X, Y, M) ->
	{W,H} = {dict:fetch("W", M), dict:fetch("H", M)},
	((X < W) and (Y < H)).

% Calculates the distance backtracking from the parent
calculate_path_length_from_node(N = {_,_, Parent}, ClosedList) when (Parent == no_parent) -> 0; %Well it should return 1 but the path length is (amount of nodes -1, so it's [1 - 1] here...)
calculate_path_length_from_node(N = {_,_, Parent = {PX,PY}}, ClosedList) ->
	% Ask the closed list if the parent XY is in the list
	ClosedList ! {in_list_xy, {PX,PY}, self()},
	receive
		% If it is, add 1 to the counter and check with it's parent
		{true, P} -> 1 + calculate_path_length_from_node(P, ClosedList);
		% No parent - end of path
		{false} -> 0
	end.

%%% NODE COUNTING
is_node_in_list({X,Y}, [N = {{X, Y}, _, _}|_]) -> {true, N};
is_node_in_list(_, []) -> {false};
is_node_in_list(XY, [_|T]) -> is_node_in_list(XY, T).

%% FINDING ADJACENT NODES
find_adjacent_nodes(N = {{X, Y}, {G, H, F}, P}, Target, OpenList, ClosedList, M) ->
	lists:foldl(fun({DX,DY}, Arr) ->
		% Neighbor XY
		NX = X + DX,
		NY = Y + DY,

		case is_xy_within_bounds(NX,NY,M) of 
			true -> 
				% _NewG = G + calculate_h_score({X,Y}, {NX,NY}),
				%% ToDo: If the NewG is less than the current G - then update? (Not really useful for 4 direction A* - but for 8 directions is a must for implementation)

				% Is the neighbor XY in the closed list?
				ClosedList ! {in_list_xy, {NX,NY}, self()},
				receive
					{true, N2} -> IsClosed = true;
					{false} -> IsClosed = false
				end,
				% Is the neighbor XY in the open list?
				OpenList ! {in_list_xy, {NX,NY}, self()},
				receive 
					{true, N3} -> IsOpen = true;
					{false} -> IsOpen = false
				end,

				% The map key of the neighbor XY
				K = i2s(NX)++"-"++i2s(NY),
				% Is the tile walkable?
				W = is_walkable(K, M),
				% Should this neighbor be added to the adjacent list?
				case (W and not IsClosed and not IsOpen) of
					true -> 
						NH = calculate_h_score({NX, NY}, Target),
						NG = G + 1,
						Node = {{NX, NY}, {NG, NH, NH + NG}, {X,Y}},
						% Add the neighbor node to the adjacent list
						[Node|Arr];
					% If not - return the existing adjacent array?
					false -> Arr
				end;

				%% If is in open list update [openlist g score] to be NewG and F to be NewG + 
			false -> Arr
		end		
		% This loops over the 4 nodes horizontally/vertically from this node
	end, [], [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]).

%% INTERACTIVE LIST 
% Create a new list process
create_new_list(Arr) -> spawn(?MODULE, list, [Arr]).
% The list method loop
list(Arr) ->
	receive
		{add_node, N, From} ->
			From ! {ack}, list([N|Arr]);
		{remove_node, N, From} ->
			From ! {ack}, list(remove_node_from_list(N, Arr));
		{print, From} ->
			io:fwrite("Arr: ~p\n", [Arr]),
			From ! {ack}, list(Arr);
		{in_list_xy, {X,Y}, From} ->
			From ! is_node_in_list({X,Y}, Arr), list(Arr);
		{add_adjacent_nodes, Nodes, From} ->
			From ! {ack}, list(lists:flatten([Nodes | Arr]));
		{lowest_f_node, From} ->
			Sorted = lists:sort(fun({_,{_,_,F1},_},{_,{_,_,F2},_}) -> F1 < F2 end, Arr),
			From ! {true, lists:nth(1, Sorted)}, list(Arr);
		{all_nodes, From} ->
			From ! {true, Arr}, list(Arr)
	end.
list_get_all_nodes(List) ->
	List ! {all_nodes, self()},
	receive 
		{true, Nodes} -> Nodes;
		{false} -> io:fwrite("Problem... error1!!!!\n"), []
	end.

%% PATHFINDING
pathfinding(M, P1={X1,Y1}, P2={X2, Y2}) ->	
	% Setup the first Node at positon X1/Y1
	G = 0,
	H = calculate_h_score(P1, P2),
	F = G + H,
	Node = {{X1,Y1}, {G,H,F}, no_parent}, %the last var is normally {parent_x, parent_y} but an atom of no_parent means..
	
	% Create the lists!
	OpenList = create_new_list([]),
	ClosedList = create_new_list([]),

	% Add the first node to the open list
	OpenList ! {add_node, Node, self()}, receive {ack} -> ok end,

	% Find us the end node!
	EndNode = pathfinding_loop(Node, P2, OpenList, ClosedList, M),

	% Return the Openlist and Closedlist for interaction? And also the Endnode!
	{OpenList, ClosedList, EndNode}.

pathfinding_loop(Node, Target, OpenList, ClosedList, M) ->
	% Remove the current node from the Openlist
	OpenList ! {remove_node, Node, self()}, receive {ack} -> ok end,
	% Find all adjacent nodes (which aren't in the open or close lists)
	AdjacentNodes = find_adjacent_nodes(Node, Target, OpenList, ClosedList, M),
	% Add all the adjacent nodes into the openlist
	OpenList ! {add_adjacent_nodes, AdjacentNodes, self()}, receive {ack} -> ok end,
	% Add the current node into the closedlist
	ClosedList ! {add_node, Node, self()}, receive {ack} -> ok end,

	% Ask the openlist for the node with the lowest F score
	OpenList ! {lowest_f_node, self()},
	receive 
		{true, FNode} -> LowestFNode = FNode;
		{false} -> io:fwrite("Problems finding the lowest F node... uhm..?\n"), LowestFNode = no_node
	end,

	% Extract the H score from the node with the lowest F score
	{_,{_,HScore, _}, _} = LowestFNode,

	% Check if the HScore is 0
	case HScore of
		% If it is - then we must be on top of the target - return the node
		0 -> LowestFNode;
		% If not - Continue finding a path to the target
		_ -> pathfinding_loop(LowestFNode, Target, OpenList, ClosedList, M)
	end.

% Given a Width and Height - computes the value based on the coordinate_calculation function and returns a Map
get_input_as_map(WX,HX) ->
	{W, H} = {WX,HX},
	Map = dict:store("H", H, dict:store("W", W, dict:new())),
	lists:foldl(fun(Y, MapY) ->
		lists:foldl(fun(X, MapX) ->
			Num = coordinate_calculation(X, Y, 1350),
			BitCountEven = is_bit_count_even(Num),
			case BitCountEven of
				true -> V = ".";
				false -> V = "#"
			end,
			dict:store(i2s(X)++"-"++i2s(Y), V, MapX)
		end, MapY, lists:seq(0, W))
	end, Map, lists:seq(0, H)).

start_a() ->
	% A map of width 50 and height 50 should be satifiable for this
	Map = get_input_as_map(40,50),

	% Get the endnode and open/closed list from the pathfinding function
	{O, C, Node} = pathfinding(Map, {1,1}, {31,39}),
	io:fwrite("PathfindingNode: ~p\n", [Node]),

	LengthOfPath = calculate_path_length_from_node(Node, C),
	io:fwrite("Length of path: ~p\n", [LengthOfPath]).

part_b_process(Map, {X,Y}, Index) ->
	% Create open/closed lists... #standard
	OpenList = create_new_list([]),
	ClosedList = create_new_list([]),

	% Create and add the first node to the openlist
	Node = {{X,Y}, {0,0,0}, no_parent},
	OpenList ! {add_node, Node, self()}, receive {ack} -> ok end,

	part_b_process(Map, OpenList, ClosedList, Index).


% If index is 0 - just return the list of nodes in openlist
part_b_process(_,OpenList,_, 0) -> list_get_all_nodes(OpenList);
part_b_process(Map,OpenList,ClosedList, Index) ->
	% Find all nodes
	AllNodes = list_get_all_nodes(OpenList),

	% For all nodes which aren't in openlist - check their adjacent squares to see if to add them to openlist
	lists:foreach(fun(N)->
		AdjNodes = find_adjacent_nodes(N, {0,0}, OpenList, ClosedList, Map),
		OpenList ! {add_adjacent_nodes, AdjNodes, self()}, receive {ack} -> ok end
	end, AllNodes),

	% repeat
	part_b_process(Map, OpenList, ClosedList, Index - 1).

start_b() ->
	Map = get_input_as_map(55,55),

	Locations = part_b_process(Map, {1,1}, 50),
	io:fwrite("Locations: ~p\n", [length(Locations)]).

	% A = 92
	% B = 124