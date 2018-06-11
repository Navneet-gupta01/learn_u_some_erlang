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
  spawn(?MODULE, fridge2, [FoodList]).

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
