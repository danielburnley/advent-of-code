-module(day14).
-export([start_a/0, start_b/0, hashstore/1]).
-compile(nowarn_unused_function). 
-compile(nowarn_unused_vars).
-include("../helpers/helper.hrl").

start_hashstore() -> spawn(?MODULE, hashstore, [dict:new()]).
hashstore(D) ->
	receive
		{get, K, From} ->
			case dict:is_key(K, D) of
				true ->
					V = dict:fetch(K, D),
					From ! {true, V}, hashstore(D);
				false ->
					V = md5_hash(K),
					From ! {true, V}, hashstore(dict:store(K, V, D))
			end;
		{print, From} ->
			io:fwrite("Hashstore K/V:\n", []),
			Keys = dict:fetch_keys(D),
			lists:foreach(fun(K) -> io:fwrite("~p -> ~p\n", [K, dict:fetch(K,D)]) end, Keys),
			From ! {ack}, hashstore(D)

	end.

hashstore_get(K, H) ->
	H ! {get, K, self()},
	receive
		{true, V} -> V;
		{false} -> io:fwrite("no value... erm?"), no_value
	end.

start_a() ->
	
	Hashstore = start_hashstore(),

	Val = hashstore_get("abc18", Hashstore),
	io:fwrite("abc18: ~p\n", [Val]),

	Hashstore ! {print, self()}, receive {ack} -> ok end, 

	a.



start_b() ->





	b.