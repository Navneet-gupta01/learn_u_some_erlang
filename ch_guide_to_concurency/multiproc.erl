-module(multiproc).
-author("Navneet Gupta").
-export([multi/0, important/0, normal/0]).

multi() ->
  "Grt Work..".

important() ->
  receive
    {Priority, Message} when Priority > 10 ->
      [Message | important()]
      after 0 ->
        normal()
      end.

normal() ->
  receive
    {_, Message} ->
      [Message | normal()]
      after 0 ->
        []
      end.


after2(PID, Food) ->
  PID ! {self() , {store, Food}},
  receive
    {PID, Msg} -> Msg
  after 3000 ->
      timeout
  end.

preProcess(PID, Item) ->
  PID ! {self() , {take, Item}},
  receive
    {PID, Msg} -> Msg
  after 3000 ->
      timeout
  end.
