-module(curling).
-author("Navneet Gupta").
-export([start_link/2, add_points/3, next_round/1, set_teams/3, join_feed/2, leave_feed/2]).
-import(curling_scoreboard, [init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3,
terminate/2]).
-import(curling_feed,[]).


start_link(TeamA, TeamB) ->
  {ok, Pid} = gen_event:start_link(),
  gen_event:add_handler(Pid, curling_scoreboard, []),
  send_notification(Pid, {set_team, TeamA, TeamB}),
  {ok, Pid}.

add_points(Pid, Team, Point) ->
  send_notification(Pid, {add_points, Team, Point}).

next_round(Pid) ->
  send_notification(Pid, next_round).

set_teams(Pid, TeamA, TeamB) ->
  send_notification(Pid, {set_team, TeamA, TeamB}).


send_notification(Pid, Msg) ->
  gen_event:notify(Pid, Msg).

%% Subscribes the pid ToPid to the event feed.
%% The specific event handler for the newsfeed is
%% returned in case someone wants to leave
%% Pid is pid for event_manager and toPid is pid of client which want to subscribe to the events.
% If I only used the name of the module as a HandlerId, things would have still worked fine,except that we would have no control on which handler to delete when we're done with one instance of it. The event manager would just pick one of them in an undefined manner. Using a Ref makes sure that some guy from One press(P1) leaving the place donot disconnect another guy from some other Press(P2).
join_feed(Pid, ToPid) ->
  HandlerId = {curling_feed, make_ref()},
  io:fwrite("~w~n", [HandlerId]),
  gen_event:add_handler(Pid, HandlerId, [ToPid]),
  HandlerId.

% What if one of the curling feed subscribers crashes? Do we just keep the handler going on there? Ideally, we wouldn't have to. In fact, we don't have to. All that needs to be done is to change the call from gen_event:add_handler/3 to gen_event:add_sup_handler/3. If you crash, the handler is gone. Then on the opposite end, if the gen_event manager crashes, the message {gen_event_EXIT, Handler, Reason} is sent back to you so you can handle it.

leave_feed(Pid, HandlerId) ->
  gen_event:delete_handler(Pid, HandlerId, leave_feed).

% c(curling_scoreboard_hw).
% c(curling_scoreboard).
% c(curling).
% {ok, Pid} = curling:start_link("Pirates", "Scotsmen").
% curling:add_points(Pid, "Scotsmen", 2).
% curling:next_round(Pid).


% c(curling), c(curling_feed).
% {ok, Pid} = curling:start_link("Saskatchewan Roughriders", "Ottawa Roughriders").
% HandlerId = curling:join_feed(Pid, self()).
% curling:add_points(Pid, "Saskatchewan Roughriders", 2).
% flush().
% curling:leave_feed(Pid, HandlerId).
% curling:next_round(Pid).
% flush().
