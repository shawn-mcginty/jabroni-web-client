

[@react.component]
let make = (~ws, ~isConnected) => {
	let chatPlaceholder = "Message #general...";
	let (currentMessage, setCurrentMessage) = React.useState(() => "");
	let (chatMessages, setChatMessages) = React.useState(() => [||]);
	let (currentUser, setCurrentUser) = React.useState(() => None);
	let (_userList, setUserList) = React.useState(() => []);
	React.useEffect0(() => {
		let _ = Fetch.fetch("/api/users")
			|> Js.Promise.then_((res) => {
				Js.Console.log(res);
				switch (Fetch.Response.ok(res)) {
					| true => Fetch.Response.json(res)
					| false => Js.Promise.reject(Not_found)
				}
			})
			|> Js.Promise.then_((usersJsonAr) => {
				Js.Console.log(usersJsonAr);
				switch (Js.Json.decodeArray(usersJsonAr)) {
					| None => Js.Promise.reject(Not_found)
					| Some(usersJson) =>
						Js.Console.log(usersJson);
						let users = usersJson
							|> Array.map(PublicUser.decode)
							|> Array.to_list;

						let currentUser = users
							|> List.find_opt(PublicUser.isCurrentUser);
						
						setCurrentUser(_ => currentUser)
						Js.Console.log("Set users");
						Js.Console.log(users);
						setUserList(_ => users);

						let _ = WebSocketBus.on("chat_msg_ack", (msg) => {
							Js.Console.log(msg);
							Js.Console.log("^ msg");
							let chatMessage = ChatMessage.make(msg, users);
							setChatMessages(msgs => Array.append(msgs, [|chatMessage|]));
						}, ws);
						Js.Promise.resolve();
				}
			})
			|> Js.Promise.catch(e => Js.Console.error(e) |> Js.Promise.resolve);
		None;
	});
	<div className="h-full flex flex-col">
		<div className="flex-grow min-h-0 overflow-auto pl-4">{
			switch (Array.length(chatMessages)) {
				| 0 => <div>{React.string({js|🌵 Chat be empty y'all.|js})}</div>
				| _ => Array.map((chatMsg: ChatMessage.t) => {
						<ChatMessageDisplay author={chatMsg.author} body={chatMsg.body} ts={Js.Date.toLocaleTimeString(chatMsg.createdOn)} />
					}, chatMessages) |> React.array
			}}
		</div>
		<div className="p-4">
			<div className="border-gray-700 rounded flex p-2 border">
				<input
					type_="text"
					className="flex-grow focus:outline-none"
					placeholder={chatPlaceholder}
					onChange={(e) => {
						let txt = ReactEvent.Form.currentTarget(e)##value;
						setCurrentMessage(_ => txt);
					}}
					value={currentMessage}
				/>
				<button
					type_="button"
					onClick={_ => {
						switch (currentUser) {
							| Some(u) => WebSocketBus.emit("chat_msg", u, currentMessage, ws)
							| None => Js.Console.error("No current user... someting isn't right. Can not send message.");
						}
						setCurrentMessage(_ => "");
					}}
					disabled={!isConnected}
				>
					{React.string("Send")}
				</button>
			</div>
		</div>
	</div>
};
