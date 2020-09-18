type t = {
	display: string,
	id: int,
	handle: string,
	isCurrentUser: bool,
};

let make = (~id, ~display, ~handle, ~isCurrentUser) => {
	{ id: id, display: display, handle: handle, isCurrentUser: isCurrentUser};
};

let id = user => user.id;

let display = user => user.display;

let handle = user => user.handle;

let isCurrentUser = user => user.isCurrentUser;

let decode = userJson => 
	Json.Decode.{
		id: userJson |> field("id", int),
		display: userJson |> field("display", string),
		handle: userJson |> field("handle", string),
		isCurrentUser: userJson |> field("isCurrentUser", bool)
	};

let find_with_default = (pred, users: list(t)) => switch (List.find_opt(pred, users)) {
	| None => { id: -1, handle: "unknown_user", display: "Unknown User", isCurrentUser: false }
	| Some(u) => u
};
