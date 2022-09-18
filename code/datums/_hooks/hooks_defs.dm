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