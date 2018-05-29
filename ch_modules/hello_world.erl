-module(hello_world).
-author("Navneet Gupta").
-export([hello/0]).

hello() ->
  io:format("Hello, world!~n").

%% By default, the shell will only look for files in the same directory it was started in
%% Commands To Run
% erl
% c(hello_world).
% hello_world:hello().
