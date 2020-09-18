-module(ws_controller).

%% API
-export([init/2, websocket_init/1, websocket_handle/2, websocket_info/2, terminate/3]).

init(Req0, State) ->
	io:fwrite("websocket client trying to connect...~n"),
	case session_service:get_browser_sid(Req0) of
		{_, none} ->
			Req2 = cowboy_req:reply(401, Req0),
			{ok, Req2, State};
		{_, {some, Sid}} ->
			case session_service:get_valid_session(Sid) of
				none ->
					Req2 = cowboy_req:reply(401, Req0),
					{ok, Req2, State};
				{some, Session} ->
					UserId = session_model:user_id(Session),
					case cowboy_req:parse_header(<<"sec-websocket-protocol">>, Req0) of
						undefined ->
							io:fwrite("websocket client connected.~n"),
							{cowboy_websocket, Req0, [UserId]};
						Sub_protocols ->
							case lists:keymember(<<"mqtt">>, 1, Sub_protocols) of
								true ->
									Req = cowboy_req:set_resp_header(<<"sec-websocket-protocol">>, <<"mqtt">>, Req0),
									{cowboy_websocket, Req, [UserId]};
								false ->
									Req = cowboy_req:reply(400, Req0),
									{ok, Req, State}
							end
					end
			end
	end.

websocket_init([UserId]) ->
	erlang:send_after(5000, self(), ping),
	gen_server:call(ws_client_server, {join, self(), UserId}),
	{[{text, <<"ack|connected">>}], []};
websocket_init(_)->
	{shutdown_reason, "User not found."}.

websocket_handle(_Frame = {text, Body}, State) ->
	io:fwrite("websocket_handle 1"),
	{Ns, Msg} = message_utils:pop_message_part(Body),
	io:fwrite(Ns),
	case Ns of
		<<"chat_msg">> ->
			io:fwrite("return that shiz"),
			gen_server:cast(ws_client_server, {text, "chat_msg_ack|" ++ Msg}),
			{ok, State};
		_ ->
			{ok, State}
	end;
websocket_handle(_Frame, State) ->
	{ok, State}.

websocket_info(ping, State) ->
	erlang:send_after(5000, self(), ping),
	io:fwrite("send ping to ~s~n", [pid_to_list(self())]),
	{[ping], State};
websocket_info({text, Msg}, State) ->
	{[{text, Msg}], State};
websocket_info(_Frame, State) ->
	{ok, State}.

terminate(_Reason, _PartialReq, _State) ->
	gen_server:call(ws_client_server, {leave, self()}),
	ok.