-module(user_model).

-record(user, {id::number(), display::binary(), handle::binary(), email::binary(), pw_hash::binary(), created_on::calendar:datetime()}).

-export([find_by_id/1, find_by_handle/1, find_by_email/1, create/4, verify_pdub/2, pw_hash/1, id/1, find_all/0, display/1, handle/1]).

-opaque user() :: #user{}.

-export_type([user/0]).

-define(USER_COLUMNS, "id, email, handle, display, password, created_on").

-spec(id(user()) -> number()).
id(#user{id = Id}) -> Id.

-spec(display(user()) -> binary()).
display(#user{display = Display}) -> Display.

-spec(handle(user()) -> binary()).
handle(#user{handle = Handle}) -> Handle.

-spec(pw_hash(user()) -> binary()).
pw_hash(#user{pw_hash = PwHash}) -> PwHash.

-spec(hash_pdub(binary()) -> {ok, string()} | {error, bcrypt:pwerr()}).
hash_pdub(Pdub) ->
	{ok, Salt} = bcrypt:gen_salt(),
	bcrypt:hashpw(binary_to_list(Pdub), Salt).

row_to_user_model(Row) ->
	{Id, Email, Handle, Display, PwHash, CreatedOn} = Row,
	#user{id=list_to_integer(binary_to_list(Id)), display=Display, handle=Handle, email=Email, created_on=CreatedOn, pw_hash=PwHash}.

to_user_model(Rows) ->
	case length(Rows) of
		0 -> none;
		_ ->
			[FirstRow|_] = Rows,
			User = row_to_user_model(FirstRow),
			{some, User}
	end.

-spec(find_by_id(number()) -> {ok, monads:option(user())}).
find_by_id(Id) ->
	{ok, _Cols, Rows} = pgapp:equery("select " ++ ?USER_COLUMNS ++ " from users where id = $1", [Id]),
	MaybeUser = to_user_model(Rows),
	{ok, MaybeUser}.

-spec(find_by_email(binary()) -> {ok, monads:option(user())}).
find_by_email(Email) ->
	{ok, _Cols, Rows} = pgapp:equery("select " ++ ?USER_COLUMNS ++ " from users where email = $1", [Email]),
	MaybeUser = to_user_model(Rows),
	{ok, MaybeUser}.

-spec(find_by_handle(binary()) -> {ok, monads:option(user())}).
find_by_handle(Handle) ->
	{ok, _Cols, Rows} = pgapp:equery("select " ++ ?USER_COLUMNS ++ " from users where handle = $1", [Handle]),
	MaybeUser = to_user_model(Rows),
	{ok, MaybeUser}.

-spec(create(Email::binary(), Pdub::binary(), Handle::binary(), Display::binary()) -> user()).
create(Email, Pdub, Handle, Display) ->
	{ok, Hash} = hash_pdub(Pdub),
	{ok, _Count, _Cols, Rows} = pgapp:equery("insert into users(email, password, handle, display, created_on)
	values($1, $2, $3, $4, NOW()) returning " ++ ?USER_COLUMNS, [Email, Hash, Handle, Display]),
	{some, User} = to_user_model(Rows),
	User.

-spec(verify_pdub(Pdub::binary(), Hash::binary()) -> boolean()).
verify_pdub(Pdub, Hash) ->
	{ok, binary_to_list(Hash)} =:= bcrypt:hashpw(binary_to_list(Pdub), binary_to_list(Hash)).

-spec(find_all() -> {ok, list(user())}).
find_all() ->
	{ok, _Cols, Rows} = pgapp:squery("select " ++ ?USER_COLUMNS ++ " from users"),
	Users = lists:map(fun (R) -> row_to_user_model(R) end, Rows),
	{ok, Users}.
