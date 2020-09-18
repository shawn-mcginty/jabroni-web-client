type t = {
	body: string,
	author: PublicUser.t,
	createdOn: Js.Date.t,
};

let popMessageItem = (msg) => {
	let sepIndex = String.index(msg, '|');
	let len = String.length(msg);

	let item = String.sub(msg, 0, sepIndex);
	let charAfterSepIndex = sepIndex + 1;

	let rest = switch (len > sepIndex) {
		| true => String.sub(msg, charAfterSepIndex, len - charAfterSepIndex)
		| false => ""
	};
	(item, rest);
};

let popMessageItemFloat = (msg) => {
	let (floatStr, rest) = popMessageItem(msg);
	(float_of_string(floatStr), rest);
};

let popMessageItemInt = (msg) => {
	let (intStr, rest) = popMessageItem(msg);
	(int_of_string(intStr), rest);
};

let parseMessage = (msg) => {
	let (date, restMsg0) = popMessageItemFloat(msg);
	let (authorId, body) = popMessageItemInt(restMsg0);
	(date, authorId, body);
};

let make = (msg, users: list(PublicUser.t)) => {
	let (date, authorId, body) = parseMessage(msg);
	Js.Console.log(date);
	Js.Console.log(authorId);
	Js.Console.log(body);
	Js.Console.log(users);
	{
		body: body,
		author: PublicUser.find_with_default((u => {
			Js.Console.log("--");
			Js.Console.log(authorId);
			Js.Console.log(PublicUser.id(u));
			PublicUser.id(u) == authorId
		}), users),
		createdOn: Js.Date.fromFloat(date),
	};
};
