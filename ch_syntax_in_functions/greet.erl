-module(greet).
-author("Navneet Gupta").
-export([greet/2]).


greet(male, Name) ->
  io:format("Hello, Mr. ~s!~n", [Name]);
greet(female, Name) ->
  io:format("Hello, Mrs. ~s!~n", [Name]);
greet(_, Name) ->
  io:format("Hello, ~s!~n", [Name]).


% function greet(Gender,Name)
%    if Gender == male then
%        print("Hello, Mr. %s!", Name)
%    else if Gender == female then
%        print("Hello, Mrs. %s!", Name)
%    else
%        print("Hello, %s!", Name)
% end

% Each of these function declarations is called a function clause. Function clauses must be separated by semicolons (;)
% and together form a function declaration. A function declaration counts as one larger statement, and it's why the final
% function clause ends with a period. It's a "funny" use of tokens to determine workflow, but you'll get used to it.
%% At least you'd better hope so because there's no way out of it!
