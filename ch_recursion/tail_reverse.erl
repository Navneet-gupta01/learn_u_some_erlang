-module(tail_reverse).
-author("Navneet Gupta").
-export([reverse/1]).


reverse(A) -> reverse_tail(A,[]).

reverse_tail([],A) -> A;
reverse_tail([H | T], A) -> reverse_tail(T, [H | A]).
