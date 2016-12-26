
helper_read_file(Day) ->
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

%Integer 2 String
i2s(I) -> integer_to_list(I).
%String 2 Integer
s2i(S) -> {I, _} = string:to_integer(S), I.

%String Flatten
sf(S) -> lists:flatten(S).

%Copare strings as integers "5" > "123" = 5 > 123 = false
compare_string_integers(S1, S2) -> s2i(sf(S1)) > s2i(sf(S2)).

get_low_high_strings(S1, S2) ->
	case compare_string_integers(S1, S2) of
		true -> {sf(S2), sf(S1)};
		false -> {sf(S1), sf(S2)}
	end.

helper_multiply_string(Str, 1) -> Str;
helper_multiply_string(Str, I) -> Str ++ (helper_multiply_string(Str, I - 1)).

length_of_i(I) -> length(integer_to_list(I)).

safe_fetch(K, Default, F) ->
	case dict:is_key(K, F) of 
		true -> dict:fetch(K, F);
		_Else -> Default
	end.

md5_hash(Input) -> lists:flatten([io_lib:format("~2.16.0b", [C]) || <<C>> <= erlang:md5(Input)]).