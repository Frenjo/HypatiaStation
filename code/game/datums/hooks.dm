/**
 * @file hooks.dm
 * Implements hooks, a simple way to run code on pre-defined events.
 */

/** @page hooks Code hooks
 * @section hooks Hooks
 * A hook is defined under /hook in the type tree.
 *
 * To add some code to be called by the hook, define a proc under the type, as so:
 * @code
	/hook/foo/proc/bar()
		. = TRUE // Sucessful by default.
		if(something_bad)
			return FALSE // Error, or runtime.
 * @endcode
 * All hooks must return TRUE on success, as runtimes will force return null.
 */

/**
 * Calls a hook, executing every piece of code that's attached to it.
 * @param hook	Identifier of the hook to call.
 * @returns		TRUE if all hooked code runs successfully, FALSE otherwise.
 */
/proc/call_hook(hook_path)
	. = TRUE
	var/hook/called_hook = new hook_path()
	for(var/P in typesof("[hook_path]/proc"))
		if(!call(called_hook, P)())
			error("Hook '[P]' failed or runtimed.")
			. = FALSE

/**
 * Global init hook.
 * Called in _global_init.dm when the server is initialized.
 */
/hook/global_init

/**
 * Startup hook.
 * Called in world.dm when the server starts.
 */
/hook/startup

/**
 * Roundstart hook.
 * Called in code/datums/controllers/game_ticker.dm when a round starts.
 */
/hook/roundstart

/**
 * Roundend hook.
 * Called in code/datums/controllers/game_ticker.dm when a round ends.
 */
/hook/roundend

/**
 * Shutdown hook.
 * Called in world.dm when world/Del is called.
 */
/hook/shutdown