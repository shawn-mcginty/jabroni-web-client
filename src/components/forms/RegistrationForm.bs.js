'use strict';

var List = require("bs-platform/lib/js/list.js");
var Curry = require("bs-platform/lib/js/curry.js");
var React = require("react");
var Caml_obj = require("bs-platform/lib/js/caml_obj.js");
var Button$JabroniWebClient = require("./Button.bs.js");
var RegistrationService$JabroniWebClient = require("../../services/RegistrationService.bs.js");

function fieldHasErrors(field, errors) {
  if (errors !== undefined) {
    return List.find_opt((function (f) {
                  return Caml_obj.caml_equal(f, field);
                }), errors[0]) !== undefined;
  } else {
    return false;
  }
}

function RegistrationForm(Props) {
  var setShowRegisterForm = Props.setShowRegisterForm;
  var setLoginMessage = Props.setLoginMessage;
  var match = React.useState(function () {
        return "";
      });
  var setEmail = match[1];
  var email = match[0];
  var match$1 = React.useState(function () {
        return "";
      });
  var setPdub = match$1[1];
  var pdub = match$1[0];
  var match$2 = React.useState(function () {
        return "";
      });
  var setPdub2 = match$2[1];
  var pdub2 = match$2[0];
  var match$3 = React.useState(function () {
        return "";
      });
  var setHandle = match$3[1];
  var handle = match$3[0];
  var match$4 = React.useState(function () {
        return "";
      });
  var setDisplay = match$4[1];
  var display = match$4[0];
  var match$5 = React.useState(function () {
        
      });
  var setErrors = match$5[1];
  var errors = match$5[0];
  var errorClassName = "bg-white focus:outline-none border border-red-400 rounded-lg py-2 px-4 block w-full appearance-none leading-normal focus:border-red-600";
  var clsasName = "bg-white focus:outline-none border border-gray-400 rounded-lg py-2 px-4 block w-full appearance-none leading-normal focus:border-gray-600";
  var pdubHasErrors = fieldHasErrors("pdub", errors);
  var pdub2HasErrors = fieldHasErrors("pdub2", errors);
  var emailHasErrors = fieldHasErrors("email", errors);
  var displayHasErrors = fieldHasErrors("display", errors);
  var handleHasErrors = fieldHasErrors("handle", errors);
  var errorMsgComp = errors !== undefined ? React.createElement("p", {
          className: "text-red-800 text-center"
        }, errors[1]) : React.createElement("p", undefined);
  return React.createElement("div", {
              className: "px-10 py-5"
            }, React.createElement("p", {
                  className: "text-lg my-5 text-center"
                }, React.createElement("span", undefined, "Register for "), React.createElement("strong", {
                      className: "text-pink-700"
                    }, "Jabroni")), React.createElement("p", {
                  className: "text-justify"
                }, React.createElement("span", undefined, "Registration is permitted by "), React.createElement("strong", undefined, "invitaton only"), React.createElement("span", undefined, ". If you haven't recieved an invitation ask a friend with "), React.createElement("span", {
                      className: "font-mono text-red-800 bg-gray-200"
                    }, "invitation privileges"), React.createElement("span", undefined, ".")), errorMsgComp, React.createElement("form", undefined, React.createElement("div", {
                      className: "my-4"
                    }, React.createElement("label", {
                          className: "font-bold",
                          htmlFor: "email"
                        }, "Email"), React.createElement("input", {
                          className: emailHasErrors ? errorClassName : clsasName,
                          name: "email",
                          placeholder: "smarty@coolplace.com",
                          type: "text",
                          onChange: (function (e) {
                              var target = e.currentTarget;
                              var newEmail = target.value;
                              return Curry._1(setEmail, (function (param) {
                                            return newEmail;
                                          }));
                            })
                        }), React.createElement("p", {
                          className: "text-sm"
                        }, "This is how you will log in.")), React.createElement("div", {
                      className: "my-4"
                    }, React.createElement("label", {
                          className: "font-bold",
                          htmlFor: "pdub"
                        }, "Password"), React.createElement("input", {
                          className: pdubHasErrors ? errorClassName : clsasName,
                          name: "pdub",
                          placeholder: "***********",
                          type: "password",
                          onChange: (function (e) {
                              var target = e.currentTarget;
                              var newPdub = target.value;
                              return Curry._1(setPdub, (function (param) {
                                            return newPdub;
                                          }));
                            })
                        })), React.createElement("div", {
                      className: "my-4"
                    }, React.createElement("label", {
                          className: "font-bold",
                          htmlFor: "pdub2"
                        }, "Repeat Password"), React.createElement("input", {
                          className: pdub2HasErrors ? errorClassName : clsasName,
                          name: "pdub2",
                          placeholder: "***********",
                          type: "password",
                          onChange: (function (e) {
                              var target = e.currentTarget;
                              var newPdub2 = target.value;
                              return Curry._1(setPdub2, (function (param) {
                                            return newPdub2;
                                          }));
                            })
                        })), React.createElement("div", {
                      className: "my-4"
                    }, React.createElement("label", {
                          className: "font-bold",
                          htmlFor: "handle"
                        }, "Handle"), React.createElement("div", {
                          className: "inline-flex w-full"
                        }, React.createElement("input", {
                              className: "bg-transparent focus:outline-none border-none py-2 pl-4 pr-1 block w-10 font-bold appearance-none leading-normal focus:border-none text-right text-gray-600",
                              disabled: true,
                              name: "ignore",
                              value: "@"
                            }), React.createElement("input", {
                              className: handleHasErrors ? errorClassName : clsasName,
                              name: "handle",
                              placeholder: "coolio",
                              type: "text",
                              onChange: (function (e) {
                                  var target = e.currentTarget;
                                  var newHandle = target.value;
                                  return Curry._1(setHandle, (function (param) {
                                                return newHandle;
                                              }));
                                })
                            })), React.createElement("p", {
                          className: "text-sm"
                        }, "This is how users will mention you.")), React.createElement("div", {
                      className: "my-4"
                    }, React.createElement("label", {
                          className: "font-bold",
                          htmlFor: "display"
                        }, "Display Name"), React.createElement("input", {
                          className: displayHasErrors ? errorClassName : clsasName,
                          name: "display",
                          placeholder: "J. Doe",
                          type: "text",
                          onChange: (function (e) {
                              var target = e.currentTarget;
                              var newDisplay = target.value;
                              return Curry._1(setDisplay, (function (param) {
                                            return newDisplay;
                                          }));
                            })
                        }), React.createElement("p", {
                          className: "text-sm"
                        }, "This is what users will see when you're chatting.")), React.createElement("div", {
                      className: "flex"
                    }, React.createElement("div", {
                          className: "w-1/2"
                        }, React.createElement(Button$JabroniWebClient.make, {
                              label: "Register",
                              color: /* Branding */0,
                              onClick: (function (e) {
                                  e.preventDefault();
                                  RegistrationService$JabroniWebClient.registerUser(email, pdub, pdub2, display, handle).then(function (result) {
                                        if (result.TAG) {
                                          var regErr = result._0;
                                          return Promise.resolve(Curry._1(setErrors, (function (param) {
                                                            return [
                                                                    regErr.badFields,
                                                                    regErr.message
                                                                  ];
                                                          })));
                                        }
                                        Curry._1(setErrors, (function (param) {
                                                
                                              }));
                                        Curry._1(setLoginMessage, (function (param) {
                                                return "You can log in now.";
                                              }));
                                        Curry._1(setShowRegisterForm, (function (param) {
                                                return false;
                                              }));
                                        return Promise.resolve(undefined);
                                      });
                                  
                                }),
                              type_: "submit"
                            })), React.createElement("div", {
                          className: "w-1/2 text-right"
                        }, React.createElement(Button$JabroniWebClient.make, {
                              label: "Cancel",
                              color: /* Gray */1,
                              onClick: (function (e) {
                                  e.preventDefault();
                                  return Curry._1(setShowRegisterForm, (function (param) {
                                                return false;
                                              }));
                                })
                            })))));
}

var make = RegistrationForm;

exports.fieldHasErrors = fieldHasErrors;
exports.make = make;
/* react Not a pure module */
