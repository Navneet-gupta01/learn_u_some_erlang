-module(rpn_calculator).
-author("Navneet Gupta").
-export([calculate/1]).

% string:tokens("10 4 3 + 2 * -", " ", " ") => ["10","4","3","+","2","*","-"]
% foldl(Fun, Acc0, List) -> Acc1 => Calls Fun(Elem, AccIn) on successive elements A of List, starting with AccIn == Acc0
calculate(Str) when is_list(Str) ->
  [Res] = lists:foldl(fun calculate/2, [], string:tokens(Str, " ")),
  Res.

calculate("+", [N1,N2|S]) -> [N2+N1|S];
calculate("-", [N1,N2|S]) -> [N2-N1|S];
calculate("*", [N1,N2|S]) -> [N2*N1|S];
calculate("/", [N1,N2|S]) -> [N2/N1|S];
calculate("^", [N1,N2|S]) -> [math:pow(N2,N1)|S];
calculate("ln", [N|S])    -> [math:log(N)|S];
calculate("log10", [N|S]) -> [math:log10(N)|S];
calculate(X, Stack) -> [read(X)|Stack].


read(N) ->
  case string:to_float(N) of
    {error,no_float} -> list_to_integer(N);
    {F,_} -> F
  end.


%% Examples
%% 10 - (5 + 3 * 4)
% rpn_calculator:calculate("10 5 3 4 * + -").
