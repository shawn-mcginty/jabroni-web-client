-module(public_user_model).

-export([of_user/2, of_user/1, to_json/1, list_to_json/1]).

-record(public_user, {id::number(), display::binary(), handle::binary(), is_current_user::boolean()}).

-opaque public_user() :: #public_user{}.

-export_type([public_user/0]).

-spec(of_user(User::user_model:user()) -> public_user()).
of_user(User) ->
	#public_user{
		id=user_model:id(User),
		display=user_model:display(User),
		handle=user_model:handle(User),
		is_current_user=false
	}.

-spec(of_user(User::user_model:user(), CurrentUserId::number()) -> public_user()).
of_user(User, CurrentUserId) ->
	IsCurrentUser = user_model:id(User) == CurrentUserId,
	#public_user{
		id=user_model:id(User),
		display=user_model:display(User),
		handle=user_model:handle(User),
		is_current_user=IsCurrentUser
	}.

-spec(to_json(PublicUser::public_user()) -> iolist()).
to_json(PublicUser) ->
	[
		<<"{">>,
		<<"\"id\":">>, list_to_binary(integer_to_list(PublicUser#public_user.id)), <<",">>,
		<<"\"display\":\"">>, PublicUser#public_user.display, <<"\",">>,
		<<"\"handle\":\"">>, PublicUser#public_user.handle, <<"\",">>,
		<<"\"isCurrentUser\":">>, list_to_binary(atom_to_list(PublicUser#public_user.is_current_user)),
		<<"}">>
	].

-spec(list_to_json(PublicUsers::list(public_user())) -> iolist()).
list_to_json(PublicUsers) ->
	JsonUsers = lists:map(fun (U) -> to_json(U) end, PublicUsers),
	json_utils:iolist_to_json_array_iolist(JsonUsers).
