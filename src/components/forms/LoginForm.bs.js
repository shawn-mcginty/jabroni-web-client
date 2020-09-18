'use strict';

var Curry = require("bs-platform/lib/js/curry.js");
var React = require("react");
var ReasonReactRouter = require("reason-react/src/ReasonReactRouter.bs.js");
var Button$JabroniWebClient = require("./Button.bs.js");

function LoginForm(Props) {
  var setShowRegisterForm = Props.setShowRegisterForm;
  var loginMessage = Props.loginMessage;
  var url = ReasonReactRouter.useUrl(undefined, undefined);
  var match = url.search;
  var loginFailureEl = match === "failed=true" ? React.createElement("p", {
          className: "text-red-800 text-center my-5"
        }, "Log in failed! Please try again.") : React.createElement("p", undefined);
  return React.createElement("div", {
              className: "px-10 py-5"
            }, React.createElement("p", {
                  className: "text-lg my-5 text-center"
                }, React.createElement("span", undefined, "Log in to "), React.createElement("strong", {
                      className: "text-pink-700"
                    }, "Jabroni")), loginMessage !== undefined ? React.createElement("p", {
                    className: "text-center text-pink-700 my-5"
                  }, React.createElement("strong", undefined, loginMessage)) : React.createElement("p", undefined), loginFailureEl, React.createElement("form", {
                  method: "POST"
                }, React.createElement("div", {
                      className: "my-4"
                    }, React.createElement("label", {
                          className: "font-bold",
                          htmlFor: "email"
                        }, "Email"), React.createElement("input", {
                          className: "bg-white focus:outline-none border border-gray-400 rounded-lg py-2 px-4 block w-full appearance-none leading-normal focus:border-gray-600",
                          name: "email",
                          placeholder: "smarty@coolplace.com",
                          type: "text"
                        })), React.createElement("div", {
                      className: "my-4"
                    }, React.createElement("label", {
                          className: "font-bold",
                          htmlFor: "pdub"
                        }, "Password"), React.createElement("input", {
                          className: "bg-white focus:outline-none border border-gray-400 rounded-lg py-2 px-4 block w-full appearance-none leading-normal focus:border-gray-600",
                          name: "pdub",
                          placeholder: "***********",
                          type: "password"
                        })), React.createElement("div", {
                      className: "flex"
                    }, React.createElement("div", {
                          className: "w-1/2"
                        }, React.createElement(Button$JabroniWebClient.make, {
                              label: "Log in",
                              color: /* Branding */0,
                              onClick: (function (param) {
                                  
                                }),
                              type_: "submit"
                            })), React.createElement("div", {
                          className: "w-1/2 text-right"
                        }, React.createElement(Button$JabroniWebClient.make, {
                              label: "Register",
                              color: /* Gray */1,
                              onClick: (function (e) {
                                  e.preventDefault();
                                  return Curry._1(setShowRegisterForm, (function (param) {
                                                return true;
                                              }));
                                })
                            })))));
}

var make = LoginForm;

exports.make = make;
/* react Not a pure module */
