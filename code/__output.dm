/*
 * Output Macros
 */
#define OPEN_LINK(TARGET, URL) TARGET << link(URL)
#define OPEN_FILE(TARGET, FILE) TARGET << run(FILE)

/proc/html_icon(thing) // Proc instead of macro to avoid precompiler problems.
	. = "\icon[thing]"

/proc/to_chat(atom/target, message)
	target << message

/proc/to_world(message)
	for_no_type_check(var/client/C, GLOBL.clients)
		to_chat(C, message)