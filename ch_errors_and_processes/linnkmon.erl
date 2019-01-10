-module(linnkmon).
-author("Navneet Gupta").
-export([myproc/0, chain/1, start_critic/0, judge/3, critic/0, start_critic2/0, restarter/0, judge2/2, judge3/2, critic2/0]).

myproc() ->
  timer:sleep(10000),
  exit(reason).

chain(0) ->
  receive
    _ -> ok
    after 10000 ->
      exit("chain dies here")
    end;

chain(N) ->
  Pid = spawn(fun() -> chain(N-1) end),
  link(Pid),  %The crash could have happened in any of the linked processes; because links are bidirectional, you only need one of them to die for the others to follow suit.
  receive
    _ -> ok
  end.

 % Links can not be stacked. If you call link/1 15 times for the same two processes, only one link will still exist between them and a single call to unlink/1 will be enough to tear it down.

 % Its important to note that link(spawn(Function)) or link(spawn(M,F,A)) happens in more than one step. In some cases, it is possible for a process to die before the link has been set up and then provoke unexpected behavior. For this reason, the function spawn_link/1-3 has been added to the language. It takes the same arguments as spawn/1-3, creates a process and links it as if link/1 had been there, except it's all done as an atomic operation (the operations are combined as a single one, which can either fail or succeed, but nothing else).

start_critic() ->
  spawn(?MODULE, critic, []).

start_critic2() ->
  spawn(?MODULE, restarter, []).

restarter() ->
  process_flag(trap_exit, true),
  Pid = spawn_link(?MODULE, critic, []),
  register(critic, Pid),
  receive
    {'EXIT', Pid, normal} -> % not a crash
      ok;
    {'EXIT', Pid, shutdown} -> % manual termination, not a crash
      ok;
    {'EXIT', Pid, _} ->
      restarter()
    end.

judge(Pid, Band, Album) ->
  Pid ! {self(), {Band, Album}},
  receive
    {Pid, Criticism} -> Criticism
    after 2000 ->
      timeout
    end.

judge2(Band, Album) ->
  critic ! {self(), {Band, Album}},
  Pid = whereis(critic),
  receive
    {Pid, Criticism} -> Criticism
    after 2000 ->
      timeout
    end.

critic() ->
  receive
    {From, {"Rage Against the Turing Machine", "Unit Testify"}} ->
      From ! {self(), "They are great!"};
    {From, {"System of a Downtime", "Memoize"}} ->
      From ! {self(), "They're not Johnny Crash but they're good."};
    {From, {"Johnny Crash", "The Token Ring of Fire"}} ->
      From ! {self(), "Simply incredible."};
    {From, {_Band, _Album}} ->
      From ! {self(), "They are terrible!"}
    end,
    critic().

restarter2() ->
  process_flag(trap_exit, true),
  Pid = spawn_link(?MODULE, critic2, []),
  register(critic2, Pid),
  receive
    {'EXIT', Pid, normal} -> % not a crash
      ok;
    {'EXIT', Pid, shutdown} -> % manual termination, not a crash
      ok;
    {'EXIT', Pid, _} ->
      restarter()
    end.

judge3(Band, Album) ->
  Ref = make_ref(),
  critic ! {self(), Ref, {Band, Album}},
  receive
    {Ref,  Criticism} -> Criticism
    after 2000 ->
      timeout
    end.


critic2() ->
  receive
    {From, Ref, {"Rage Against the Turing Machine", "Unit Testify"}} ->
      From ! {Ref, "They are great!"};
    {From, Ref, {"System of a Downtime", "Memoize"}} ->
      From ! {Ref, "They're not Johnny Crash but they're good."};
    {From, Ref, {"Johnny Crash", "The Token Ring of Fire"}} ->
      From ! {Ref, "Simply incredible."};
    {From, Ref, {_Band, _Album}} ->
      From ! {Ref, "They are terrible!"}
    end,
    critic2().

% Check number of process count
% erlang:system_info(process_count).
% c(linnkmon).
% erlang:system_info(process_count).
% link(spawn(linnkmon, chain, [5])).
% erlang:system_info(process_count). -- keeps on checking using this command after 10 sec process count should return back to original count before spawn command above
