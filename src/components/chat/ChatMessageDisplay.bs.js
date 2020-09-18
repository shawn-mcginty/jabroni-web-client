'use strict';

var React = require("react");
var PublicUser$JabroniWebClient = require("../../PublicUser.bs.js");
var AvatarGenerator$JabroniWebClient = require("../../utils/AvatarGenerator.bs.js");

function ChatMessageDisplay(Props) {
  var author = Props.author;
  var body = Props.body;
  var ts = Props.ts;
  var canvasRef = React.useRef(null);
  React.useEffect((function () {
          AvatarGenerator$JabroniWebClient.getSvg(PublicUser$JabroniWebClient.display(author), canvasRef.current);
          
        }), [author]);
  return React.createElement("div", {
              className: "w-full flex py-4"
            }, React.createElement("div", {
                  className: "bg-transparent",
                  style: {
                    height: "56px",
                    width: "56px"
                  }
                }, React.createElement("canvas", {
                      ref: canvasRef,
                      className: "sprite",
                      height: "16",
                      width: "16"
                    })), React.createElement("div", {
                  className: "flex flex-col flex-grow pl-2"
                }, React.createElement("div", {
                      className: "w-full pb-2"
                    }, React.createElement("span", {
                          title: "@" + PublicUser$JabroniWebClient.handle(author)
                        }, React.createElement("strong", undefined, PublicUser$JabroniWebClient.display(author))), React.createElement("span", {
                          className: "text-gray-700 text-sm pl-2"
                        }, ts)), React.createElement("div", {
                      className: "w-full"
                    }, body)));
}

var make = ChatMessageDisplay;

exports.make = make;
/* react Not a pure module */
