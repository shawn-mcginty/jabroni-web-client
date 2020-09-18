-module(session_middleware).

-behaviour(cowboy_middleware).
-export([execute/2]).

-spec(protected_paths() -> list(binary())).
protected_paths() ->
	[
		<<"/">>,
		<<"/ws">>,
		<<"/api/users">>
	].

-spec(has_valid_session(cowboy_req:req()) -> {cowboy_req:req(), boolean()}).
has_valid_session(Req0) ->
	case session_service:get_browser_sid(Req0) of
		{Req1, none} -> {Req1, false};
		{Req1, {some, BrowserSid}} ->
			case session_service:get_valid_session(BrowserSid) of
				none -> {Req1, false};
				{some, _} -> {Req1, true}
			end
	end.

execute(Req0, Env) ->
	#{path := Path} = Req0,
	case lists:any(fun(P) -> P == Path end, protected_paths()) of
		false -> {ok, Req0, Env};
		true -> case has_valid_session(Req0) of
			{Req1, true} -> {ok, Req1, Env};
			{Req1, false} ->
				Req2 = cowboy_req:reply(
					302,
					#{<<"content-type">> => <<"text/plain">>, <<"location">> => <<"/login">>},
					<<"REDIRECT">>,
					Req1),
				{stop, Req2}
			end
	end.