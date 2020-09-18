'use strict';


function host(param) {
  return window.location.host;
}

function protocol(param) {
  return window.location.protocol;
}

exports.host = host;
exports.protocol = protocol;
/* No side effect */
