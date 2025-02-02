///////////////////////////////////////
////////// Subspace Telecoms //////////
///////////////////////////////////////
/datum/design/circuit/subspace_receiver
	name = "Subspace Receiver"
	desc = "Allows for the construction of circuit boards used to build a subspace receiver."
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 4, /decl/tech/bluespace = 2)
	build_path = /obj/item/circuitboard/telecoms/receiver

/datum/design/circuit/telecoms_bus
	name = "Bus Mainframe"
	desc = "Allows for the construction of circuit boards used to build a telecommunications bus mainframe."
	req_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/telecoms/bus

/datum/design/circuit/telecoms_hub
	name = "Hub Mainframe"
	desc = "Allows for the construction of circuit boards used to build a telecommunications hub mainframe."
	req_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/telecoms/hub

/datum/design/circuit/telecoms_relay
	name = "Relay Mainframe"
	desc = "Allows for the construction of circuit boards used to build a telecommunications relay mainframe."
	req_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 3, /decl/tech/bluespace = 3)
	build_path = /obj/item/circuitboard/telecoms/relay

/datum/design/circuit/telecoms_processor
	name = "Processor Unit"
	desc = "Allows for the construction of circuit boards used to build a telecommunications processor."
	req_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/telecoms/processor

/datum/design/circuit/telecoms_server
	name = "Server Mainframe"
	desc = "Allows for the construction of circuit boards used to build a telecommunications server."
	req_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/telecoms/server

/datum/design/circuit/subspace_broadcaster
	name = "Subspace Broadcaster"
	desc = "Allows for the construction of circuit boards used to build a subspace broadcaster."
	req_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4, /decl/tech/bluespace = 2)
	build_path = /obj/item/circuitboard/telecoms/broadcaster