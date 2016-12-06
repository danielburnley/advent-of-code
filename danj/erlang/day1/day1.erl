-module(day1).
-export([start_a/0, start_b/0]).

input_test_1() ->
	"R2, L1, R2, R1, R1, R1, R4". %intersect at [3,1]
% input_test_2() ->
% 	"R2, L1, R2, R1, R1, L3, R3, L5".
% input_test_3() ->
% 	"R2, L3".  %2 blocks east, 3 blocks north, 5 blocks away total
% input_test_4() ->
% 	"R2, R2, R2". %leaves you 2 blocks south of your start position
% input_test_5() ->
% 	"R5, L5, R5, R3". %leaves you 12 blocks away.

input_1a() ->
	"R2, L1, R2, R1, R1, L3, R3, L5, L5, L2, L1, R4, R1, R3, L5, L5, R3, L4, L4, R5, R4, R3, L1, L2, R5, R4, L2, R1, R4, R4, L2, L1, L1, R190, R3, L4, R52, R5, R3, L5, R3, R2, R1, L5, L5, L4, R2, L3, R3, L1, L3, R5, L3, L4, R3, R77, R3, L2, R189, R4, R2, L2, R2, L1, R5, R4, R4, R2, L2, L2, L5, L1, R1, R2, L3, L4, L5, R1, L1, L2, L2, R2, L3, R3, L4, L1, L5, L4, L4, R3, R5, L2, R4, R5, R3, L2, L2, L4, L2, R2, L5, L4, R3, R1, L2, R2, R4, L1, L4, L4, L2, R2, L4, L1, L1, R4, L1, L3, L2, L2, L5, R5, R2, R5, L1, L5, R2, R4, R4, L2, R5, L5, R5, R5, L4, R2, R1, R1, R3, L3, L3, L4, L3, L2, L2, L2, R2, L1, L3, R2, R5, R5, L4, R3, L3, L4, R2, L5, R5".


start_a() ->
	io:format("\e[H\e[J"), %Clear screen
	InputData =  input_1a(), 
	SplitInstructions = splitIntoInstructions(InputData),
	Locations = getLocationsFromInstructions(SplitInstructions),

	{_LLF, LLX, LLY} = lists:last(Locations),
	Distance = getDistanceFromXY(LLX, LLY),

	io:fwrite("Day 1A: Last position: [~p, ~p]\nDistance: [~p]\n", [LLX, LLY, Distance]).




%% Day 1 B

commandFromString(Str)->
	Facing = string:substr(Str, 1, 1),
	Dist = list_to_integer(string:substr(Str, 2)),
	{Facing, Dist}.

splitIntoInstructions(Str) ->
	PositionOfComma = string:str(Str, ", "),
	if
		PositionOfComma > 0 ->
			Word = string:substr(Str, 1, PositionOfComma - 1),
			RestOfWord = string:substr(Str, PositionOfComma + 2),

			[commandFromString(Word) | splitIntoInstructions(RestOfWord)];
		true ->
			[commandFromString(Str)]
	end.

printInstructions([{F,D}|[]]) ->
	io:fwrite("[~p,~p]\n", [F,D]);	
printInstructions([{F,D}|Tail]) ->
	io:fwrite("[~p,~p]\n", [F,D]),
	printInstructions(Tail).

doesLocationMatch({X1, Y1}, {X2, Y2}) ->
	(X1 == X2) and (Y1 == Y2).

isLocationAlreadyInArray([ArrayLocation|[]], NewLocation) ->
	doesLocationMatch(ArrayLocation, NewLocation);
isLocationAlreadyInArray([ArrayLocation|Tail], NewLocation) ->
	DoesMatch = doesLocationMatch(ArrayLocation, NewLocation),
	if
		DoesMatch ->
			true;
		true ->
			isLocationAlreadyInArray(Tail, NewLocation)
	end.

findSecondVisitedLocation([{F,X,Y} | Tail], []) ->
	findSecondVisitedLocation(Tail, [{X,Y}]);
findSecondVisitedLocation([{F,X,Y} | []], PrevLocations) ->
	IsAlreadyInArray = isLocationAlreadyInArray(PrevLocations, {X,Y}),
	if 
		IsAlreadyInArray ->
			[{F,X,Y}];
		true ->
			[{99999, 99999, 99999}]
	end;
findSecondVisitedLocation([{F,X,Y} | Tail], PrevLocations) ->
	IsAlreadyInArray = isLocationAlreadyInArray(PrevLocations, {X,Y}),
	if 
		IsAlreadyInArray ->
			[{X,Y}];
		true ->
			findSecondVisitedLocation(Tail, PrevLocations ++ [{X,Y}])
	end.

findSecondVisitedLocation(Array) ->
	findSecondVisitedLocation(Array, []).

%%% Turns "R" or "L" into 1 or -1
getFacingValue(Facing) when Facing == "R" ->
	1;
getFacingValue(_Facing) -> %Assume Facing == "L"
	-1.

newLocation({Facing, X, Y}) ->
	if
		Facing == 0 ->
			NewX = X,
			NewY = Y + 1;
		Facing == 1 ->
			NewX = X + 1,
			NewY = Y;
		Facing == 2 ->
			NewX = X,
			NewY = Y - 1;
		true -> %RealNewFacing == 3 ->
			NewX = X - 1,
			NewY = Y
	end,
	{Facing, NewX, NewY}.

moveForward({Facing, X, Y}, Distance) ->
	{NLF, NLX, NLY} = newLocation({Facing, X, Y}),
	if
		Distance > 1 ->
			[{NLF, NLX, NLY}] ++ moveForward({Facing, NLX, NLY}, Distance - 1);
		true ->
			[{NLF, NLX, NLY}]
	end.


%%% Process command - Turn [{R,2}] into [{1,0}, {2,0}]
processCommand({LocationFacing, LocationX, LocationY}, {NewFacing, NewDistance}) ->
	Facing = (LocationFacing + getFacingValue(NewFacing) + 4) rem 4,

	moveForward({Facing, LocationX, LocationY}, NewDistance).




%%%% {F, X, Y} = {Facing, X, Y} - Facing [0 = Up, 1 = Right, 2 = Down, 3 = Left]
%%%% 
getLocationsFromInstructions([{Facing, Distance} | []], Locations) ->
	{LLF, LLX, LLY} = lists:last(Locations),
	NewLocations = processCommand({LLF, LLX, LLY}, {Facing, Distance}),
	NewLocations;


getLocationsFromInstructions([{Facing, Distance} | Tail], []) ->
	StartLocation = {0, 0, 0},
	NewLocations = processCommand(StartLocation, {Facing, Distance}),
	NewLocations ++ [getLocationsFromInstructions(Tail, NewLocations)];

getLocationsFromInstructions([{Facing, Distance} | Tail], Locations) ->
	{LLF, LLX, LLY} = lists:last(Locations),
	NewLocations = processCommand({LLF, LLX, LLY}, {Facing, Distance}),
	NewLocations ++ [getLocationsFromInstructions(Tail, NewLocations)].

getLocationsFromInstructions(Instructions) ->
	flatten(getLocationsFromInstructions(Instructions, [])).
	% [{0, 0}, {1, 0}, {1, 1}, {2, 1}, {2, 0}, {1, 0}].

printLocations([{F,X,Y} | []]) ->
	io:fwrite("PL [E] [~p,~p, ~p]\n", [F,X,Y]);
printLocations([{F,X,Y}|Tail]) ->
	io:fwrite("PL [T] [~p,~p,~p]\n", [F,X,Y]),
	printLocations(Tail).



start_b() ->
	%Clear the terminal
	io:format("\e[H\e[J"),

	% Get the input data
	InputData =  input_1a(), 

	% Splits a string into instructions "R2, L1, R2" -> [[R,2],[L,1],[R,2]]
	SplitInstructions = splitIntoInstructions(InputData), 

	% Turns a set of instructions into Locations [[R,2],[L,1],[R,2]] -> [{0,0}, {1,0}, {2,0}, {2,1}, {3,1}, {4,1}]
	Locations = getLocationsFromInstructions(SplitInstructions),

	% Finds the location which has been visited twice
	[{X,Y}] = findSecondVisitedLocation(Locations),
	% Distance of the XY to {0,0} (in taxi-cab distance)
	Distance = getDistanceFromXY(X,Y),

	io:fwrite("Day 1B: Second visited location: [~p,~p]\nDistance: [~p]\n", [X, Y, Distance]),

	ok.

%%% Helper Functions

%% Flatten a deep-list 
flatten(X) -> lists:reverse(flatten(X,[])).
flatten([],Acc) -> Acc;
flatten([H|T],Acc) when is_list(H) -> flatten(T, flatten(H,Acc));
flatten([H|T],Acc) -> flatten(T,[H|Acc]).

%% Get taxi-cab distance
getDistanceFromXY(X, Y) ->
	abs(X) + abs(Y).


%% 1A = 234
%% 1B = (16, -97) = 113