// A bunch of defines for the SpacemanDMM linter to use.
// When the linter isn't in use, they're defined to nothing.

// The SPACEMAN_DMM define is set by the linter and other tooling when it runs.
#ifdef SPACEMAN_DMM

	/*
	 * If set, will enable a diagnostic on children of the proc it is set on which do
	 * not contain any `..()` parent calls. This can help with finding situations
	 * where a signal or other important handling in the parent proc is being skipped.
	 * Child procs may set this setting to FALSE instead to override the check.
	 */
	#define SHOULD_CALL_PARENT(X) set SpacemanDMM_should_call_parent = X

#else

	#define SHOULD_CALL_PARENT(X)

#endif