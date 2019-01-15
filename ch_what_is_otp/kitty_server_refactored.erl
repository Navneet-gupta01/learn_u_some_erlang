-module(kitty_server_refactored).
-author("Navneet Gupta").
-export([handle_call/3, handle_cast/2, init/1]).
-export([start_link/0, order_cat/4, return_cat/2, close_shop/1]).
-import(common_server, [call/2, cast/2, start_link/2, reply/2]).

-record(cat, {name, color=green, description}).

%%% Client API
start_link() ->
  common_server:start_link(?MODULE, []).

%% Synchronous call
order_cat(Pid, Name, Color, Description) ->
  common_server:call(Pid, {order, Name, Color, Description}).

%% This call is asynchronous
return_cat(Pid, Cat = #cat{}) ->
  common_server:cast(Pid, {return, Cat}).

%% Synchronous call
close_shop(Pid) ->
  common_server:call(Pid, terminate).

init(_State) -> [].

handle_call({order, Name, Color, Description}, From, Cats) ->
  if Cats =:= [] ->
    common_server:reply(From, make_cat(Name, Color, Description)),
    Cats;
  Cats =/= [] -> % got to empty the stock
    common_server:reply(From, hd(Cats)),
    tl(Cats)
  end;

handle_call(terminate, From, State) ->
  common_server:reply(From, terminate),
  terminate(State).

handle_cast({return, Cat = #cat{}}, Cats) ->
  [Cat | Cats].

%%% Private functions
make_cat(Name, Col, Desc) ->
  #cat{name=Name, color=Col, description=Desc}.

terminate(Cats) ->
  [io:format("~p was set free.~n",[C#cat.name]) || C <- Cats],
  ok.

% c(kitty_server_refactored).
% rr(kitty_server_refactored).
% Pid = kitty_server_refactored:start_link().
% Cat1 = kitty_server_refactored:order_cat(Pid, carl, brown, "loves to burn bridges").
% kitty_server_refactored:return_cat(Pid, Cat1).
% kitty_server_refactored:order_cat(Pid, jimmy, orange, "cuddly").
% kitty_server_refactored:order_cat(Pid, jimmy, orange, "cuddly").
% kitty_server_refactored:return_cat(Pid, Cat1).
% kitty_server_refactored:close_shop(Pid).
% kitty_server_refactored:close_shop(Pid).
