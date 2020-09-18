-module(registration_controller).

-export([init/2]).

-type req() :: cowboy_req:req().

is_pdub_valid(Pdub) ->
	length(binary_to_list(Pdub)) >= 10.

is_email_valid(Email) ->
	length(binary_to_list(Email)) >= 3.

is_display_valid(Display) ->
	length(binary_to_list(Display)) > 0.

is_handle_valid(Handle) ->
	case length(binary_to_list(Handle)) > 0 of
		true ->
			{ok, NonValidRE} = re:compile(<<"[^a-zA-Z0-9\\_\\-]">>),
			case re:run(Handle, NonValidRE) of
				nomatch ->
					true;
				_ ->
					false
			end;
		false -> false
	end.

-spec(validate_fields(binary(), binary(), binary(), binary(), binary()) -> ok | {error, binary()}).
validate_fields(Email, Pdub, Pdub2, Handle, Display) ->
	case {Pdub == Pdub2, is_pdub_valid(Pdub), is_email_valid(Email), is_handle_valid(Handle), is_display_valid(Display)} of
		{true, true, true, true, true} -> ok;
		{false, _, _, _, _} -> {error, <<"{\"badFields\":[\"pdub\",\"pdub2\"],\"message\":\"Password fields do not match.\"}">>};
		{_, false, _, _, _} -> {error, <<"{\"badFields\":[\"pdub\",\"pdub2\"],\"message\":\"Password must be at least 10 characters long. It's up to you to make it strong.\"}">>};
		{_, _, false, _, _} -> {error, <<"{\"badFields\":[\"email\"],\"message\":\"Email must be a valid email.\"}">>};
		{_, _, _, false, _} -> {error, <<"{\"badFields\":[\"handle\"],\"message\":\"Handle can't be left blank and it must only contain alphanumeric characters, underscores, and dashes.\"}">>};
		{_, _, _, _, false} -> {error, <<"{\"badFields\":[\"display\"],\"message\":\"Display can't be left blank.\"}">>}
	end.


-spec(register_user(binary(), binary(), binary(), binary(), binary()) -> ok | {error, binary()}).
register_user(Email, Pdub, Pdub2, Handle, Display) ->
	case validate_fields(Email, Pdub, Pdub2, Handle, Display) of
		ok -> registration_service:register(Email, Pdub, Handle, Display);
		Error -> Error
	end.

-spec(init(req(), any()) -> {ok, req(), any()}).
init(Req0, State) ->
	case cowboy_req:method(Req0) of
		<<"POST">> ->
			{ok, Data, Req} = cowboy_req:read_body(Req0),
			Json = json_utils:parse(Data),
			Email = maps:get(<<"email">>, Json),
			Pdub = maps:get(<<"pdub">>, Json),
			Pdub2 = maps:get(<<"pdub2">>, Json),
			Handle = maps:get(<<"handle">>, Json),
			Display = maps:get(<<"display">>, Json),
			case register_user(Email, Pdub, Pdub2, Handle, Display) of
				ok ->
					Req2 = cowboy_req:reply(201, #{<<"content-type">> => <<"text/plain">>}, <<"CREATED">>, Req),
					{ok, Req2, State};
				{error, Payload} ->
					Req2 = cowboy_req:reply(400, #{<<"content-type">> => <<"application/json">>}, Payload, Req),
					{ok, Req2, State}
				end;
		_ ->
			Req = cowboy_req:reply(404, #{<<"content-type">> => <<"text/plain">>}, <<"NOT FOUND">>, Req0),
			{ok, Req, State}
	end.