// Ported 'shuttles' module from Heaven's Gate - NSS Eternal...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

/obj/machinery/computer/shuttle_control/mining
	name = "mining shuttle control console"
	shuttle_tag = "Mining"
	req_access = list(access_mining)
	circuit = /obj/item/weapon/circuitboard/mining_shuttle

/obj/machinery/computer/shuttle_control/engineering
	name = "engineering shuttle control console"
	shuttle_tag = "Engineering"
	req_one_access = list(access_engine_equip, access_atmospherics)
	circuit = /obj/item/weapon/circuitboard/engineering_shuttle

/obj/machinery/computer/shuttle_control/research
	name = "research shuttle control console"
	shuttle_tag = "Research"
	req_access = list(access_research)
	circuit = /obj/item/weapon/circuitboard/research_shuttle

/obj/machinery/computer/shuttle_control/prison
	name = "prison shuttle control console"
	shuttle_tag = "Prison"
	req_access = list(access_security)