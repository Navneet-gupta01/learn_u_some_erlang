-module(factorial).
-author("Navneet Gupta").
-export([factorial/1]).

factorial(0) -> 1;
factorial(A) when A > 0 -> A*factorial(A-1).
