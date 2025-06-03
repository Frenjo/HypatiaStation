// Ported 'shuttles' module from Heaven's Gate - NSS Eternal...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

/obj/machinery/computer/shuttle_control/multi/vox
	name = "skipjack control console"
	req_access = list(ACCESS_SYNDICATE)
	shuttle_tag = "Vox Skipjack"

/obj/machinery/computer/shuttle_control/multi/syndicate
	name = "mercenary shuttle control console"
	req_access = list(ACCESS_SYNDICATE)
	shuttle_tag = "Mercenary"