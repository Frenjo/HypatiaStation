GLOBAL_GLOBL_LIST_NEW(bombers)
GLOBAL_GLOBL_LIST_NEW(admin_log)
GLOBAL_GLOBL_LIST_NEW(lastsignalers)	// Keeps the last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
GLOBAL_GLOBL_LIST_NEW(lawchanges)		// Stores who uploaded laws to which silicon-based lifeform, and what the law was.

var/list/combatlog = list()
var/list/IClog = list()
var/list/OOClog = list()
var/list/adminlog = list()