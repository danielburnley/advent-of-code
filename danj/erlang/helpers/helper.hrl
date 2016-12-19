
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

helper_s2i(Str) -> {I, _} = string:to_integer(Str), I.

helper_multiply_string(Str, 1) -> Str;
helper_multiply_string(Str, I) -> Str ++ (helper_multiply_string(Str, I - 1)).

length_of_i(I) -> length(integer_to_list(I)).