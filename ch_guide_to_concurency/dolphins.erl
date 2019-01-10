-module(dolphins).
-author("Navneet Gupta").
-export([work/0,dolphin1/0,dolphin2/0,dolphin3/0]).


work() ->
  "Grt Its Worked.".

dolphin1() ->
  receive
    do_a_flip ->
      io:format("How about no?~n");
    fish ->
      io:format("So long and thanks for all the fish!~n");
    _ ->
      io:format("Heh, we're smarter than you humans.~n")
    end.

dolphin2() ->
  receive
    {From, do_a_flip} ->
      From ! "How about no?";
    {From, fish} ->
      From ! "So long and thanks for all the fish!";
    {From, _} ->
      From ! "Heh, we're smarter than you humans.~n"
    end.


dolphin3() ->
  receive
    {From, do_a_flip} ->
      From ! "How about no?",
      dolphin3();
    {From, fish} ->
      From ! "So long and thanks for all the fish!";
    _ ->
      io:format("Heh, we're smarter than you humans.~n"),
      dolphin3()
  end.

%
% c("dolphins").
% dolphins:work().
% Dolphin = spawn(dolphins, dolphin1, []).
% Dolphin ! fish -- Only first message sent will work after that process will end since its not in loop
