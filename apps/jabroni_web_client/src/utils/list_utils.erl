-module(list_utils).

-export([index_of/2]).

idx(_Pred, [], _) -> none;
idx(Pred, [H|Tail], Index) ->
	case Pred(H) of
		true -> {some, Index};
		false -> idx(Pred, Tail, Index + 1)
	end.

-spec(index_of(Pred::fun((A) -> boolean()), Ls::list(A)) -> monads:option(number())).
index_of(_Pred, []) ->
	none;
index_of(Pred, Ls) ->
	idx(Pred, Ls, 0).