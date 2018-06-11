-module(included_record).
-author("Navneet Gupta").
-compile(export_all).
-include("record_hdr.hrl").

included() ->
  #included{some_field="Some value"}.
