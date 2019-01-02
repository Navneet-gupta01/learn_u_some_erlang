-module(quicksort).
-author("Navneet Gupta").
-export([qsort/1]).


qsort([]) -> [];

qsort([H | T]) ->
  {smaller, larger} = partition(H, T, [], []),
  qsort(smaller) ++ [H] ++ qsort(larger).

partition(_,[], Smaller, Larger) -> {Smaller, Larger};
partition(Pivot, [H|T], Smaller, Larger) ->
    if H =< Pivot -> partition(Pivot, T, [H|Smaller], Larger);
       H >  Pivot -> partition(Pivot, T, Smaller, [H|Larger])
    end.
