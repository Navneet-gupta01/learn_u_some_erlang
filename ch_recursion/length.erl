-module(length).
-author("Navneet Gupta").
-export([len/1]).

len([]) -> 0;
len([_ | T]) -> 1+len(T).
