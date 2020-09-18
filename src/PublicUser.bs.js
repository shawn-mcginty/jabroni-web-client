'use strict';

var List = require("bs-platform/lib/js/list.js");
var Json_decode = require("@glennsl/bs-json/src/Json_decode.bs.js");

function make(id, display, handle, isCurrentUser) {
  return {
          display: display,
          id: id,
          handle: handle,
          isCurrentUser: isCurrentUser
        };
}

function id(user) {
  return user.id;
}

function display(user) {
  return user.display;
}

function handle(user) {
  return user.handle;
}

function isCurrentUser(user) {
  return user.isCurrentUser;
}

function decode(userJson) {
  return {
          display: Json_decode.field("display", Json_decode.string, userJson),
          id: Json_decode.field("id", Json_decode.$$int, userJson),
          handle: Json_decode.field("handle", Json_decode.string, userJson),
          isCurrentUser: Json_decode.field("isCurrentUser", Json_decode.bool, userJson)
        };
}

function find_with_default(pred, users) {
  var u = List.find_opt(pred, users);
  if (u !== undefined) {
    return u;
  } else {
    return {
            display: "Unknown User",
            id: -1,
            handle: "unknown_user",
            isCurrentUser: false
          };
  }
}

exports.make = make;
exports.id = id;
exports.display = display;
exports.handle = handle;
exports.isCurrentUser = isCurrentUser;
exports.decode = decode;
exports.find_with_default = find_with_default;
/* No side effect */
