-module(ppool_sup).
-export([start_link/3, init/1]).
-behaviour(supervisor).

%% Suerpvisor start_link
% start_link(Module, Args) -> startlink_ret()
% start_link(SupName, Module, Args) -> startlink_ret()
% Args is passed to init/1 function of the MODULE
start_link(Name, Limit, MFA) ->
  supervisor:start_link(?MODULE, {Name, Limit, MFA}).

init({Name, Limit, MFA}) ->
  MaxRestart = 1,
  MaxTime = 3600,
  {ok, {{one_for_all, MaxRestart, MaxTime},
  [{serv,
    {ppool_serv, start_link, [Name, Limit, self(), MFA]},
      permanent,
      5000, % Shutdown time
      worker,
      [ppool_serv]}]}}.
