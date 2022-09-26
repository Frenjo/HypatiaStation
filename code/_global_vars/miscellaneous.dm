GLOBAL_GLOBL_INIT(defer_powernet_rebuild, 0)	// 1 if net rebuild will be called manually after an event.

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
GLOBAL_GLOBL_INIT(fileaccess_timer, 0)
GLOBAL_GLOBL_INIT(custom_event_msg, null)

GLOBAL_GLOBL_INIT(normal_ooc_colour, "#002eb8")