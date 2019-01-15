-module(common_server).
-author("Navneet Gupta").
-compile(export_all).

call(Pid, Msg) ->
  Ref = erlang:monitor(process, Pid),
  Pid ! {sync, self(), Ref, Msg},
  receive
    {Ref, Resp} ->
      erlang:demonitor(Ref, [flush]),
      Resp;
    {'DOWN', Ref, process, Pid, Reason} ->
      erlang:error(Reason)
    after 5000 ->
      erlang:error(timeout)
    end.

cast(Pid, Msg) ->
  Pid ! {async, Msg},
  ok.

reply({Pid, Ref}, Msg) ->
  Pid ! {Ref, Msg}.

init(Module, InitialState) ->
  loop(Module, Module:init(InitialState)).

loop(Module, State) ->
  receive
    {async, Msg} ->
      loop(Module, Module:handle_cast(Msg, State));
    {sync, Pid, Ref, Msg} ->
      loop(Module, Module:handle_call(Msg, {Pid, Ref}, State))
  end.

start(Module, InitialState) ->
  spawn(fun() -> init(Module, InitialState) end).

start_link(Module, InitialState) ->
  spawn_link(fun() -> init(Module, InitialState) end).
