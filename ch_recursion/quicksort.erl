-module(quicksort).
-author("Navneet Gupta").
-export([qsort/1]).


qsort([]) -> [].

% qsort([H | T]) ->
%   {smaller, larger} = partition(H, T, [], []),
%   qsort(smaller) ++ [H] ++ qsort(larger).


% partition(_,[], Smaller, Larger) -> {Smaller, Larger};
% partition(PIVOT, [H | T]], LEFT, RIGHT) ->
%   if H =< PIVOT -> partition(Pivot, T, [H|LEFT], RIGHT);
%      H > PIVOT -> partition(Pivot, T, LEFT, [H | RIGHT])
%   end.


% partition(_,[], Smaller, Larger) -> {Smaller, Larger};
% partition(Pivot, [H|T], Smaller, Larger) ->
%     if H =< Pivot -> partition(Pivot, T, [H|Smaller], Larger);
%        H >  Pivot -> partition(Pivot, T, Smaller, [H|Larger])
%     end.
