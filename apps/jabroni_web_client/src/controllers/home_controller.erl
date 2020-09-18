-module(home_controller).

-export([init/2]).

-type req() :: cowboy_req:req().
%% -type reason() :: normal | {crash, error | exit | throw, any()}.

-define(HOME_MARKUP,
	<<"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><title>Jabroni</title></head><body><section id=\"app\"></section><script src=\"/static/js/index.js\"></script></body></html>">>).

-spec(init(req(), any()) -> {ok, req(), any()}).
init(Req0, State) ->
	case cowboy_req:method(Req0) of
		<<"GET">> ->
			Req = cowboy_req:reply(200,
				#{<<"content-type">> => <<"text/html">>},
				?HOME_MARKUP,
				Req0
			),
			{ok, Req, State};
		_ ->
			Req = cowboy_req:reply(404, #{<<"content-type">> => <<"text/plain">>}, <<"NOT FOUND">>, Req0),
			{ok, Req, State}
	end.