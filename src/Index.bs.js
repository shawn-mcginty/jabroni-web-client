'use strict';

var React = require("react");
var ReactDOMRe = require("reason-react/src/legacy/ReactDOMRe.bs.js");
var ChatPage$JabroniWebClient = require("./components/chat/ChatPage.bs.js");
var Location$JabroniWebClient = require("./utils/Location.bs.js");
var WebSocketBus$JabroniWebClient = require("./messaging/WebSocketBus.bs.js");

require('./styles/main.css');
;

var match = Location$JabroniWebClient.protocol(undefined);

var wsProto = match === "https" ? "wss" : "ws";

var wsUrl = wsProto + ("://" + (Location$JabroniWebClient.host(undefined) + "/ws"));

var ws = WebSocketBus$JabroniWebClient.make(wsUrl);

ReactDOMRe.renderToElementWithId(React.createElement(ChatPage$JabroniWebClient.make, {
          ws: ws
        }), "app");

exports.wsProto = wsProto;
exports.wsUrl = wsUrl;
exports.ws = ws;
/*  Not a pure module */
