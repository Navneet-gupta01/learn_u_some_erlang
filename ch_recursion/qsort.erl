-module(qsort).
-author("Navneet Gupta").
-export([qsort/1]).

qsort([]) -> [];
qsort([Pivot | Tail]) ->
  {Left, Right} = partition(Pivot, Tail, [], []),
  qsort(Left) ++ [Pivot] ++ qsort(Right).



partition(_, [], Left, Right) -> {Left, Right};
partition(P, [ H | T], Left, Right) ->
  if H =< P -> partition(P, T, [H|Left], Right);
     H > P -> partition(P, T, Left, [H | Right])
  end.
