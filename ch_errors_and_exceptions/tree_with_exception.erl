-module(tree_with_exception).
-author("Navneet Gupta").
-export([empty/0, insert/3, lookup/2,has_value/2,has_value_opt/2]).



empty() -> {node, nil}.

insert(Key, Val, {node, nil}) ->
    {node, {Key, Val, {node, nil}, {node, nil}}};
insert(NewKey, NewVal, {node, {Key, Val, Left, Right}}) when NewKey < Key ->
    {node, {Key, Val, insert(NewKey, NewVal, Left), Right}};
insert(NewKey, NewVal, {node, {Key, Val, Left, Right}}) when NewKey > Key ->
    {node, {Key, Val, Left, insert(NewKey, NewVal, Right)}};
insert(Key, Val, {node, {Key, _, Left, Right}}) ->
    {node, {Key, Val, Left, Right}}.

lookup(_, {node, nil}) ->
    undefined;
lookup(Key, {node, {Key, Val, _, _}}) ->
    {ok, Val};
lookup(Key, {node, {NodeKey, _, Left, _}}) when Key < NodeKey ->
    lookup(Key, Left);
lookup(Key, {node, {_, _, _, Right}}) ->
    lookup(Key, Right).

%Without Exception Handling lookup
has_value(_, {node, 'nil'}) ->
  false;
has_value(Val, {node, {_, Val, _, _}}) ->
  true;
has_value(Val, {node, {_, _, Left, Right}}) ->
  case has_value(Val, Left) of
  true -> true;
  false -> has_value(Val, Right)
  end.


% The problem with above implementation is that every node of the tree we
% branch at has to test for the result of the previous branch:
% With the help of throws, we can make something that will require less comparisons:
% With Exception Handling lookup

has_value_opt(Val, Tree) ->
  try has_value1(Val, Tree) of
    false -> false
    catch
      true -> true
    end.

has_value1(_, {node, 'nil'}) ->
  false;
has_value1(Val, {node, {_, Val, _, _}}) ->
  throw(true);
has_value1(Val, {node, {_, _, Left, Right}}) ->
  has_value1(Val, Left),
  has_value1(Val, Right).
