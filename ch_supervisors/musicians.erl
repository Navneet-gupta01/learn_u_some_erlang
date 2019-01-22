-module(musicians).
-behaviour(gen_server).

-export([start_link/2, stop/1]).
-export([init/1, handle_call/3, handle_cast/2,
         handle_info/2, code_change/3, terminate/2]).

-record(state, {name="", role, skill=good}).
-define(DELAY, 750).

start_link(Role, Skill) ->
    gen_server:start_link({local, Role}, ?MODULE, [Role, Skill], []).

stop(Role) -> gen_server:call(Role, stop).

init([Role,Skill]) ->
  %% To know when the parent shuts down
  %% First we start trapping exits. If you recall the description of the terminate/2 from the Generic Servers chapter, we need to do this if we want terminate/2 to be called when the server's parent shuts down its children.
  process_flag(trap_exit, true),
  %% sets a seed for random number generation for the life of the process
  %% uses the current time to do it. Unique value guaranteed by timestamp()
  rand:seed(exs1024s, erlang:timestamp()),
  TimeToPlay = rand:uniform(3000),
  Name = pick_name(),
  StrRole = atom_to_list(Role),
  io:format("Musician ~s, playing the ~s entered the room~n",
  [Name, StrRole]),
  {ok, #state{name=Name, role=StrRole, skill=Skill}, TimeToPlay}.


%% Yes, the names are based off the magic school bus characters'
%% 10 names!
pick_name() ->
  %% the seed must be set for the random functions. Use within the
  %% process that started with init/1
  lists:nth(rand:uniform(10), firstnames())
  ++ " " ++
  lists:nth(rand:uniform(10), lastnames()).

firstnames() ->
  ["Valerie", "Arnold", "Carlos", "Dorothy", "Keesha",
    "Phoebe", "Ralphie", "Tim", "Wanda", "Janet"].

lastnames() ->
  ["Frizzle", "Perlstein", "Ramon", "Ann", "Franklin",
    "Terese", "Tennelli", "Jamal", "Li", "Perlstein"].

handle_call(stop, _From, S=#state{}) ->
  {stop, normal, ok, S};
handle_call(_Message, _From, S) ->
  {noreply, S, ?DELAY}.

handle_cast(_Message, S) ->
  {noreply, S, ?DELAY}.

handle_info(timeout, S = #state{name=N, skill=good}) ->
  io:format("~s produced sound!~n",[N]),
  {noreply, S, ?DELAY};
handle_info(timeout, S = #state{name=N, skill=bad}) ->
  case rand:uniform(5) of
    1 ->
      io:format("~s played a false note. Uh oh~n",[N]),
      {stop, bad_note, S};
    _ ->
      io:format("~s produced sound!~n",[N]),
      {noreply, S, ?DELAY}
  end;
handle_info(_Message, S) ->
  {noreply, S, ?DELAY}.

% We've got many different messages here. If we terminate with a normal reason, it means we've called the stop/1 function and so we display the the musician left of his/her own free will. In the case of a bad_note message, the musician will crash and we'll say that it's because the manager (the supervisor we'll soon add) kicked him out of the game.
% Then we have the shutdown message, which will come from the supervisor. Whenever that happens, it means the supervisor decided to kill all of its children, or in our case, fired all of his musicians. We then add a generic error message for the rest.
terminate(normal, S) ->
  io:format("~s left the room (~s)~n",[S#state.name, S#state.role]);
terminate(bad_note, S) ->
  io:format("~s sucks! kicked that member out of the band! (~s)~n",
  [S#state.name, S#state.role]);
terminate(shutdown, S) ->
  io:format("The manager is mad and fired the whole band! "
    "~s just got back to playing in the subway~n",
    [S#state.name]);
terminate(_Reason, S) ->
  io:format("~s has been kicked out (~s)~n", [S#state.name, S#state.role]).

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


% c(musicians).
% musicians:start_link(bass, bad).
% musicians:start_link(bass, bad).
