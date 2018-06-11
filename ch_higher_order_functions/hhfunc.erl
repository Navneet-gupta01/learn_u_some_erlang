-module(hhfunc).
-author("Navneet Gupta").
-export([one/0, two/0, add/2, map/2, inc/1, dec/1, increment/1, decrement/1, even/1, old_men/1, filter/2,
  max/1,min/1,sum/1,fold/3]).

one() -> 1.
two() -> 2.

add(A,B) -> A() + B().

%% hhfunc:add(fun hhfunc:one/0,fun hhfunc:two/0).

increment([]) -> [];
increment([H | T]) -> [ H+1 | increment(T)].

decrement([]) -> [];
decrement([H | T]) -> [ H-1 | decrement(T)].


map([], _) -> [];
map([H | T], F) -> [ F(H) | map(T,F)].

inc(A) -> A + 1.

dec(B) -> B - 1.

% 1> c(hhfuns).
% {ok, hhfuns}
% 2> L = [1,2,3,4,5].
% [1,2,3,4,5]
% 3> hhfuns:increment(L).
% [2,3,4,5,6]
% 4> hhfuns:decrement(L).
% [0,1,2,3,4]
% 5> hhfuns:map(fun hhfuns:incr/1, L).
% [2,3,4,5,6]
% 6> hhfuns:map(fun hhfuns:decr/1, L).
% [0,1,2,3,4]
% 9> hhfuns:map(fun(X) -> X + 1 end, L).
% [2,3,4,5,6]
% 10> hhfuns:map(fun(X) -> X - 1 end, L).
% [0,1,2,3,4]


even(L) -> lists:reverse(even(L,[])).

even([], Acc) -> Acc;
even([H | T], Acc) when H rem 2 == 0 -> even(T, [H | Acc]);
even([_ | T], Acc) -> even(T, Acc).

old_men(L) -> lists:reverse(old_men(L, [])).

old_men([], Acc) -> Acc;
old_men([Person = {male, Age} | People], Acc) when Age > 60 ->
  old_men(People, [Person | Acc]);
old_men([_ | People], Acc) -> old_men(People, Acc).


filter(Pred, L) -> lists:reverse(filter(Pred, L,[])).

filter(_, [], Acc) -> Acc;
filter(Pred, [H|T], Acc) ->
    case Pred(H) of
        true  -> filter(Pred, T, [H|Acc]);
        false -> filter(Pred, T, Acc)
    end.

max([H | T]) -> max2([T], H).

max2([H | T], Max) when H > Max -> max2(T, H);
max2([_ | T], Max) -> max2(T, Max).

min([H | T]) -> min2([T], H).

min2([H | T], Max) when H < Max -> min2(T, H);
min2([_ | T], Max) -> min2(T, Max).

sum(L) -> sum(L, 0).

sum([], Sum) -> Sum;
sum([H | T], Sum) -> sum(T, Sum+H).


fold(_, Start, []) -> Start;
fold(F, Start, [H | T]) -> fold(F, F(H, Start), T).
