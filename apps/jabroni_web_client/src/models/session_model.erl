-module(session_model).

-record(session, {sid::binary(), user_id::number(), expiry::calendar:datetime()}).

-export([clear_expired/0, find_by_sid/1, sid/1, user_id/1, expiry/1, touch/1, delete/1, create/2]).

-opaque session() :: #session{}.

-export_type([session/0]).

-define(SESSION_COLUMNS, "sid, user_id, expiry").

-spec(sid(session()) -> binary()).
sid(#session{sid = Sid}) -> Sid.

-spec(user_id(session()) -> number()).
user_id(#session{user_id = UserId}) -> UserId.

-spec(expiry(session()) -> calendar:datetime()).
expiry(#session{expiry = Expiry}) -> Expiry.

row_to_session_model(Row) ->
	{Sid, UserId, Expiry} = Row,
	#session{sid=Sid, user_id=UserId, expiry=Expiry}.

to_session_model(Rows) ->
	case length(Rows) of
		0 -> none;
		_ ->
			[FirstRow|_] = Rows,
			Session = row_to_session_model(FirstRow),
			{some, Session}
	end.

-spec(find_by_sid(Sid::binary()) -> {ok, monads:option(session())}).
find_by_sid(Sid) ->
	{ok, _Cols, Rows} = pgapp:equery("select " ++ ?SESSION_COLUMNS ++ " from sessions where sid = $1", [Sid]),
	MaybeSession = to_session_model(Rows),
	{ok, MaybeSession}.

-spec(clear_expired() -> ok).
clear_expired() ->
	{ok, _} = pgapp:squery("DELETE FROM sessions WHERE expiry <= NOW()"),
	ok.

-spec(touch(Sid::binary()) -> ok).
touch(Sid) ->
	{ok, _} = pgapp:equery("UPDATE sessions SET expiry = NOW + interval '30 days'", [Sid]),
	ok.

-spec(delete(Sid::binary()) -> ok).
delete(Sid) ->
	{ok, _} = pgapp:equery("DELETE FROM sessions WHERE sid = $1", [Sid]),
	ok.

-spec(create(Sid::binary(), UserId::number()) -> session()).
create(Sid, UserId) ->
	{ok, _Count, _Cols, Rows} = pgapp:equery("INSERT INTO sessions (" ++ ?SESSION_COLUMNS ++ ") values($1, $2, NOW() + interval '30 days') returning " ++ ?SESSION_COLUMNS, [Sid, UserId]),
	{some, Session} = to_session_model(Rows),
	Session.
