-module(zip).
-author("Navneet Gupta").
-export([zip/2]).
-import(lists, [reverse/1]).

zip(A,B) -> lists:reverse(zip(A, B, [])).

zip(_, [], A) -> A;
zip([], _, A) -> A;
zip([H | T], [H1 | T1], A) -> zip(T, T1, [{H,H1} | A]).
