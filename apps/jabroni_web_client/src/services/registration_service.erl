-module(registration_service).

-export([register/4]).

-spec(register(Email::binary(), Pdub::binary(), Handle::binary(), Display::binary()) -> ok | {error, binary()}).
register(Email, Pdub, Handle, Display) ->
	case invitation_model:count_by_email(Email) of
		0 -> {error, <<"{\"badFields\":[],\"message\":\"This email has not received an invitation.\"}">>};
		_ -> 
			{ok, ExistingEmail} = user_model:find_by_email(Email),
			{ok, ExistingHandle} = user_model:find_by_handle(Handle),
			case {ExistingEmail, ExistingHandle} of
				{{some, _}, _} -> {error, <<"{\"badFields\":[\"email\"],\"message\":\"This email has already been registered.\"}">>};
				{_, {some, _}} -> {error, <<"{\"badFields\":[\"handle\"],\"message\":\"This handle has already been registered.\"}">>};
				{none, none} ->
					user_model:create(Email, Pdub, Handle, Display),
					ok
			end
	end.
