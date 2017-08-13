-module(day7).
-export([start_a/0, start_b/0]).

day7_input() ->
	Day = "7",
	IsFile = filelib:is_regular("day"++Day++"/day"++Day++"-input.txt"),
	if
		IsFile ->
			FilePath = "day"++Day++"/day"++Day++"-input.txt";
		true ->
			FilePath = "day"++Day++"-input.txt"
	end,
    {ok, Data} = file:read_file(FilePath),
    Input = binary:split(Data, [<<"\n">>], [global]),
    lists:map(fun(W) -> binary_to_list(W) end, Input).

check_string_of_4([A,B,B,A]) when A /= B -> true;
check_string_of_4(_) ->  false.

check_string_is_aba([A,B,A]) when A /= B -> true;
check_string_is_aba(_) -> false.

does_string_contain_abba(Str, 0) -> false;
does_string_contain_abba(Str, Index) ->
	Substr = string:substr(Str, Index, 4),
	IsABBA = check_string_of_4(Substr),
	case IsABBA of
		true -> true;
		false -> does_string_contain_abba(Str, Index - 1)
	end.
does_string_contain_abba(Str) ->
	does_string_contain_abba(Str, string:len(Str) - 3).


does_string_contain_aba(Str, 0) -> [];
does_string_contain_aba(Str, Index) ->
	Substr = string:substr(Str, Index, 3),
	IsABA = check_string_is_aba(Substr),
	case IsABA of
		true -> [Substr | does_string_contain_aba(Str, Index - 1)];
		false -> does_string_contain_aba(Str, Index - 1)
	end.
does_string_contain_aba(Str) ->
	does_string_contain_aba(Str, string:len(Str) - 2).



get_inside_and_outside_of_string(Str) ->
	[Outside | MixedTokens] = string:tokens(Str, "["),
	NewMixed = lists:foldl(fun(Mix, Arr) -> [string:tokens(Mix, "]")|Arr] end, [], MixedTokens),
	NewOutsides = [Outside | lists:foldl(fun([_In, Out], Arr) -> [Out|Arr] end, [], NewMixed)],
	NewInsides = lists:foldl(fun([In, _Out], Arr) -> [In|Arr] end, [], NewMixed),
	{NewInsides, NewOutsides}.

is_string_TLS(Str) ->
	{Insides, Outsides} = get_inside_and_outside_of_string(Str),

	OutsideHasAtLeast1ABBA = length(lists:filter(fun (O) -> does_string_contain_abba(O) end, Outsides)),
	InsideHasNoAbba = length(lists:filter(fun (O) -> does_string_contain_abba(O) end, Insides)),

	IsTLS = (OutsideHasAtLeast1ABBA >= 1) and (InsideHasNoAbba == 0),

	case IsTLS of
		true -> 1;
		false -> 0
	end.


start_a() ->
	Input = day7_input(),

	TLS_Count = lists:foldl(fun(Str, Count) -> Count + is_string_TLS(Str) end, 0, Input),
	io:fwrite("Day 7A:\nTLS Count ~p\n", [TLS_Count]).


get_all_aba_from_list(List) ->
	lists:usort(lists:append(lists:foldl(fun(Str, Arr) -> [does_string_contain_aba(Str) | Arr] end, [], List))).

single_product(Item, ListB) ->
	lists:foldl(fun(ItemB, Arr) -> [{Item, ItemB} | Arr] end, [], ListB).
cartesian_product(ListA, ListB) ->
	lists:foldl(fun(Item, Arr) -> [single_product(Item, ListB) | Arr] end, [], ListA).

is_item_ABA_and_BAB({[A,B,A], [B,A,B]}) when A /= B -> true;
is_item_ABA_and_BAB(_) -> false.

is_string_SSL(Str) ->
	{Insides, Outsides} = get_inside_and_outside_of_string(Str),

	% io:fwrite("I [~p]\nO [~p]\n", [Insides, Outsides]),

	OutsideABAs = get_all_aba_from_list(Outsides), 
	InsideABAs = get_all_aba_from_list(Insides),

	% io:fwrite("Outside ABA's: [~p]\n", [OutsideABAs]),
	% io:fwrite("Inside ABA's:  [~p]\n", [InsideABAs]),

	CartesianProduct = lists:flatten(cartesian_product(OutsideABAs, InsideABAs)),
	% io:fwrite("Cartesian ~p\n", [CartesianProduct]),	

	ProductsWhichAreABAandBAB = lists:filter(fun(Product) -> is_item_ABA_and_BAB(Product) end, CartesianProduct),
	% io:fwrite("ABA and BAB products: [~p]\n", [ProductsWhichAreABAandBAB]),

	Length = length(ProductsWhichAreABAandBAB),
	case Length of
		0 -> 0;
		_Else -> 1
	end.


start_b() ->
	Input = day7_input(),

	SSL_Count = lists:foldl(fun(Str, Count) -> Count + is_string_SSL(Str) end, 0, Input),
	io:fwrite("Day 7B:\nSSL Count ~p\n", [SSL_Count]).

	% A = 110
	% B = 242