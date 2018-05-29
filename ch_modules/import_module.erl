-module(import_module).
-author("Navneet Gupta").
%%-export([add/2, hello/0, greet_add/2, greet_and_add_two/1]).
-export([imported_add/2, imported_hello/0, imported_greet_add/2, imported_greet_and_add_two/1]).
-import(add_module,[add/2]).
-import(hello_world, [hello/0]).
-import(greet_and_add_combined,[greet_add/2]).
-import(greet_and_add_two,[greet_and_add_two/1]).

imported_add(A,B) ->
  add_module:add(A,B).

imported_hello() ->
  hello_world:hello().

imported_greet_add(X,Y) ->
  greet_and_add_combined:greet_add(X,Y).

imported_greet_and_add_two(X) ->
  greet_and_add_two:greet_and_add_two(X).



%% By default, the shell will only look for files in the same directory it was started in
%% Commands To Run
% erl
% c(import_module).
% import_module:imported_add(2323,1212).
% import_module:imported_hello().
% import_module:imported_greet_and_add_two(232323).
% import_module:imported_greet_add(121,12122).
