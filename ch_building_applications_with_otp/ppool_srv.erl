-module(ppool_srv).
-behaviour(gen_server).
-export([start/4, start_link/4, run/2, sync_queue/2, async_queue/2, stop/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,code_change/3, terminate/2]).

start(Name, Limit, Sup, MFA) when is_atom(Name), is_integer(Limit) ->
  gen_server:start({local, Name}, ?MODULE, {Limit, MFA, Sup}, []).

start_link(Name, Limit, Sup, MFA) when is_atom(Name), is_integer(Limit) ->
  gen_server:start_link({local, Name}, ?MODULE, {Limit, MFA, Sup}, []).

run(Name, Args) ->
  gen_server:call(Name, {run, Args}).

sync_queue(Name, Args) ->
  gen_server:call(Name, {sync, Args}, infinity).

async_queue(Name, Args) ->
  gen_server:cast(Name, {async, Args}).

stop(Name) ->
  gen_server:call(Name, stop).

init([]) ->
  io:format("ppool_server init/1 function~n").

handle_call(_MSG, _From, _State) ->
  io:format("ppool_server handle_call/3~n").

handle_cast(_Msg, _State) ->
  io:format("ppool_server handle_cast/2~n").

handle_info(_Msg, _State) ->
  io:format("ppool_server handle_info/2~n").

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

terminate(_Reason, _S) ->
  io:format("ppool_server terminate/2~n").
