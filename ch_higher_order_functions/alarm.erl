-module(alarm).
-author("Navneet Gupta").
-export([prepareAlarm/0]).


%%  So erlang considers this is as assignment to a variable and not as a function and hence refuses to export it ?
%%  Refuses to compile, even. In an Erlang module, variable assignments can only appear within functions.

% PrepareAlarm = fun (Room) ->
%   io:format("Alarm set in ~s.~n",[Room]),
%   fun Loop() ->
%     io:format("Alarm tripped in ~s! Call Batman!~n",[Room]),
%     timer:sleep(500),
%     Loop()
%   end
% end.


prepareAlarm() ->
   fun (Room) ->
    io:format("Alarm set in ~s.~n",[Room]),
    fun Loop() ->
      io:format("Alarm tripped in ~s! Call Batman!~n",[Room]),
      timer:sleep(500),
      Loop()
    end
  end.
