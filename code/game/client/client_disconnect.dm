/*
 * Disconnect
 */
/client/Del()
	if(isnotnull(holder))
		holder.owner = null
		GLOBL.admins.Remove(src)
	GLOBL.directory.Remove(ckey)
	GLOBL.clients.Remove(src)
	return ..()