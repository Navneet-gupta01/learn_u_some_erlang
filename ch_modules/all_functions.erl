-module(all_functions).
-author("Navneet Gupta").
-export([add/2, hello/0, greet_and_add_two/1, greet_add/2]).

greet_and_add_two(X) ->
  hello(),
  add(X,2).

greet_add(A,B) ->
  hello(),
  add(A,B).

hello() ->
  io:format("Hello, world!~n").

add(A,B) ->
  A+B.


%% By default, the shell will only look for files in the same directory it was started in
%% Commands To Run
% erl
% c(all_functions).
% all_functions:add(2323,1212).
% all_functions:hello().
% all_functions:greet_and_add_two(232323).
% all_functions:greet_add(121,12122).
