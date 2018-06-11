-module(tail_length).
-author("Navneet Gupta").
-export([len/1]).


len(A) -> length(A,0).

length([], L) -> L;
length([_ | T], L) -> length(T, L+1).
