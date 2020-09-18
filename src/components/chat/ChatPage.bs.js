'use strict';

var Curry = require("bs-platform/lib/js/curry.js");
var React = require("react");
var ChatPane$JabroniWebClient = require("./ChatPane.bs.js");
var WebSocketBus$JabroniWebClient = require("../../messaging/WebSocketBus.bs.js");

function ChatPage(Props) {
  var ws = Props.ws;
  var match = React.useState(function () {
        return false;
      });
  var setIsConnected = match[1];
  var isConnected = match[0];
  var match$1 = isConnected ? [
      "text-green-700",
      "Connected"
    ] : [
      "text-red-800 font-bold",
      "Not Connected"
    ];
  React.useEffect((function () {
          WebSocketBus$JabroniWebClient.on("ack", (function (msg) {
                  if (msg === "connected") {
                    return Curry._1(setIsConnected, (function (param) {
                                  return true;
                                }));
                  }
                  
                }), ws);
          
        }), []);
  return React.createElement("div", {
              className: "h-full flex flex-col"
            }, React.createElement("div", {
                  className: "p-4 shadow"
                }, React.createElement("span", {
                      className: match$1[0]
                    }, match$1[1])), React.createElement("div", {
                  className: "flex-grow"
                }, React.createElement(ChatPane$JabroniWebClient.make, {
                      ws: ws,
                      isConnected: isConnected
                    })));
}

var make = ChatPage;

exports.make = make;
/* react Not a pure module */
