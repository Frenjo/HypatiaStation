/*
 * Output Macros
 */
#define SHOW_BROWSER(TARGET, CONTENT, OPTIONS) TARGET << browse(CONTENT, OPTIONS)
#define CLOSE_BROWSER(TARGET, NAME) TARGET << browse(null, NAME)
#define SEND_RSC(TARGET, CONTENT, NAME) TARGET << browse_rsc(CONTENT, NAME)
#define OPEN_LINK(TARGET, URL) TARGET << link(URL)
#define OPEN_FILE(TARGET, FILE) TARGET << run(FILE)

/proc/html_icon(thing) // Proc instead of macro to avoid precompiler problems.
	. = "\icon[thing]"

/proc/to_chat(atom/target, message)
	target << message

/proc/to_world(message)
	for_no_type_check(var/client/C, GLOBL.clients)
		to_chat(C, message)