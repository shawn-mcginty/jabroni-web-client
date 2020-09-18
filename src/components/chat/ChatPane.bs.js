'use strict';

var List = require("bs-platform/lib/js/list.js");
var $$Array = require("bs-platform/lib/js/array.js");
var Curry = require("bs-platform/lib/js/curry.js");
var React = require("react");
var Js_json = require("bs-platform/lib/js/js_json.js");
var PublicUser$JabroniWebClient = require("../../PublicUser.bs.js");
var ChatMessage$JabroniWebClient = require("../../messaging/ChatMessage.bs.js");
var WebSocketBus$JabroniWebClient = require("../../messaging/WebSocketBus.bs.js");
var ChatMessageDisplay$JabroniWebClient = require("./ChatMessageDisplay.bs.js");

function ChatPane(Props) {
  var ws = Props.ws;
  var isConnected = Props.isConnected;
  var match = React.useState(function () {
        return "";
      });
  var setCurrentMessage = match[1];
  var currentMessage = match[0];
  var match$1 = React.useState(function () {
        return [];
      });
  var setChatMessages = match$1[1];
  var chatMessages = match$1[0];
  var match$2 = React.useState(function () {
        
      });
  var setCurrentUser = match$2[1];
  var currentUser = match$2[0];
  var match$3 = React.useState(function () {
        return /* [] */0;
      });
  var setUserList = match$3[1];
  React.useEffect((function () {
          fetch("/api/users").then(function (res) {
                    console.log(res);
                    if (res.ok) {
                      return res.json();
                    } else {
                      return Promise.reject({
                                  RE_EXN_ID: "Not_found"
                                });
                    }
                  }).then(function (usersJsonAr) {
                  console.log(usersJsonAr);
                  var usersJson = Js_json.decodeArray(usersJsonAr);
                  if (usersJson === undefined) {
                    return Promise.reject({
                                RE_EXN_ID: "Not_found"
                              });
                  }
                  console.log(usersJson);
                  var users = $$Array.to_list($$Array.map(PublicUser$JabroniWebClient.decode, usersJson));
                  var currentUser = List.find_opt(PublicUser$JabroniWebClient.isCurrentUser, users);
                  Curry._1(setCurrentUser, (function (param) {
                          return currentUser;
                        }));
                  console.log("Set users");
                  console.log(users);
                  Curry._1(setUserList, (function (param) {
                          return users;
                        }));
                  WebSocketBus$JabroniWebClient.on("chat_msg_ack", (function (msg) {
                          console.log(msg);
                          console.log("^ msg");
                          var chatMessage = ChatMessage$JabroniWebClient.make(msg, users);
                          return Curry._1(setChatMessages, (function (msgs) {
                                        return $$Array.append(msgs, [chatMessage]);
                                      }));
                        }), ws);
                  return Promise.resolve(undefined);
                }).catch(function (e) {
                return Promise.resolve((console.error(e), undefined));
              });
          
        }), []);
  var match$4 = chatMessages.length;
  return React.createElement("div", {
              className: "h-full flex flex-col"
            }, React.createElement("div", {
                  className: "flex-grow min-h-0 overflow-auto pl-4"
                }, match$4 !== 0 ? $$Array.map((function (chatMsg) {
                          return React.createElement(ChatMessageDisplay$JabroniWebClient.make, {
                                      author: chatMsg.author,
                                      body: chatMsg.body,
                                      ts: chatMsg.createdOn.toLocaleTimeString()
                                    });
                        }), chatMessages) : React.createElement("div", undefined, "🌵 Chat be empty y\'all.")), React.createElement("div", {
                  className: "p-4"
                }, React.createElement("div", {
                      className: "border-gray-700 rounded flex p-2 border"
                    }, React.createElement("input", {
                          className: "flex-grow focus:outline-none",
                          placeholder: "Message #general...",
                          type: "text",
                          value: currentMessage,
                          onChange: (function (e) {
                              var txt = e.currentTarget.value;
                              return Curry._1(setCurrentMessage, (function (param) {
                                            return txt;
                                          }));
                            })
                        }), React.createElement("button", {
                          disabled: !isConnected,
                          type: "button",
                          onClick: (function (param) {
                              if (currentUser !== undefined) {
                                WebSocketBus$JabroniWebClient.emit("chat_msg", currentUser, currentMessage, ws);
                              } else {
                                console.error("No current user... someting isn't right. Can not send message.");
                              }
                              return Curry._1(setCurrentMessage, (function (param) {
                                            return "";
                                          }));
                            })
                        }, "Send"))));
}

var make = ChatPane;

exports.make = make;
/* react Not a pure module */
