'use strict';

var List = require("bs-platform/lib/js/list.js");
var $$Array = require("bs-platform/lib/js/array.js");
var Fetch = require("bs-fetch/src/Fetch.js");
var Js_dict = require("bs-platform/lib/js/js_dict.js");
var Js_json = require("bs-platform/lib/js/js_json.js");
var Caml_option = require("bs-platform/lib/js/caml_option.js");

var registerUrl = "/registration";

function registerUser(email, pdub, pdub2, display, handle) {
  var regJsonObj = Js_dict.fromArray([
        [
          "email",
          email
        ],
        [
          "pdub",
          pdub
        ],
        [
          "pdub2",
          pdub2
        ],
        [
          "display",
          display
        ],
        [
          "handle",
          handle
        ]
      ]);
  var request = Fetch.RequestInit.make(/* Post */2, [[
            "content-type",
            "application/json"
          ]], Caml_option.some(JSON.stringify(regJsonObj)), undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)(undefined);
  return fetch(registerUrl, request).then(function (res) {
                  if (res.ok) {
                    return Promise.resolve(Js_dict.fromArray([[
                                      "status",
                                      "ok"
                                    ]]));
                  } else {
                    return res.json();
                  }
                }).then(function (resJson) {
                var res = Js_json.decodeObject(resJson);
                if (res === undefined) {
                  return Promise.resolve({
                              TAG: /* Error */1,
                              _0: {
                                badFields: /* [] */0,
                                message: "An uknown error happened. Whoops! Try again later."
                              }
                            });
                }
                var res$1 = Caml_option.valFromOption(res);
                var match = Js_dict.get(res$1, "status");
                var match$1 = Js_dict.get(res$1, "badFields");
                var match$2 = Js_dict.get(res$1, "message");
                if (match !== undefined) {
                  return Promise.resolve({
                              TAG: /* Ok */0,
                              _0: undefined
                            });
                }
                if (match$1 === undefined) {
                  return Promise.resolve({
                              TAG: /* Error */1,
                              _0: {
                                badFields: /* [] */0,
                                message: "An uknown error happened. Whoops! Try again later."
                              }
                            });
                }
                if (match$2 === undefined) {
                  return Promise.resolve({
                              TAG: /* Error */1,
                              _0: {
                                badFields: /* [] */0,
                                message: "An uknown error happened. Whoops! Try again later."
                              }
                            });
                }
                var match$3 = Js_json.decodeArray(Caml_option.valFromOption(match$1));
                var match$4 = Js_json.decodeString(Caml_option.valFromOption(match$2));
                if (match$3 !== undefined && match$4 !== undefined) {
                  return Promise.resolve({
                              TAG: /* Error */1,
                              _0: {
                                badFields: List.map((function (s) {
                                        var str = Js_json.decodeString(s);
                                        if (str !== undefined) {
                                          return str;
                                        } else {
                                          return "";
                                        }
                                      }), $$Array.to_list(match$3)),
                                message: match$4
                              }
                            });
                } else {
                  return Promise.resolve({
                              TAG: /* Error */1,
                              _0: {
                                badFields: /* [] */0,
                                message: "An uknown error happened. Whoops! Try again later."
                              }
                            });
                }
              }).catch(function (err) {
              console.error(err);
              return Promise.resolve({
                          TAG: /* Error */1,
                          _0: {
                            badFields: /* [] */0,
                            message: "An uknown error happened. Whoops! Try again later."
                          }
                        });
            });
}

exports.registerUrl = registerUrl;
exports.registerUser = registerUser;
/* No side effect */
