'use strict';

var React = require("react");
var ReactDOMRe = require("reason-react/src/legacy/ReactDOMRe.bs.js");
var LoginPage$JabroniWebClient = require("./components/LoginPage.bs.js");

import './styles/main.css'
;

ReactDOMRe.renderToElementWithId(React.createElement(LoginPage$JabroniWebClient.make, {}), "app");

/*  Not a pure module */
