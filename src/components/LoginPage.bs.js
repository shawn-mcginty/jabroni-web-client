'use strict';

var React = require("react");
var LoginForm$JabroniWebClient = require("./forms/LoginForm.bs.js");
var RegistrationForm$JabroniWebClient = require("./forms/RegistrationForm.bs.js");

function LoginPage(Props) {
  var match = React.useState(function () {
        return false;
      });
  var setShowRegisterForm = match[1];
  var match$1 = React.useState(function () {
        
      });
  return React.createElement("div", {
              className: "bg-gray-200 min-h-screen min-w-full flex flex-col items-center"
            }, React.createElement("div", {
                  className: "bg-white w-4/5 sm:w-4/5 md:w-2/3 lg:w-1/2 mt-10 shadow-md"
                }, match[0] ? React.createElement(RegistrationForm$JabroniWebClient.make, {
                        setShowRegisterForm: setShowRegisterForm,
                        setLoginMessage: match$1[1]
                      }) : React.createElement(LoginForm$JabroniWebClient.make, {
                        setShowRegisterForm: setShowRegisterForm,
                        loginMessage: match$1[0]
                      })));
}

var make = LoginPage;

exports.make = make;
/* react Not a pure module */
