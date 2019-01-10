-module(kitchen).
-author("Navneet Gupta").
-export([fridge/0,fridge1/1,store/2,take/2, start/1,store2/2, take2/2]).

fridge() ->
  receive
    {From, {store, _Food}} ->
      From ! {self(), ok},
      fridge();
    {From, {take, _Food}} ->
      From ! {self() , not_found},
      fridge();
    terminate ->
      io:format("Fridge is getting Old. Will be Down in some Time.~n"),
      ok
    end.

fridge1(FoodItems) ->
  receive
    {From, {store, Food}} ->
      From ! {self(), ok},
      fridge1([Food | FoodItems]);
    {From, {take, Food}} ->
      case lists:member(Food, FoodItems) of
        true ->
          From ! {self(), {ok, Food}},
          fridge1(lists:delete(Food, FoodItems));
        false ->
          From ! {self(), not_found},
          fridge1(FoodItems)
      end;
    terminate ->
      io:format("Fridge is getting Old. Will be Down in some Time.~n"),
      ok
  end.

store(PID, Food) ->
  PID ! {self() , {store, Food}},
  receive
    {PID, Msg} -> Msg
  end.

take(PID, Food) ->
  PID ! {self() , {take, Food}},
  receive
    {PID, Msg} -> Msg
  end.

start(FoodList) ->
  spawn(?MODULE, fridge1, [FoodList]).

store2(PID, Food) ->
  PID ! {self() , {store, Food}},
  receive
    {PID, Msg} -> Msg
  after 3000 ->
      timeout
  end.

take2(PID, Food) ->
  PID ! {self() , {take, Food}},
  receive
    {PID, Msg} -> Msg
  after 3000 ->
    timeout
  end.


% c(kitchen).
% Kitchen = spawn(kitchen, fridge1, [[]]).
% Kitchen ! {self(), {store, milk}}.
% Kitchen ! {self(), {take, bread}}.
% flush().
% f().
% Pid = spawn(kitchen, fridge1, [[baking_soda]]).
% kitchen:store2(Pid, potato).
% kitchen:store2(Pid, bread).
% kitchen:store2(Pid, egg).
% kitchen:take2(Pid, egg2).
% kitchen:take2(Pid, potato).
% f().
% Pid = kitchen:start([baking_soda]).
% kitchen:store2(Pid, potato).
% kitchen:store2(Pid, bread).
% kitchen:store2(Pid, egg).
% kitchen:take2(Pid, egg2).
% kitchen:take2(Pid, potato).
% kitchen:take2(pid(0,250,0), potato).
