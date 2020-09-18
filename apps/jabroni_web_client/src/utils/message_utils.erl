-module(message_utils).

-export([pop_message_part/1]).

-type message_parts() :: {string() | binary(), string() | binary()}.

-spec pop_message_part(string() | binary()) -> message_parts().
pop_message_part("") ->
	{"", ""};
pop_message_part(Msg) ->
	case string:find(Msg, "|") of
		nomatch -> {"", Msg};
		_ ->
			[Part, Rest] = string:split(Msg, "|"),
			{Part, Rest}
	end.
