-module(ppool_supersup).
-behaviour(supervisor).
-export([start_link/0, stop/0, start_pool/3, stop_pool/1]).
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ppool}, ?MODULE, []).

stop() ->
  case whereis(ppool) of
    P when is_pid(P) ->
      exit(P, kill);
    _ -> ok
  end.

init([]) ->
  MaxRestart = 6,
  MaxTime = 3600,
  {ok, {{one_for_one, MaxRestart, MaxTime}, []}}.

start_pool(_A,_B,_C) ->
  io:format("Starting Pool~n",[]).

stop_pool(A) ->
  io:format("Stoping Pool ~s~n",A).
