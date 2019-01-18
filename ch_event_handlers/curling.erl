-module(curling).
-author("Navneet Gupta").
-export([start_link/2, add_points/3, next_round/1, set_teams/3, join_feed/2, leave_feed/2]).
-import(curling_scoreboard, [init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3,
terminate/2]).


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

join_feed(Pid, ToPid) ->
  HandlerId = {curling_feed, make_ref()},
  gen_event:add_handler(Pid, HandlerId, [ToPid]),
  HandlerId.

leave_feed(Pid, HandlerId) ->
  gen_event:delete_handler(Pid, HandlerId, leave_feed).

% c(curling_scoreboard_hw).
% c(curling_scoreboard).
% c(curling).
% {ok, Pid} = curling:start_link("Pirates", "Scotsmen").
% curling:add_points(Pid, "Scotsmen", 2).
% curling:next_round(Pid).
