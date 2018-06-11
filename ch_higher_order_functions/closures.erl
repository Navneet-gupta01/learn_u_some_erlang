-module(closures).
-author("Navneet Gupta").
-export([a/0, b/1]).

a() ->
  Secret = "Pony",
  fun() -> Secret end.

b(F) ->
  "a/0 's Password is "++F().
