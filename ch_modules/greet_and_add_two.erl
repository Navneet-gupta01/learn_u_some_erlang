-module(greet_and_add_two).
-author("Navneet Gupta").
-export([greet_and_add_two/1]).

greet_and_add_two(X) ->
  hello(),
  add(X,2).

hello() ->
  io:format("Hello, world!~n").

add(A,B) ->
  A+B.


%% By default, the shell will only look for files in the same directory it was started in
%% Commands To Run
% erl
% c(greet_and_add_two).
% greet_and_add_two:greet_and_add_two(232323).
