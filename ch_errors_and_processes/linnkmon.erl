-module(linnkmon).
-author("Navneet Gupta").
-export([myproc/0, chain/1, start_critic/0, judge/3, critic/0, start_critic2/0, restarter/0, judge2/2, judge3/2, critic2/0, restarter2/0, start_critic3/0]).

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

% Now we'll just pretend we're going around stores, shopping for music. There are a few albums that sound interesting, but we're never quite sure. You decide to call your friend, the critic.
start_critic() ->
  spawn(?MODULE, critic, []).



% Because of a solar storm (I'm trying to find something realistic here), the connection is dropped:
% Annoying. We can no longer get criticism for the albums. To keep the critic alive, we'll write a basic 'supervisor' process whose only role is to restart(See below restarter/0) it when it goes down:
start_critic2() ->
  spawn(?MODULE, restarter, []).

% The problem with below restarter approach is that there is no way to find the Pid of the critic, and thus we can't call him to have his opinion. One of the solutions Erlang has to solve this is to give names to processes.
restarter() ->
  process_flag(trap_exit, true),
  Pid = spawn_link(?MODULE, critic, []),
  register(critic, Pid),
  % ,The act of giving a name to a process allows you to replace the unpredictable pid by an atom. This atom can then be used exactly as a Pid when sending messages. To give a process a name, the function erlang:register/2 is used. If the process dies, it will automatically lose its name or you can also use unregister/1 to do it manually. You can get a list of all registered processes with registered/0 or a more detailed one with the shell command regs().
  receive
    {'EXIT', Pid, normal} -> % not a crash
      ok;
    {'EXIT', Pid, shutdown} -> % manual termination, not a crash
      ok;
    {'EXIT', Pid, _} ->
      restarter()
    end.

% Problem With judge2 used by restarter:
% 1. critic ! Message
%                        2. critic receives
%                        3. critic replies
%                        4. critic dies
%  5. whereis fails
%                        6. critic is restarted
%  7. code crashes
% Or yet, this is also a possibility:
%
%  1. critic ! Message
%                           2. critic receives
%                           3. critic replies
%                           4. critic dies
%                           5. critic is restarted
%  6. whereis picks up
%     wrong pid
%  7. message never matches

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

start_critic3() ->
  spawn(?MODULE, restarter2, []).

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


% Monitors:
% erlang:monitor(process, spawn(fun() -> timer:sleep(500) end)).
% flush().
% {Pid, Ref} = spawn_monitor(fun() -> receive _ -> exit(boom) end end).     atomic like spawn_link what is atomic check for link at top description
% erlang:demonitor(Ref).
% Pid ! die.
% flush().
% f().
% {Pid, Ref} = spawn_monitor(fun() -> receive _ -> exit(boom) end end).
% Pid ! die
% erlang:demonitor(Ref, [flush, info]).     // The info option tells you if a monitor existed or not when you tried to remove it. This is why the expression returned false.
% flush().
% c(linnkmon).
% Critic = linnkmon:start_critic().
% linnkmon:judge(Critic, "Genesis" , "The Lambda Lies Down on Broadway").
% exit(Critic, solar_storm).
% linkmon:judge(Critic, "Genesis", "A trick of the Tail Recursion").
%
% c(linnkmon).
% linnkmon:start_critic2().
% linkmon:judge2(Critic, "Genesis", "A trick of the Tail Recursion").
% Critic1 = erlang:whereis(critic).
% exit(Critic1, solar_storm).
% linkmon:judge2(Critic, "Genesis", "A trick of the Tail Recursion").
