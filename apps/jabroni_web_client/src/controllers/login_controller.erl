-module(login_controller).

-export([init/2]).

-type req() :: cowboy_req:req().
%% -type reason() :: normal | {crash, error | exit | throw, any()}.

-define(LOGIN_MARKUP,
	<<"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><title>Jabroni Log In</title></head><body><section id=\"app\"></section><script src=\"/static/js/login.js\"></script></body></html>">>).

-spec(init(req(), any()) -> {ok, req(), any()}).
init(Req0, State) ->
	case cowboy_req:method(Req0) of
		<<"GET">> ->
			Req = cowboy_req:reply(200,
				#{<<"content-type">> => <<"text/html">>},
				?LOGIN_MARKUP,
				Req0
			),
			{ok, Req, State};
		<<"POST">> ->
			{ok, Body, Req1} = cowboy_req:read_urlencoded_body(Req0),
			{_, Email} = lists:keyfind(<<"email">>, 1, Body),
			{_, Pdub} = lists:keyfind(<<"pdub">>, 1, Body),
			case user_service:valid_login(Email, Pdub) of
				true ->
					case user_model:find_by_email(Email) of
						{ok, none} ->
							Req = cowboy_req:reply(303,
								#{<<"location">> => <<"/login?failed=true">>},
								"",
								Req1),
							{ok, Req, State};
						{ok, {some, User}} ->
							Req2 = session_service:create(User, Req1),
							Req3 = cowboy_req:reply(303,
								#{<<"location">> => <<"/">>},
								"true",
								Req2),
							{ok, Req3, State}
					end;
				false ->
					Req = cowboy_req:reply(303,
						#{<<"location">> => <<"/login?failed=true">>},
						"",
						Req1),
					{ok, Req, State}
			end;
		_ ->
			Req = cowboy_req:reply(404, #{<<"content-type">> => <<"text/plain">>}, <<"NOT FOUND">>, Req0),
			{ok, Req, State}
	end.