-module(message_utils_test).

-include_lib("eunit/include/eunit.hrl").

pop_message_part_simple_string_test() -> {"head", "body"} = message_utils:pop_message_part("head|body").

pop_message_part_empty_string_test() -> {"", ""} = message_utils:pop_message_part("").

pop_message_part_string_without_splitter_test() -> {"", "body"} = message_utils:pop_message_part("body").

pop_message_part_string_with_many_splitters_test() ->
  {"foo", "body|with|splitters"} = message_utils:pop_message_part("foo|body|with|splitters").

pop_message_part_string_head_of_splitter_test() -> {"", "tail"} = message_utils:pop_message_part("|tail").
