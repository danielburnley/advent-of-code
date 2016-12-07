-module(day5).
-export([start_a/0, start_b/0, count_hyphens/1]).

day5_input() ->
	"cxdnnyjw".

md5_hash(Input) ->
	lists:flatten([io_lib:format("~2.16.0b", [C]) || <<C>> <= erlang:md5(Input)]).

find_password(Index, Input, PasswordCharsLeft, Arr) ->
	MD5Input = [Input | integer_to_list(Index)],
	MD5 = md5_hash(MD5Input),
	First5Zeros = string:substr(MD5, 1, 5) == "00000",
	if
		First5Zeros ->
			FourthChar = string:substr(MD5, 6, 1),
			if
				PasswordCharsLeft == 1 ->
					lists:reverse(lists:flatten([FourthChar | Arr]));
				true ->
					find_password(Index + 1, Input, PasswordCharsLeft - 1, [FourthChar | Arr])
			end;
		true ->
			find_password(Index + 1, Input, PasswordCharsLeft, Arr)
	end.

find_password(Input) -> find_password(0, Input, 8, []).

start_a() ->
	io:fwrite("Day5A:\n"),
	Input = day5_input(),

	Password = find_password(Input),

	io:fwrite("Password: ~p\n", [Password]).


new_password(OldPassword, WhichChar, CharPosition) ->
	Position = CharPosition + 1,

	Char = string:substr(OldPassword, Position, 1),
	io:format("Position [~p] [~p]\n", [Position, Char]),
	if
		Char == "-" ->
			NewString = string:substr(OldPassword, 1, Position - 1) ++ WhichChar ++ string:substr(OldPassword, Position + 1),
			NewString;
		true ->
			OldPassword
	end.

count_hyphens(Str) ->
	lists:foldl(fun(X, N) when X =:= hd("-") -> N + 1; (_X, N) -> N end, 0, Str).


find_password_b_loop(Index, Input, Password) ->
	MD5Input = [Input | integer_to_list(Index)],
	MD5 = md5_hash(MD5Input),
	First5Zeros = string:substr(MD5, 1, 5) == "00000",
	if
		First5Zeros ->
			CharPosition = string:substr(MD5, 6, 1),
			CanPlaceAtPosition = (hd(CharPosition) >= 48) and (hd(CharPosition) =< 55),
			if
				CanPlaceAtPosition ->
					WhichChar = string:substr(MD5, 7, 1),
					CharPositionI = list_to_integer(CharPosition),
					NewPassword = new_password(Password, WhichChar, CharPositionI),
					io:fwrite("Found zeros [~p] [~p at Position ~p]\n", [MD5, WhichChar, CharPositionI]),
					HyphenCount = count_hyphens(NewPassword),
					if
						HyphenCount == 0 ->
							NewPassword;
						true ->
							find_password_b_loop(Index + 1, Input, NewPassword)
					end;
				true ->
					find_password_b_loop(Index + 1, Input, Password)					 
			end;

		true ->
			find_password_b_loop(Index + 1, Input, Password)
	end.


find_password_b(Input) -> find_password_b_loop(0, Input, "--------").


start_b() ->
	io:fwrite("Day5B:\n"),	
	Input = day5_input(),

	% Password = new_password("--------", "5", 1),
	% Password2 = new_password(Password, "a", 2),
	Password = find_password_b(Input),

	io:fwrite("Password: ~p\n", [Password]).

