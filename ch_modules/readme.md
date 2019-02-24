#Ch Modules

-- module(Name)
* Name is an atom.

-- To call A function 'F' in a module 'M' accepting Arguments 'A'
* M:F(A) form, where M is the module name, F the function, and A the arguments.

-- Compiling  
* c(module_name).

```erlang
right_age(X) when X >= 16, X =< 104 ->
  true;
right_age(_) ->
  false.
```

The comma (,) acts in a similar manner to the operator andalso and the semicolon (;) acts a bit like orelse 

*  comparing , and ; in guards to the operators andalso and orelse. They're not exactly the same, though. The former pair will catch exceptions as they happen while the latter won't. What this means is that if there is an error thrown in the first part of the guard X >= N; N >= 0, the second part can still be evaluated and the guard might succeed; if an error was thrown in the first part of X >= N orelse N >= 0, the second part will also be skipped and the whole guard will fail.

* However (there is always a 'however'), only andalso and orelse can be nested inside guards. This means (A orelse B) andalso C is a valid guard, while (A; B), Cis not.
