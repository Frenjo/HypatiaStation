///////////////////////////////////////
////////// Subspace Telecoms //////////
///////////////////////////////////////
/datum/design/circuit/subspace_receiver
	name = "Circuit Design (Subspace Receiver)"
	desc = "Allows for the construction of Subspace Receiver equipment."
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 4, /datum/tech/bluespace = 2)
	build_path = /obj/item/circuitboard/telecoms/receiver

/datum/design/circuit/telecoms_bus
	name = "Circuit Design (Bus Mainframe)"
	desc = "Allows for the construction of Telecommunications Bus Mainframes."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/telecoms/bus

/datum/design/circuit/telecoms_hub
	name = "Circuit Design (Hub Mainframe)"
	desc = "Allows for the construction of Telecommunications Hub Mainframes."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/telecoms/hub

/datum/design/circuit/telecoms_relay
	name = "Circuit Design (Relay Mainframe)"
	desc = "Allows for the construction of Telecommunications Relay Mainframes."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 3, /datum/tech/bluespace = 3)
	build_path = /obj/item/circuitboard/telecoms/relay

/datum/design/circuit/telecoms_processor
	name = "Circuit Design (Processor Unit)"
	desc = "Allows for the construction of Telecommunications Processor equipment."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/telecoms/processor

/datum/design/circuit/telecoms_server
	name = "Circuit Design (Server Mainframe)"
	desc = "Allows for the construction of Telecommunications Servers."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/telecoms/server

/datum/design/circuit/subspace_broadcaster
	name = "Circuit Design (Subspace Broadcaster)"
	desc = "Allows for the construction of Subspace Broadcasting equipment."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4, /datum/tech/bluespace = 2)
	build_path = /obj/item/circuitboard/telecoms/broadcaster