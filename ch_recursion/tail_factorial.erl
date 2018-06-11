-module(tail_factorial).
-author("Navneet Gupta").
-export([fact/1]).

fact(N) -> factorial(N,1).

factorial(0,A) -> A;
factorial(X,A) -> factorial(X-1,X*A).
