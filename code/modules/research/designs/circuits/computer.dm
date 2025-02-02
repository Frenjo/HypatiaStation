///////////////////////////////////////
////////// Computer Circuits //////////
///////////////////////////////////////
/datum/design/circuit/seccamera
	name = "Circuit Design (Security)"
	desc = "Allows for the construction of circuit boards used to build security camera computers."
	build_path = /obj/item/circuitboard/security

/datum/design/circuit/aicore
	name = "Circuit Design (AI Core)"
	desc = "Allows for the construction of circuit boards used to build new AI cores."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/aicore

/datum/design/circuit/aiupload
	name = "Circuit Design (AI Upload)"
	desc = "Allows for the construction of circuit boards used to build an AI Upload Console."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/aiupload

/datum/design/circuit/borgupload
	name = "Circuit Design (Cyborg Upload)"
	desc = "Allows for the construction of circuit boards used to build a Cyborg Upload Console."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/borgupload

/datum/design/circuit/med_data
	name = "Circuit Design (Medical Records)"
	desc = "Allows for the construction of circuit boards used to build a medical records console."
	build_path = /obj/item/circuitboard/med_data

/datum/design/circuit/operating
	name = "Circuit Design (Operating Computer)"
	desc = "Allows for the construction of circuit boards used to build an operating computer console."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/operating

/datum/design/circuit/pandemic
	name = "Circuit Design (PanD.E.M.I.C. 2200)"
	desc = "Allows for the construction of circuit boards used to build a PanD.E.M.I.C. 2200 console."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/pandemic

/datum/design/circuit/scan_console
	name = "Circuit Design (DNA Machine)"
	desc = "Allows for the construction of circuit boards used to build a new DNA scanning console."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/scan_consolenew

/datum/design/circuit/comconsole
	name = "Circuit Design (Communications)"
	desc = "Allows for the construction of circuit boards used to build a communications console."
	req_tech = list(/decl/tech/magnets = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/communications

/datum/design/circuit/idcardconsole
	name = "Circuit Design (ID Computer)"
	desc = "Allows for the construction of circuit boards used to build an ID computer."
	build_path = /obj/item/circuitboard/card

/datum/design/circuit/crewconsole
	name = "Circuit Design (Crew monitoring computer)"
	desc = "Allows for the construction of circuit boards used to build a Crew monitoring computer."
	req_tech = list(/decl/tech/magnets = 2, /decl/tech/biotech = 2, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/crew

/datum/design/circuit/teleconsole
	name = "Circuit Design (Teleporter Console)"
	desc = "Allows for the construction of circuit boards used to build a teleporter control console."
	req_tech = list(/decl/tech/programming = 3, /decl/tech/bluespace = 2)
	build_path = /obj/item/circuitboard/teleporter

/datum/design/circuit/secdata
	name = "Circuit Design (Security Records Console)"
	desc = "Allows for the construction of circuit boards used to build a security records console."
	build_path = /obj/item/circuitboard/secure_data

/datum/design/circuit/atmosalerts
	name = "Circuit Design (Atmosphere Alert)"
	desc = "Allows for the construction of circuit boards used to build an atmosphere alert console.."
	build_path = /obj/item/circuitboard/atmos_alert

/datum/design/circuit/air_management
	name = "Circuit Design (Atmospheric Monitor)"
	desc = "Allows for the construction of circuit boards used to build an Atmospheric Monitor."
	build_path = /obj/item/circuitboard/air_management

/* Uncomment if someone makes these buildable
/datum/design/circuit/general_alert
	name = "Circuit Design (General Alert Console)"
	desc = "Allows for the construction of circuit boards used to build a General Alert console."
	build_path = /obj/item/circuitboard/general_alert
*/

/datum/design/circuit/robocontrol
	name = "Circuit Design (Robotics Control Console)"
	desc = "Allows for the construction of circuit boards used to build a Robotics Control console."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/robotics

/datum/design/circuit/clonecontrol
	name = "Circuit Design (Cloning Machine Console)"
	desc = "Allows for the construction of circuit boards used to build a new Cloning Machine console."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/cloning

/datum/design/circuit/clonepod
	name = "Circuit Design (Clone Pod)"
	desc = "Allows for the construction of circuit boards used to build a Cloning Pod."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/clonepod

/datum/design/circuit/clonescanner
	name = "Circuit Design (Cloning Scanner)"
	desc = "Allows for the construction of circuit boards used to build a Cloning Scanner."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/clonescanner

/datum/design/circuit/arcademachine
	name = "Circuit Design (Arcade Machine)"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	req_tech = list(/decl/tech/programming = 1)
	build_path = /obj/item/circuitboard/arcade

/datum/design/circuit/powermonitor
	name = "Circuit Design (Power Monitor)"
	desc = "Allows for the construction of circuit boards used to build a new power monitor"
	build_path = /obj/item/circuitboard/powermonitor

/datum/design/circuit/solarcontrol
	name = "Circuit Design (Solar Control)"
	desc = "Allows for the construction of circuit boards used to build a solar control console"
	req_tech = list(/decl/tech/power_storage = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/solar_control

/datum/design/circuit/prisonmanage
	name = "Circuit Design (Prisoner Management Console)"
	desc = "Allows for the construction of circuit boards used to build a prisoner management console."
	build_path = /obj/item/circuitboard/prisoner

/datum/design/circuit/mechacontrol
	name = "Circuit Design (Exosuit Control Console)"
	desc = "Allows for the construction of circuit boards used to build an exosuit control console."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha_control

/datum/design/circuit/mechapower
	name = "Circuit Design (Mech Bay Power Control Console)"
	desc = "Allows for the construction of circuit boards used to build a mech bay power control console."
	req_tech = list(/decl/tech/power_storage = 3, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/mech_bay_power_console

/datum/design/circuit/rdconsole
	name = "Circuit Design (R&D Console)"
	desc = "Allows for the construction of circuit boards used to build a new R&D console."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/rdconsole

/datum/design/circuit/ordercomp
	name = "Circuit Design (Supply ordering console)"
	desc = "Allows for the construction of circuit boards used to build a Supply ordering console."
	build_path = /obj/item/circuitboard/ordercomp

/datum/design/circuit/supplycomp
	name = "Circuit Design (Supply shuttle console)"
	desc = "Allows for the construction of circuit boards used to build a Supply shuttle console."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/supplycomp

/datum/design/circuit/comm_monitor
	name = "Circuit Design (Telecommunications Monitoring Console)"
	desc = "Allows for the construction of circuit boards used to build a telecommunications monitor."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/comm_monitor

/datum/design/circuit/comm_server
	name = "Circuit Design (Telecommunications Server Monitoring Console)"
	desc = "Allows for the construction of circuit boards used to build a telecommunication server browser and monitor."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/comm_server

/datum/design/circuit/message_monitor
	name = "Circuit Design (Messaging Monitor Console)"
	desc = "Allows for the construction of circuit boards used to build a messaging monitor console."
	req_tech = list(/decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/message_monitor

/datum/design/circuit/aifixer
	name = "Circuit Design (AI Integrity Restorer)"
	desc = "Allows for the construction of circuit boards used to build an AI Integrity Restorer."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/aifixer