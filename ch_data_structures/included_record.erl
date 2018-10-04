-module(included_record).
-author("Navneet Gupta").
-compile(export_all).
-include("record_hdr.hrl").

included() ->
  #included{some_field="Some value"}. %% To use a record we use the symbol #{record_name}{field={updated_value_for_the_field}}
