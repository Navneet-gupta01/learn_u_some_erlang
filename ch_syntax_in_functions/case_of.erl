-module(case_of).
-author("Navneet Gupta").
-export([insert/2, beach/1]).

insert(X,[]) ->
  [X];
insert(X,Set) ->
  case lists:member(X,Set) of
    true  -> Set;
    false -> [X|Set]
  end.

beach(Temperature) ->
  case Temperature of
    {celsius, N} when N >= 20, N =< 45 ->
      'favorable';
    {kelvin, N} when N >= 293, N =< 318 ->
      'scientifically favorable';
    {fahrenheit, N} when N >= 68, N =< 113 ->
      'favorable in the US';
    _ ->
      'avoid beach'
  end.


% c("case_of").
% L = case_of:insert(1, []).
% L = case_of:insert(2, L).  // will throw error since L(LHS) is binded to [1] and RHS is equal to [2,1]. need to assign it to something else
