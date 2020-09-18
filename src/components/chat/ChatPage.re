[@react.component]
let make = (~ws) => {
	let (isConnected, setIsConnected) = React.useState(() => false);
	let (connClasses, connText) = switch (isConnected) {
		| true => ("text-green-700", "Connected")
		| false => ("text-red-800 font-bold", "Not Connected")
	};
	React.useEffect0(() => {
		let _ = WebSocketBus.on("ack", (msg) => {
			switch (msg) {
				| "connected" => setIsConnected(_ => true)
				| _ => ()
			}
		}, ws);
		None;
	});
	<div className="h-full flex flex-col">
		<div className="p-4 shadow">
			<span className={connClasses}>{React.string(connText)}</span>
		</div>
		<div className="flex-grow">
			<ChatPane ws isConnected/>
		</div>
	</div>
};