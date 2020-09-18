-module(json_utils).

-export([parse/1, stringify/1, iolist_to_json_array_iolist/1]).

decode_options() ->
	[return_maps, use_nil, dedupe_keys].

encode_options() ->
	[use_nil].


-spec(parse(iodata()) -> jiffy:json_value()).
parse(Data) ->
	jiffy:decode(Data, decode_options()).

-spec(stringify(jiffy:json_value()) -> iodata()).
stringify(JsonData) ->
	jiffy:encode(JsonData, encode_options()).

-spec(smash_iolist(iolist(), iolist()) -> iolist()).
smash_iolist([], FullList) ->
	FullList;
smash_iolist([H], FullList) ->
	FullList ++ [H];
smash_iolist([H|T], FullList) ->
	[H, <<",">>] ++ smash_iolist(T, FullList).

-spec(iolist_to_json_array_iolist(iolist()) -> iolist()).
iolist_to_json_array_iolist(List) ->
	FullList = [<<"[">>] ++ smash_iolist(List, []) ++ [<<"]">>],
	lists:flatten(FullList).