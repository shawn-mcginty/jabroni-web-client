-module('0_init_tables').

-behaviour(migration).

-export([migrate/0]).

migrate() ->
	pgapp:with_transaction(fun() ->
		{ok, _, _} = pgapp:squery("
			CREATE TABLE users (
				id SERIAL PRIMARY KEY,
				email VARCHAR(255) UNIQUE NOT NULL,
				password VARCHAR(255) NOT NULL,
				handle VARCHAR(255) UNIQUE NOT NULL,
				display VARCHAR(255) NOT NULL,
				created_on TIMESTAMP NOT NULL
			)"),
		{ok, _, _} = pgapp:squery("CREATE INDEX idx_users_email ON users(email)"),
		{ok, _, _} = pgapp:squery("CREATE INDEX idx_users_handle ON users(handle)"),
		{ok, _} = pgapp:squery("
			INSERT INTO users (email, password, handle, display, created_on)
			VALUES ('root', 'root', 'root', 'root', NOW())
		"),
		{ok, _, _} = pgapp:squery("
			CREATE TABLE invitations (
				id serial PRIMARY KEY,
				invited_email VARCHAR(255) UNIQUE NOT NULL,
				invited_by_user_id integer,
				created_on TIMESTAMP NOT NULL
			)"),
		{ok, _} = pgapp:squery("
			INSERT INTO invitations (invited_email, invited_by_user_id, created_on)
			VALUES ('mcginty.shawn@gmail.com', 1, NOW()),
			('jshirley1990@gmail.com', 1, NOW()),
			('shuckwitbrian@gmail.com', 1, NOW())
		"),
		{ok, _, _} = pgapp:squery("
			CREATE TABLE sessions (
				sid VARCHAR(255) PRIMARY KEY,
				user_id INTEGER NOT NULL,
				expiry TIMESTAMP NOT NULL)"),
		ok
	end).