type t = {
	ws: BsWebSocket.t,
	mutable handlerId: int,
	mutable onOpen: list((int, BsWebSocket.OpenEvent.t => unit)),
	mutable onClose: list((int, BsWebSocket.CloseEvent.t => unit)),
	mutable onMessage: list((int, BsWebSocket.MessageEvent.t => unit)),
	mutable onError: list((int, BsWebSocket.ErrorEvent.t => unit)),
}

let make = url => {
	let ws = BsWebSocket.make(url);
	let bus = {
		ws,
		handlerId: 1,
		onOpen: [],
		onClose: [],
		onMessage: [],
		onError: [(0, e => Js.Console.error(e))],
	};

	BsWebSocket.onOpen(bus.ws, (e) => {
		List.iter((((_, fn)) => fn(e)), bus.onOpen);
	});

	BsWebSocket.onClose(bus.ws, (e) => {
		List.iter((((_, fn)) => fn(e)), bus.onClose);
	});

	BsWebSocket.onMessage(bus.ws, (e) => {
		List.iter((((_, fn)) => fn(e)), bus.onMessage);
	});

	BsWebSocket.onError(bus.ws, (e) => {
		List.iter((((_, fn)) => fn(e)), bus.onError);
	});

	bus;
};

let on = (ns: string, handlerFn, bus: t) => {
	let id = bus.handlerId;
	bus.handlerId = bus.handlerId + 1;

	let handler = (e) => {
		let msg = BsWebSocket.MessageEvent.data(e);
		let splitterIdx = String.index(msg, '|');
		let msgNamespace = String.sub(msg, 0, splitterIdx);
		let msgBody = switch (String.length(msg) > splitterIdx) {
			| true => String.sub(msg, splitterIdx + 1, String.length(msg) - (splitterIdx + 1))
			| false => ""
		};

		switch (msgNamespace == ns) {
			| true => handlerFn(msgBody)
			| false => ()
		}
	};

	bus.onMessage = [(id, handler), ...bus.onMessage];
	id;
};

let off = (id, bus) => {
	bus.onMessage = List.filter(((fnId, _)) => id != fnId, bus.onMessage);
};

let emit = (ns, author: PublicUser.t, body, bus) => {
	let dateStr = Js.Date.make() |> Js.Date.getTime |> Js.Float.toString;
	let message = ns ++ "|" ++ dateStr ++ "|" ++ string_of_int(PublicUser.id(author)) ++ "|" ++ body;
	BsWebSocket.send(bus.ws, message); 
};
