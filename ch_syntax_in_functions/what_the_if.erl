-module(what_the_if).
-author("Navneet Gupta").
-export([heh_fine/0, oh_god/1, help_me/1]).

heh_fine() ->
    if 1 =:= 1 ->
        works
    end,
    if 1 =:= 2; 1 =:= 1 ->
        works2
    end.
    % if 1 =:= 2, 1 =:= 1 ->
    %     fails
    % end.
    % Shows compiler warning as 1=:=2 andalso 1=:=1 is always false since 1=:=2 is always false.
    % Sp this clause will never be executed. but if u put ,(andalso) with ;(orelse) it wouldnot show any warnings


oh_god(N) ->
    if N =:= 2 -> might_succeed;
       true -> always_does  %% this is Erlang's if's 'else!'
    end.

%% note, this one would be better as a pattern match in function heads!
%% I'm doing it this way for the sake of the example.
help_me(Animal) ->
    Talk = if Animal == cat  -> "meow";
              Animal == beef -> "mooo";
              Animal == dog  -> "bark";
              Animal == tree -> "bark";
              true -> "fgdadfgna"
           end,
    {Animal, "says " ++ Talk ++ "!"}.
