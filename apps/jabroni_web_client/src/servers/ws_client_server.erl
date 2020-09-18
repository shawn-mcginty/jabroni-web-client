-module(ws_client_server).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(client, {process::pid(), user_id::number(), subscriptions=[]::list(number())}).
-record(all_clients_state, {clients=[]::list(#client{})}).

%%%===================================================================
%%% API
%%%===================================================================

%% @doc Spawns the server and registers the local name (unique)
-spec(start_link() ->
	{ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% @private
%% @doc Initializes the server
-spec(init(Args :: term()) ->
	{ok, State :: #all_clients_state{}} | {ok, State :: #all_clients_state{}, timeout() | hibernate} |
	{stop, Reason :: term()} | ignore).
init([]) ->
	{ok, #all_clients_state{}}.

%% @private
%% @doc Handling call messages
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
		State :: #all_clients_state{}) ->
	{reply, Reply :: term(), NewState :: #all_clients_state{}} |
	{reply, Reply :: term(), NewState :: #all_clients_state{}, timeout() | hibernate} |
	{noreply, NewState :: #all_clients_state{}} |
	{noreply, NewState :: #all_clients_state{}, timeout() | hibernate} |
	{stop, Reason :: term(), Reply :: term(), NewState :: #all_clients_state{}} |
	{stop, Reason :: term(), NewState :: #all_clients_state{}}).
handle_call({join, Pid, UserId}, _From, State) ->
	io:fwrite("~nClient ~p joined all_clients~n", [pid_to_list(Pid)]),
	NewClient = #client{process=Pid, user_id=UserId},
	NewState = State#all_clients_state{clients = State#all_clients_state.clients ++ [NewClient]},
	{reply, ok, NewState};
handle_call({leave, Pid}, _From, State) ->
	io:fwrite("~nClient ~p left all_clients~n", [pid_to_list(Pid)]),
	NewClients = lists:filter(fun(C) -> C#client.process /= Pid end, State#all_clients_state.clients),
	NewState = State#all_clients_state{clients = NewClients},
	{reply, ok, NewState};
handle_call(_Request, _From, State) ->
	{reply, ok, State}.

-spec(broadcast(list(pid()), {atom(), string()}) -> ok).
broadcast([], _Msg) -> ok;
broadcast([H|Tail], Msg) ->
	io:fwrite("Emit to client ~p~n", [pid_to_list(H)]),
	erlang:send(H, Msg),
	broadcast(Tail, Msg).

%% @private
%% @doc Handling cast messages
-spec(handle_cast(Request :: term(), State :: #all_clients_state{}) ->
	{noreply, NewState :: #all_clients_state{}} |
	{noreply, NewState :: #all_clients_state{}, timeout() | hibernate} |
	{stop, Reason :: term(), NewState :: #all_clients_state{}}).
handle_cast({text, Msg}, State) ->
	ClientPids = lists:map(fun (Client) -> Client#client.process end, State#all_clients_state.clients),
	ok = broadcast(ClientPids, {text, Msg}),
	{noreply, State};
handle_cast(_Request, State = #all_clients_state{}) ->
	{noreply, State}.

%% @private
%% @doc Handling all non call/cast messages
-spec(handle_info(Info :: timeout() | term(), State :: #all_clients_state{}) ->
	{noreply, NewState :: #all_clients_state{}} |
	{noreply, NewState :: #all_clients_state{}, timeout() | hibernate} |
	{stop, Reason :: term(), NewState :: #all_clients_state{}}).
handle_info(_Info, State = #all_clients_state{}) ->
	{noreply, State}.

%% @private
%% @doc This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
		State :: #all_clients_state{}) -> term()).
terminate(_Reason, _State = #all_clients_state{}) ->
	ok.

%% @private
%% @doc Convert process state when code is changed
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #all_clients_state{},
		Extra :: term()) ->
	{ok, NewState :: #all_clients_state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State = #all_clients_state{}, _Extra) ->
	{ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
