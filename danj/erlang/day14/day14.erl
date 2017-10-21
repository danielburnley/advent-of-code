-module(day14).
-export([start_a/0, start_b/0, hashstore/1]).
-compile(nowarn_unused_function). 
-compile(nowarn_unused_vars).
-include("../helpers/helper.hrl").

int_as_bool(0) -> false;
int_as_bool(_) -> true.
 

start_hashstore() -> spawn(?MODULE, hashstore, [dict:new()]).
hashstore(D) ->
	receive
		{get_md5_2016, K, From} ->
			case dict:is_key(K, D) of
				true ->  
					% io:fwrite("K[~p] is a key! V[~p]\n", [K,dict:fetch(K,D)]),
					From ! {true, dict:fetch(K,D)}, hashstore(D);
				false -> 
					% io:fwrite("K[~p] is not a key!", [K]),
					V = md5_hash_n_times(K, 2017),
					From ! {true, V}, hashstore(dict:store(K,V,D))
			end;			
		{get, K, From} ->
			case dict:is_key(K, D) of
				true ->
					V = dict:fetch(K, D),
					From ! {true, V}, hashstore(D);
				false ->
					V = md5_hash(K),
					io:fwrite("Hashstore: [~p]: ~p\n", [K,V]),
					From ! {true, V}, hashstore(dict:store(K, V, D))
			end;
		{print, From} ->
			io:fwrite("Hashstore K/V:\n", []),
			Keys = dict:fetch_keys(D),
			lists:foreach(fun(K) -> io:fwrite("~p -> ~p\n", [K, dict:fetch(K,D)]) end, Keys),
			From ! {ack}, hashstore(D);
		{repeated_5, From} ->
			B = dict:is_key("repeated-5-count", D),
			io:fwrite("B: ~p\n", [B]),
			case B of
				true -> 
					Count = dict:fetch("repeated-5-count", D) + 1,
					D2 = dict:store("repeated-5-count", Count, D),
					io:fwrite("Count: ~p\n", [Count]);
				false ->
					Count = 1,
					D2 = dict:store("repeated-5-count", Count, D)
			end,


			From ! {ack, Count}, hashstore(D2)
	end.

hashstore_get(K, H) ->
	H ! {get_md5_2016, K, self()},
	receive
		{true, V} -> V;
		{false} -> io:fwrite("no value... erm?"), no_value
	end.

md5_hash_n_times(K, 0) -> K;
md5_hash_n_times(K, NTimes) -> md5_hash_n_times(md5_hash(K), NTimes - 1). 
hashstore_get_md5_2016(K, H) ->
	% MD5 = md5_hash_n_times(K, 2017),
	H ! {get_md5_2016, K, self()},
	receive
		{true, V} -> V;
		{false} -> no_value
	end.


is_string_3_repeated_chars(Str) -> 
	R = re:run(Str, "(.)\\1\\1"),
	{R, R =/= nomatch}.
find_next_triple(Input, 10000000, H) -> 6;
find_next_triple(Input, Index, H) ->
	K = Input ++ i2s(Index),
	MD5 = hashstore_get(K, H),

	{IsRepeated, B} = is_string_3_repeated_chars(MD5),

	case B of 
		true -> 
			% io:fwrite("K[~p]: [~p]\n", [K, MD5]),
			{_Match, [{Pos,Len},_]} = IsRepeated,
			% io:fwrite("Pos: ~p\Len: ~p\n", [Pos, Len]),
			{Index, string:substr(MD5, Pos+1, 1)};
		false -> find_next_triple(Input, Index + 1, H)
	end.
	

is_string_5_repeated_chars(Str, Letter) -> 
	R = re:run(Str, "(.)\\1\\1\\1\\1"),
	Match =  R =/= nomatch,
	case Match of
		false -> {R, false};
		true ->
			Letter5 = lists:flatten(lists:duplicate(5, Letter)),
			M2 = string:str(Str, Letter5),
			% io:fwrite("L5: ~p matches ~p ~p\n", [Letter5, Str, int_as_bool(M2)]),
			{R, int_as_bool(M2)}
	end.

find_next_5letters_in_thousand(Input, Index, Letter, H) -> find_next_5letters_in_thousand(Input, Index+1,Index+1001, Letter,H).
find_next_5letters_in_thousand(Input, Index, EndIndex, Letter, H) when Index == EndIndex -> no_5_letters_in_thousand;
find_next_5letters_in_thousand(Input, Index, EndIndex, Letter, H) ->
	K = Input ++ i2s(Index),
	MD5 = hashstore_get(K, H),
	% io:fwrite("H5 K: ~p MD5: ~p\n", [K, MD5]),

	{IsRepeated, B} = is_string_5_repeated_chars(MD5, Letter),

	case B of 
		false -> find_next_5letters_in_thousand(Input, Index + 1, EndIndex, Letter, H);
		true -> 
			% io:fwrite("true: ~p ~p ~p\n", [IsRepeated, MD5, K]),
			{true, IsRepeated, MD5, K}
	end.


part_a_loop(Input, H) -> part_a_loop(Input, 0, H).
part_a_loop(Input,I, H) ->
	{Index, Letter} = find_next_triple(Input, I, H),

	% io:fwrite("Next triple: ~p\n", [{Index,Letter}]),

	HashWith5LettersInNextThousand = find_next_5letters_in_thousand(Input, Index, Letter, H),
	% io:fwrite("HashWith5LettersInNextThousand: ~p\n", [HashWith5LettersInNextThousand]),

	case HashWith5LettersInNextThousand of
		no_5_letters_in_thousand -> 
			part_a_loop(Input, Index+1, H);
		{true, X, MD5, Input2} ->
			% io:fwrite("X: ~p\n", [X]),
			H ! {repeated_5, self()}, 
			receive 
				{ack, Count} -> 
					io:fwrite("5 matches: ~p\n", [Count]),

					case Count of
						64 -> io:fwrite("Index: ~p\n", [Index]);
						_ -> part_a_loop(Input, Index+1, H)
					end					
			end
	end.


start_a() ->
	Input = "cuanljph",
	Hashstore = start_hashstore(),
	part_a_loop(Input, Hashstore),
	a.





 
does_str_contain_5(Str, Letter) ->
	R = re:run(Str, "(.)\\1\\1\\1\\1"),
	Match =  R =/= nomatch,
	case Match of
		false -> {false, R};
		true ->
			Letter5 = lists:flatten(lists:duplicate(5, Letter)),
			M2 = string:str(Str, Letter5),
			{int_as_bool(M2), R}
	end.

part_b_find_5_sequencial_letters(Input, CurIndex, EndIndex, Letter, Hashstore) when CurIndex == EndIndex -> no_5_letters;
part_b_find_5_sequencial_letters(Input, CurIndex, EndIndex, Letter, Hashstore) ->
	K = Input ++ i2s(CurIndex),
	MD5 = hashstore_get_md5_2016(K, Hashstore),
	{Match, DoesStrContain5Data} = does_str_contain_5(MD5, Letter),

	case Match of 
		false -> part_b_find_5_sequencial_letters(Input, CurIndex+1, EndIndex, Letter, Hashstore);
		_ -> 
			io:fwrite("part5: ~p\n",[K]),
			true
	end.

does_str_contain_3(Str) ->
	R = re:run(Str, "(.)\\1\\1"),
	{R, R =/= nomatch}.

part_b_find_3_sequancial_letters(Input, Index, Hashstore) ->
	K = Input ++ i2s(Index),
	MD5 = hashstore_get_md5_2016(K, Hashstore),
	{Data, DoesStrContain3} = does_str_contain_3(MD5),
	case DoesStrContain3 of
		false -> part_b_find_3_sequancial_letters(Input, Index+1, Hashstore);
		_ ->
			{_,[{Pos,_},_]} = Data,
			Letter = string:substr(MD5, (Pos+1), 1),
			{Index, Letter}
	end.

part_b_loop_new(Input, Hashstore) -> part_b_loop_new(Input, 0, Hashstore).
part_b_loop_new(Input, Index, Hashstore) ->
	{LetterIndex, Letter} = part_b_find_3_sequancial_letters(Input, Index, Hashstore),
	K = Input ++ i2s(LetterIndex),
	DoesContain5InThousand = part_b_find_5_sequencial_letters(Input, LetterIndex + 1, LetterIndex + 1001, Letter, Hashstore),

	case DoesContain5InThousand of
		no_5_letters -> part_b_loop_new(Input, LetterIndex + 1, Hashstore);
		_ ->
			Hashstore ! {repeated_5, self()}, receive {ack, V} -> Count = V end,

			io:fwrite("Count: ~p\n", [Count]),

			case Count of
				64 -> ok;
				_ -> part_b_loop_new(Input, LetterIndex + 1, Hashstore)
			end
	end.

start_b() ->
	Input = "cuanljph", 

	Hashstore = start_hashstore(),

	LastIndex = part_b_loop_new(Input, Hashstore),
	io:fwrite("LastIndex: ~p\n", [LastIndex]),

	b.