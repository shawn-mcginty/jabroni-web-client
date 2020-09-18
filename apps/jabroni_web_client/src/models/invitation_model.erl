-module(invitation_model).

-export([count_by_email/1]).

-spec(count_by_email(Email::binary()) -> number()).
count_by_email(Email) ->
	{ok, _Cols, Rows} = pgapp:equery("select * from invitations where invited_email = $1", [Email]),
	Count = length(Rows),
	Count.
