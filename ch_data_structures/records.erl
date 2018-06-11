-module(records).
-author("Navneet Gupta").
-compile(export_all).

-record(robot,{name,
                type=industrial,
                hobbies,
                details=[]}).

first_robot() ->
  #robot{name="My First Robot",
        details=["Moved by a small man inside"]}.
