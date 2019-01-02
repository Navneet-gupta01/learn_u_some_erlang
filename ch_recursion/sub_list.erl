-module(sub_list).
-author("Navneet Gupta").
-export([sublist/2]).
-import(tail_reverse, [reverse/1]).

sublist(L, N) -> tail_reverse:reverse(sub_list_rec(L, N, [])).

sub_list_rec(_, 0, A) -> A;
sub_list_rec([], _, A) -> A;
sub_list_rec([H | T], N, A) -> sub_list_rec(T, N-1, [H | A]).
