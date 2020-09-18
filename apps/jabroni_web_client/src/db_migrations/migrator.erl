-module(migrator).

-export([migrate_all/0]).

% put these in the order in which they need to run
migration_list() ->
	[
		'0_init_tables'
	].

migrate_all() ->
	{ok, _, _} = pgapp:squery("CREATE TABLE IF NOT EXISTS db_migrations (
		id SERIAL PRIMARY KEY,
		migration_module VARCHAR(255) UNIQUE NOT NULL,
		migrated_on TIMESTAMP NOT NULL)"),
	lists:foreach(fun (Mig) ->
		{ok, _Cols, Rows} = pgapp:equery("SELECT id FROM db_migrations WHERE migration_module = $1", [atom_to_list(Mig)]),
		case length(Rows) of
			0 ->
				ok = Mig:migrate(),
				{ok, _} = pgapp:equery("INSERT INTO db_migrations (migration_module, migrated_on)
					VALUES($1, NOW())
				", [atom_to_list(Mig)]);
			_ -> already_migrated
		end
	end, migration_list()),
	ok.
