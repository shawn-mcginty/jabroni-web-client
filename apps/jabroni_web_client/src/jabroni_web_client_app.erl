%%%-------------------------------------------------------------------
%% @doc jabroni_web_client public API
%% @end
%%%-------------------------------------------------------------------

-module(jabroni_web_client_app).

-behaviour(application).

-export([start/2, stop/1]).

verify_db_connection() ->
	application:ensure_all_started(pgapp),
	{ok, Db} = application:get_env(jabroni_web_client, database),
	{ok, DbHost} = application:get_env(jabroni_web_client, db_host),
	{ok, DbPort} = application:get_env(jabroni_web_client, db_port),
	{ok, DbUsername} = application:get_env(jabroni_web_client, db_user),
	{ok, DbPdub} = application:get_env(jabroni_web_client, db_pw),
	{ok, DbPoolSize} = application:get_env(jabroni_web_client, db_pool_size),
	pgapp:connect([
		{size, DbPoolSize},
		{database, Db},
		{username, DbUsername},
		{password, DbPdub},
		{host, DbHost},
		{port, DbPort}
	]),
	{ok, _, _} = pgapp:squery("SELECT 1"),
	ok.

start_http_server(Port) ->
	Dispatch = cowboy_router:compile([
		{'_',
			[
				{"/static/[...]", cowboy_static, {priv_dir, jabroni_web_client, "public"}},
				{"/login", login_controller, []},
				{"/", home_controller, []},
				{"/ws", ws_controller, []},
				{"/registration", registration_controller, []},
				{"/api/users", users_controller, []}
			]
		}
	]),
	{Response, _} = cowboy:start_clear(my_http_listener,
		[{port, Port}],
		#{env => #{dispatch => Dispatch}, middlewares => [cowboy_router, session_middleware, cowboy_handler]}
	),
	Response.

start(_StartType, _StartArgs) ->
	ok = verify_db_connection(),
	ok = migrator:migrate_all(),
	ok = start_http_server(8080),
	jabroni_web_client_sup:start_link().

stop(_State) ->
	ok.

%% internal functions
