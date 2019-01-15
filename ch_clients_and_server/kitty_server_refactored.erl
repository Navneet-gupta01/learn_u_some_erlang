-module(kitty_server_refactored).
-author("Navneet Gupta").
-behaviour(gen_server).
-export([start_link/0, order_cat/4, return_cat/2, close_shop/1]).
-export([handle_call/3, handle_cast/2, init/1, handle_info/2, terminate/2, code_change/3]).
% -import(common_server, [call/2, cast/2, start_link/2, reply/2]).

-record(cat, {name, color=green, description}).

%%% Client API
start_link() ->
  gen_server:start_link(?MODULE, [], []).
% The first parameter is the callback module, the second one is the list of parameters to pass to init/1 and the third one is about debugging options that won't be covered right now
% You could add a fourth parameter in the first position, which would be the name to register the server with

%% Synchronous call
order_cat(Pid, Name, Color, Description) ->
  gen_server:call(Pid, {order, Name, Color, Description}).

%% This call is asynchronous
return_cat(Pid, Cat = #cat{}) ->
  gen_server:cast(Pid, {return, Cat}).

%% Synchronous call
close_shop(Pid) ->
  gen_server:call(Pid, terminate).

% a third parameter can be passed to gen_server:call/2-3 to give a timeout. If you don't give a timeout to the function (or the atom infinity), the default is set to 5 seconds. If no reply is received before time is up, the call crashes.

init(_State) -> {ok, []}.

handle_call({order, Name, Color, Description}, _From, Cats) ->
  if Cats =:= [] ->
    {reply, make_cat(Name, Color, Description), Cats};
  Cats =/= [] -> % got to empty the stock
    {reply, hd(Cats), tl(Cats)}
  end;

handle_call(terminate, _From, Cats) ->
  {stop, normal, ok, Cats}.

handle_cast({return, Cat = #cat{}}, Cats) ->
  {noreply, [Cat | Cats]}.

handle_info(Msg, Cats) ->
  io:format("Unexpected message: ~p~n",[Msg]),
  {noreply, Cats}.

%%% Private functions
make_cat(Name, Col, Desc) ->
  #cat{name=Name, color=Col, description=Desc}.

terminate(normal, Cats) ->
  [io:format("~p was set free.~n",[C#cat.name]) || C <- Cats],
  ok.

code_change(_OldVsn, State, _Extra) ->
  %% No change planned. The function is there for the behaviour,
  %% but will not be used. Only a version on the next
  {ok, State}.

% c(kitty_server_refactored).
% rr(kitty_server_refactored).
% {ok, Pid} = kitty_server_refactored:start_link().
% Cat1 = kitty_server_refactored:order_cat(Pid, carl, brown, "loves to burn bridges").
% kitty_server_refactored:return_cat(Pid, Cat1).
% kitty_server_refactored:order_cat(Pid, jimmy, orange, "cuddly").
% kitty_server_refactored:order_cat(Pid, jimmy, orange, "cuddly").
% kitty_server_refactored:return_cat(Pid, Cat1).
% kitty_server_refactored:close_shop(Pid).
% kitty_server_refactored:close_shop(Pid).
