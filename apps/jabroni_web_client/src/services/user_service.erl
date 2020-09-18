-module(user_service).

-export([valid_login/2, get_all_public_users/1]).

-spec(valid_login(Email::binary(), Pdub::binary()) -> boolean()).
valid_login(Email, Pdub) ->
	case user_model:find_by_email(Email) of
		{ok, {some, User}} ->
			IsValid = user_model:verify_pdub(Pdub, user_model:pw_hash(User)),
			IsValid;
		_ ->
			false
	end.

-spec(get_all_public_users(CurrentUserId::number()) -> list(public_user_model:public_user())).
get_all_public_users(CurrentUserId) ->
	{ok, Users} = user_model:find_all(),
	lists:map(fun(U) -> public_user_model:of_user(U, CurrentUserId) end, Users).
