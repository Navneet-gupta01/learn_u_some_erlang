-module(add_module).
-author("Navneet Gupta").
-export([add/2]).

%% Variables start with Capital Letters in erlang. words starting with lower case letters are atoms.
add(A, B) ->
  A+B.


%% By default, the shell will only look for files in the same directory it was started in
%% Commands To Run
% erl
% c(add_module).
% add_module:add(232323,232323).
