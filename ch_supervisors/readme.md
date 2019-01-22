* our supervisors would start a worker process, link to it, and trap exit signals with process_flag(trap_exit,true) to know when the process died and restart it.

* The OTP supervisors, fortunately, provide the flexibility to handle such cases (and more). They let you define how many times a worker should be restarted in a given period of time before giving up. They let you have more than one worker per supervisor and even let you pick between a few patterns to determine how they should depend on each other in case of a failure.
