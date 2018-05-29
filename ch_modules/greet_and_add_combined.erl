-module(greet_and_add_combined).
-author("Navneet Gupta").
-export([greet_add/2]).

hello() ->
  io:format("Hello, world!~n").

add(A,B) ->
  A+B.

greet_add(A,B) ->
  hello(),
  add(A,B).

%% By default, the shell will only look for files in the same directory it was started in
%% Commands To Run
% erl
% c(greet_and_add_combined).
% greet_and_add_combined:greet_add(232323,232323).
