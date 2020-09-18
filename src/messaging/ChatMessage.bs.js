'use strict';

var $$String = require("bs-platform/lib/js/string.js");
var Caml_format = require("bs-platform/lib/js/caml_format.js");
var PublicUser$JabroniWebClient = require("../PublicUser.bs.js");

function popMessageItem(msg) {
  var sepIndex = $$String.index(msg, /* "|" */124);
  var len = msg.length;
  var item = $$String.sub(msg, 0, sepIndex);
  var charAfterSepIndex = sepIndex + 1 | 0;
  var rest = len > sepIndex ? $$String.sub(msg, charAfterSepIndex, len - charAfterSepIndex | 0) : "";
  return [
          item,
          rest
        ];
}

function popMessageItemFloat(msg) {
  var match = popMessageItem(msg);
  return [
          Caml_format.caml_float_of_string(match[0]),
          match[1]
        ];
}

function popMessageItemInt(msg) {
  var match = popMessageItem(msg);
  return [
          Caml_format.caml_int_of_string(match[0]),
          match[1]
        ];
}

function parseMessage(msg) {
  var match = popMessageItemFloat(msg);
  var match$1 = popMessageItemInt(match[1]);
  return [
          match[0],
          match$1[0],
          match$1[1]
        ];
}

function make(msg, users) {
  var match = parseMessage(msg);
  var body = match[2];
  var authorId = match[1];
  var date = match[0];
  console.log(date);
  console.log(authorId);
  console.log(body);
  console.log(users);
  return {
          body: body,
          author: PublicUser$JabroniWebClient.find_with_default((function (u) {
                  console.log("--");
                  console.log(authorId);
                  console.log(PublicUser$JabroniWebClient.id(u));
                  return PublicUser$JabroniWebClient.id(u) === authorId;
                }), users),
          createdOn: new Date(date)
        };
}

exports.popMessageItem = popMessageItem;
exports.popMessageItemFloat = popMessageItemFloat;
exports.popMessageItemInt = popMessageItemInt;
exports.parseMessage = parseMessage;
exports.make = make;
/* No side effect */
