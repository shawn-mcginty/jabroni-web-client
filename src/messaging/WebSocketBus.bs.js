'use strict';

var List = require("bs-platform/lib/js/list.js");
var Curry = require("bs-platform/lib/js/curry.js");
var $$String = require("bs-platform/lib/js/string.js");
var BsWebSocket = require("@ryb73/bs-websockets/src/BsWebSocket.js");
var PublicUser$JabroniWebClient = require("../PublicUser.bs.js");

function make(url) {
  var ws = BsWebSocket.make(undefined, url);
  var bus = {
    ws: ws,
    handlerId: 1,
    onOpen: /* [] */0,
    onClose: /* [] */0,
    onMessage: /* [] */0,
    onError: {
      hd: [
        0,
        (function (e) {
            console.error(e);
            
          })
      ],
      tl: /* [] */0
    }
  };
  BsWebSocket.onOpen(bus.ws, (function (e) {
          return List.iter((function (param) {
                        return Curry._1(param[1], e);
                      }), bus.onOpen);
        }));
  BsWebSocket.onClose(bus.ws, (function (e) {
          return List.iter((function (param) {
                        return Curry._1(param[1], e);
                      }), bus.onClose);
        }));
  BsWebSocket.onMessage(bus.ws, (function (e) {
          return List.iter((function (param) {
                        return Curry._1(param[1], e);
                      }), bus.onMessage);
        }));
  BsWebSocket.onError(bus.ws, (function (e) {
          return List.iter((function (param) {
                        return Curry._1(param[1], e);
                      }), bus.onError);
        }));
  return bus;
}

function on(ns, handlerFn, bus) {
  var id = bus.handlerId;
  bus.handlerId = bus.handlerId + 1 | 0;
  var handler = function (e) {
    var msg = BsWebSocket.$$MessageEvent.data(e);
    var splitterIdx = $$String.index(msg, /* "|" */124);
    var msgNamespace = $$String.sub(msg, 0, splitterIdx);
    var msgBody = msg.length > splitterIdx ? $$String.sub(msg, splitterIdx + 1 | 0, msg.length - (splitterIdx + 1 | 0) | 0) : "";
    if (msgNamespace === ns) {
      return Curry._1(handlerFn, msgBody);
    }
    
  };
  bus.onMessage = {
    hd: [
      id,
      handler
    ],
    tl: bus.onMessage
  };
  return id;
}

function off(id, bus) {
  bus.onMessage = List.filter(function (param) {
          return id !== param[0];
        })(bus.onMessage);
  
}

function emit(ns, author, body, bus) {
  var dateStr = new Date().getTime().toString();
  var message = ns + ("|" + (dateStr + ("|" + (String(PublicUser$JabroniWebClient.id(author)) + ("|" + body)))));
  return BsWebSocket.send(bus.ws, message);
}

exports.make = make;
exports.on = on;
exports.off = off;
exports.emit = emit;
/* No side effect */
