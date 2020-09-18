type registrationError = {
	badFields: list(string),
	message: string
};

let registerUrl = "/registration";

let registerUser = (email, pdub, pdub2, display, handle) => {
	let regJsonObj = Js.Dict.fromArray([|
		("email", Js.Json.string(email)),
		("pdub", Js.Json.string(pdub)),
		("pdub2", Js.Json.string(pdub2)),
		("display", Js.Json.string(display)),
		("handle", Js.Json.string(handle)),
	|]);
	let request = Fetch.RequestInit.make(
		~method_=Fetch.Post,
		~headers=Fetch.HeadersInit.makeWithArray([|("content-type", "application/json")|]),
		~body=Fetch.BodyInit.make(Js.Json.stringify(Js.Json.object_(regJsonObj))),
		());
	Js.Promise.(
		Fetch.fetchWithInit(registerUrl, request)
			|> then_((res) => {
				switch (Fetch.Response.ok(res)) {
					| true => 
						let json = Js.Dict.fromArray([|("status", Js.Json.string("ok"))|]);
						Js.Json.object_(json) |> resolve;
					| false =>
						Fetch.Response.json(res)
				}
			})
			|> then_((resJson) => {
				switch (Js.Json.decodeObject(resJson)) {
					| None =>
						Error({
							badFields: [],
							message: "An uknown error happened. Whoops! Try again later."
						}) |> resolve;
					| Some(res) =>
						switch ((Js.Dict.get(res, "status"), Js.Dict.get(res, "badFields"), Js.Dict.get(res, "message"))) {
							| (Some(_), _, _) => Ok(()) |> resolve
							| (_, Some(badFieldsJs), Some(messageJs)) =>
								switch ((Js.Json.decodeArray(badFieldsJs), Js.Json.decodeString(messageJs))) {
									| (Some(badFieldsAr), Some(message)) =>
										Error({
											message,
											badFields: Array.to_list(badFieldsAr)
												|> List.map((s) => switch (Js.Json.decodeString(s)) {
													| None => ""
													| Some(str) => str
												})
										}) |> resolve
									| _ => Error({
										badFields: [],
										message: "An uknown error happened. Whoops! Try again later."
										}) |> resolve
								}
							| _ =>
								Error({
									badFields: [],
									message: "An uknown error happened. Whoops! Try again later."
									}) |> resolve
						}
				}
			})
			|> catch((err) => {
				Js.Console.error(err);
				Error({
					badFields: [],
					message: "An uknown error happened. Whoops! Try again later.",
				}) |> resolve;
			})
	);
};