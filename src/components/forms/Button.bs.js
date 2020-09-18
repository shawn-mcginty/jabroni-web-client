'use strict';

var Curry = require("bs-platform/lib/js/curry.js");
var React = require("react");
var Printf = require("bs-platform/lib/js/printf.js");

function Button(Props) {
  var label = Props.label;
  var color = Props.color;
  var onClick = Props.onClick;
  var type_Opt = Props.type_;
  var type_ = type_Opt !== undefined ? type_Opt : "button";
  var buttonColor = color ? "gray" : "pink";
  var className = Curry._4(Printf.sprintf(/* Format */{
            _0: {
              TAG: /* String_literal */11,
              _0: "bg-transparent hover:bg-",
              _1: {
                TAG: /* String */2,
                _0: /* No_padding */0,
                _1: {
                  TAG: /* String_literal */11,
                  _0: "-500 text-",
                  _1: {
                    TAG: /* String */2,
                    _0: /* No_padding */0,
                    _1: {
                      TAG: /* String_literal */11,
                      _0: "-700 font-semibold hover:text-white py-2 px-4 border border-",
                      _1: {
                        TAG: /* String */2,
                        _0: /* No_padding */0,
                        _1: {
                          TAG: /* String_literal */11,
                          _0: "-500 hover:border-",
                          _1: {
                            TAG: /* String */2,
                            _0: /* No_padding */0,
                            _1: {
                              TAG: /* String_literal */11,
                              _0: "-700 rounded",
                              _1: /* End_of_format */0
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            },
            _1: "bg-transparent hover:bg-%s-500 text-%s-700 font-semibold hover:text-white py-2 px-4 border border-%s-500 hover:border-%s-700 rounded"
          }), buttonColor, buttonColor, buttonColor, buttonColor);
  return React.createElement("button", {
              className: className,
              type: type_,
              onClick: onClick
            }, label);
}

var make = Button;

exports.make = make;
/* react Not a pure module */
