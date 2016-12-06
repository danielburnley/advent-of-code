-module(day4).
-export([start_a/0, start_b/0]).

day4_input() ->
    {ok, Data} = file:read_file("day4/day4-input.txt"),
    binary:split(Data, [<<"\n">>], [global]).

letterFrequency(Str) ->
	lists:reverse(lists:keysort(2, lists:foldl(fun(X,[{[X],I}|Q]) -> [{[X],I+1}|Q] ; (X,Acc) -> [{[X],1}|Acc] end , [], lists:sort(Str)))).

doChecksumsMatch(ChecksumA, ChecksumB) ->
	ChecksumA =:= ChecksumB.

sum_real_room_sector_ids(Rooms) ->
	lists:foldl(fun({_Name,SectorID,_Checksum}, Sum) -> SectorID + Sum end, 0, Rooms).

caesar(CipherText, Shift) ->
	string:join(string:tokens(lists:map(fun(X) -> ((X - 97 + Shift + 26) rem 26) + 97  end, CipherText), "L"), " ").

is_room_north_pole({EncryptedName, SectorID, _Checksum}) ->
	PlainText = caesar(EncryptedName, SectorID),
	string:str(PlainText, "northpole") * SectorID. %If the string pos is 0 then it returns [SectorID * 0] 

find_north_pole_room(Rooms) ->
	lists:foldl(fun(Room, Sum) -> is_room_north_pole(Room) + Sum end, 0, Rooms).

find_real_room(Room) ->
	Length = length(Room),
	EncryptedName = string:join(string:tokens(string:substr(Room, 1, Length - 11), "-"),""),
	SectorID = list_to_integer(string:substr(Room, Length - 9, 3)),
	Checksum = string:substr(lists:nthtail(Length - 6, Room), 1, 5),
	MostCommonLetters = letterFrequency(EncryptedName),
	Top5 = string:substr(lists:foldl(fun({Letter, _Freq}, Top5) -> Top5 ++ Letter end, "", MostCommonLetters), 1, 5),
	IsValid = doChecksumsMatch(Checksum, Top5),

	if
		IsValid ->
			{EncryptedName, SectorID, Checksum};
		true ->
			[]
	end.

find_real_rooms_loop(Rooms) ->
	lists:map(fun(Room) -> find_real_room(binary_to_list(Room)) end, Rooms).

start_a() ->
	io:fwrite("Day4A:\n"),
	RealRooms = lists:flatten(find_real_rooms_loop(day4_input())),
	SumOfRealRoomSectorIDs = sum_real_room_sector_ids(RealRooms),
	io:fwrite("SumOfRealRoomSectorIDs: [~p]\n", [SumOfRealRoomSectorIDs]).

start_b() ->
	io:fwrite("Day4B:\n"),
	RealRooms = lists:flatten(find_real_rooms_loop(day4_input())),
	NorthPoleRoomSectorID = find_north_pole_room(RealRooms),
	io:fwrite("NorthPoleRoomSectorID: [~p]\n", [NorthPoleRoomSectorID]).

%% A: 185371
%% B: 984