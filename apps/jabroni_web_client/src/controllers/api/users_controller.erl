-module(users_controller).

-export([init/2]).

-type req() :: cowboy_req:req().

-spec(init(req(), any()) -> {ok, req(), any()}).
init(Req0, State) ->
	case cowboy_req:method(Req0) of
		<<"GET">> ->
			case session_service:of_req(Req0) of
				{some, Session} ->
					CurrentUserId = session_model:user_id(Session),
					PublicUsers = user_service:get_all_public_users(CurrentUserId),
					EncodedPublicUsers = public_user_model:list_to_json(PublicUsers),
					Req = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, EncodedPublicUsers, Req0),
					{ok, Req, State};
				none ->
					Req = cowboy_req:reply(400, #{<<"content-type">> => <<"text/plain">>}, <<"BAD REQUEST">>, Req0),
					{ok, Req, State}
			end;
		_ ->
			Req = cowboy_req:reply(404, #{<<"content-type">> => <<"text/plain">>}, <<"NOT FOUND">>, Req0),
			{ok, Req, State}
	end.