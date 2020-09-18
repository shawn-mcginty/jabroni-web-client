-module(session_service).

-export([get_browser_sid/1, expire/1, touch/1, create/2, get_valid_session/1, of_req/1]).

-define(COOKIE, <<"jabroni.sid">>).

-spec(get_browser_sid(Req::cowboy_req:req()) -> {cowboy_req:req(), monads:option(binary())}).
get_browser_sid(Req) ->
	Req1 = cowboy_req:filter_cookies([?COOKIE], Req),
	try cowboy_req:parse_cookies(Req1) of
		Cookies ->
			case lists:keyfind(?COOKIE, 1, Cookies) of
				false -> {Req, none};
				{_Key, Sid} -> {Req, {some, Sid}}
			end
	catch _:_ ->
		Req2 = cowboy_req:set_resp_cookie(?COOKIE, <<>>, Req, #{max_age => 0}),
		{Req2, none}
	end.

-spec(expire(Req::cowboy_req:req()) -> cowboy_req:req()).
expire(Req0) ->
	case get_browser_sid(Req0) of
		{Req1, none} -> Req1;
		{Req1, {some, Sid}} ->
			ok = session_model:delete(Sid),
			cowboy_req:set_resp_cookie(?COOKIE, <<>>, Req1, #{max_age => 0})
	end.

-spec(touch(Sid::binary()) -> ok).
touch(Sid) ->
	session_model:touch(Sid).

-spec(create(User::user_model:user(), Req::cowboy_req:req()) -> Req::cowboy_req:req()).
create(User, Req0) ->
	{ok, Salt} = bcrypt:gen_salt(),
	{ok, RawSid} = bcrypt:hashpw(binary_to_list(user_model:pw_hash(User)), Salt),
	Session = session_model:create(list_to_binary(RawSid), user_model:id(User)),
	Req1 = cowboy_req:set_resp_cookie(?COOKIE, session_model:sid(Session), Req0, #{max_age => 2592000}),
	Req1.

-spec(get_valid_session(Sid::binary()) -> monads:option(session_model:session())).
get_valid_session(Sid) ->
	ok = session_model:clear_expired(),
	{ok, MaybeSid} = session_model:find_by_sid(Sid),
	MaybeSid.

-spec(of_req(Req::cowboy_req:req()) -> monads:option(session_model:session())).
of_req(Req) ->
	case get_browser_sid(Req) of
		{_, none} -> none;
		{_, {some, BrowserSid}} ->
			get_valid_session(BrowserSid)
	end.
