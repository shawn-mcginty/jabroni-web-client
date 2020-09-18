[%%raw{|require('./styles/main.css');|}];

let wsProto = switch(Location.protocol()) {
	| "https" => "wss"
	| _ => "ws"
};

let wsUrl = wsProto ++ "://" ++ Location.host() ++ "/ws";

let ws = WebSocketBus.make(wsUrl);

// Entry point
ReactDOMRe.renderToElementWithId(<ChatPage ws=ws/>, "app");
