-module(exceptions).
-author("Navneet Gupta").
-compile(export_all).

throws(F) ->
  try F() of
    _ -> ok
  catch
    Throw -> {throw, caught, Throw}
  end.


errors(F) ->
  try F() of
    _ -> ok
  catch
    error:Error -> {error, caught, Error}
  end.

exits(F) ->
  try F() of
    _ -> ok
  catch
    exit:Exit -> {exit, caught, Exit}
  end.


%% Examples::
% c(exceptions).
% exceptions:throws(fun() -> throw(thrown) end).
% exceptions:throws(fun() -> error(error) end).
% exceptions:throws(fun() -> erlang:error(pang) end).
% exceptions:errors(fun() -> erlang:error("Die!") end).
% exceptions:exits(fun() -> exit(goodbye) end).


sword(1) -> throw(slice);
sword(2) -> erlang:error(cut_arm);
sword(3) -> exit(cut_leg);
sword(4) -> throw(punch);
sword(5) -> exit(cross_bridge).

black_knight(Attack) when is_function(Attack, 0) ->
    try Attack() of
      _ -> "None shall pass."
    catch
      throw:slice -> "It is but a scratch.";
      error:cut_arm -> "I've had worse.";
      exit:cut_leg -> "Come on you pansy!";
        _:_ -> "Just a flesh wound."
    after
      "This Will Always Print..."
    end.

talk() -> "blah blah".


%% Examples::
% c(exceptions).
% exceptions:talk().
% exceptions:black_knight(fun() -> exceptions:sword(1) end).
% exceptions:black_knight(fun() -> exceptions:sword(2) end).
% exceptions:black_knight(fun() -> exceptions:sword(3) end).
% exceptions:black_knight(fun() -> exceptions:sword(4) end).
% exceptions:black_knight(fun() -> exceptions:sword(5) end).
