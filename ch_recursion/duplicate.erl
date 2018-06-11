-module(duplicate).
-author("Navneet Gupta").
-export([duplicate/2]).

duplicate(N,T) -> dup(N,T,[]).

dup(N, _T, ACC) when N =< 0 -> ACC;
dup(N, T, ACC) -> dup(N-1, T, [T | ACC]).
