-module(multiproc).
-author("Navneet Gupta").
-export([multi/0, important/0, normal/0]).

multi() ->
  "Grt Work..".

% Be aware with selective recieve as the every time with a loop of recieve msg is read from teh oldest msg till there is a pattern match and it is removed . If there are lot of message then it takes lot of processing to find the only appropriate msg, leading to unnecessary processing time
% In the drawing above, imagine we want the 367th message, but the first 366 are junk ignored by our code. To get the 367th message, the process needs to try to match the 366 first ones. Once it's done and they've all been put in the queue, the 367th message is taken out and the first 366 are put back on top of the mailbox. The next useful message could be burrowed much deeper and take even longer to be found.

% This kind of receive is a frequent cause of performance problems in Erlang. If your application is running slow and you know there are lots of messages going around, this could be the cause.
% receive
%     Pattern1 -> Expression1;
%     Pattern2 -> Expression2;
%     Pattern3 -> Expression3;
%     ...
%     PatternN -> ExpressionN;
%     Unexpected ->
%         io:format("unexpected message ~p~n", [Unexpected])
% end.

% The Unexpected variable will match anything, take the unexpected message out of the mailbox and show a warning. Depending on your application, you might want to store the message into some kind of logging facility where you will be able to find information about it later on:
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
  PID ! {self(), {store, Food}},
  receive
    {PID, Msg} -> Msg
  after 3000 ->
      timeout
  end.

preProcess(PID, Item) ->
  PID ! {self(), {take, Item}},
  receive
    {PID, Msg} -> Msg
  after 3000 ->
      timeout
  end.

%% optimized in R14A
% Since R14A, a new optimization has been added to Erlang's compiler. It simplifies selective receives in very specific cases of back-and-forth communications between processes.
% To make it work, a reference (make_ref()) has to be created in a function and then sent in a message. In the same function, a selective receive is then made. If no message can match unless it contains the same reference, the compiler automatically makes sure the VM will skip messages received before the creation of that reference.

optimized(Pid) ->
  Ref = make_ref(),
  Pid ! {self(), Ref, hello},
  receive
    {Pid, Ref, Msg} ->
        io:format("~p~n", [Msg])
  end.
