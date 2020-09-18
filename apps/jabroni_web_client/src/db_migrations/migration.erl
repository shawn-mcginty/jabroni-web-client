-module(migration).
-callback migrate() -> ok | {error, string()}.
% -export([migrate/0]).
% -spec migrate() -> ok | {error, string()}.
% migrate() -> ok.