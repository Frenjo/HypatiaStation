///////////////////////////////////////
////////// Computer Circuits //////////
///////////////////////////////////////
/datum/design/circuit/seccamera
	name = "Security Camera Console"
	desc = "Allows for the construction of circuit boards used to build a security camera console."
	build_path = /obj/item/circuitboard/security

/datum/design/circuit/aicore
	name = "AI Core"
	desc = "Allows for the construction of circuit boards used to build an AI core."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/aicore

/datum/design/circuit/aiupload
	name = "AI Upload Console"
	desc = "Allows for the construction of circuit boards used to build an AI upload console."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/aiupload

/datum/design/circuit/borgupload
	name = "Cyborg Upload Console"
	desc = "Allows for the construction of circuit boards used to build a cyborg upload console."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/borgupload

/datum/design/circuit/med_data
	name = "Medical Records Console"
	desc = "Allows for the construction of circuit boards used to build a medical records console."
	build_path = /obj/item/circuitboard/med_data

/datum/design/circuit/operating
	name = "Operating Computer"
	desc = "Allows for the construction of circuit boards used to build an operating computer."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/operating

/datum/design/circuit/pandemic
	name = "PanD.E.M.I.C. 2200"
	desc = "Allows for the construction of circuit boards used to build a PanD.E.M.I.C. 2200."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/pandemic

/datum/design/circuit/scan_console
	name = "DNA Modifier Access Console"
	desc = "Allows for the construction of circuit boards used to build a DNA scanning console."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/scan_consolenew

/datum/design/circuit/comconsole
	name = "Communications Console"
	desc = "Allows for the construction of circuit boards used to build a communications console."
	req_tech = list(/decl/tech/magnets = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/communications

/datum/design/circuit/idcardconsole
	name = "ID Computer"
	desc = "Allows for the construction of circuit boards used to build an ID computer."
	build_path = /obj/item/circuitboard/card

/datum/design/circuit/crewconsole
	name = "Crew Monitoring Computer"
	desc = "Allows for the construction of circuit boards used to build a crew monitoring computer."
	req_tech = list(/decl/tech/magnets = 2, /decl/tech/biotech = 2, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/crew

/datum/design/circuit/teleconsole
	name = "Teleporter Control Computer"
	desc = "Allows for the construction of circuit boards used to build a teleporter control computer."
	req_tech = list(/decl/tech/programming = 3, /decl/tech/bluespace = 2)
	build_path = /obj/item/circuitboard/teleporter

/datum/design/circuit/secdata
	name = "Security Records Console"
	desc = "Allows for the construction of circuit boards used to build a security records console."
	build_path = /obj/item/circuitboard/secure_data

/datum/design/circuit/atmosalerts
	name = "Atmospheric Alert Computer"
	desc = "Allows for the construction of circuit boards used to build an atmospheric alert computer."
	build_path = /obj/item/circuitboard/atmos_alert

/datum/design/circuit/air_management
	name = "Atmospheric Monitor Console"
	desc = "Allows for the construction of circuit boards used to build an atmospheric monitor console."
	build_path = /obj/item/circuitboard/air_management

/* Uncomment if someone makes these buildable
/datum/design/circuit/general_alert
	name = "General Alert Console"
	desc = "Allows for the construction of circuit boards used to build a general alert console."
	build_path = /obj/item/circuitboard/general_alert
*/

/datum/design/circuit/robocontrol
	name = "Robotics Control Console"
	desc = "Allows for the construction of circuit boards used to build a robotics control console."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/robotics

/datum/design/circuit/clonecontrol
	name = "Cloning Console"
	desc = "Allows for the construction of circuit boards used to build a cloning console."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/cloning

/datum/design/circuit/clonepod
	name = "Cloning Pod"
	desc = "Allows for the construction of circuit boards used to build a cloning pod."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/clonepod

/datum/design/circuit/clonescanner
	name = "DNA Modifier"
	desc = "Allows for the construction of circuit boards used to build a DNA modifier."
	req_tech = list(/decl/tech/biotech = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/clonescanner

/datum/design/circuit/arcademachine
	name = "Arcade Machine"
	desc = "Allows for the construction of circuit boards used to build an arcade machine."
	req_tech = list(/decl/tech/programming = 1)
	build_path = /obj/item/circuitboard/arcade

/datum/design/circuit/powermonitor
	name = "Power Monitoring Computer"
	desc = "Allows for the construction of circuit boards used to build a power monitoring computer."
	build_path = /obj/item/circuitboard/powermonitor

/datum/design/circuit/solarcontrol
	name = "Solar Panel Control"
	desc = "Allows for the construction of circuit boards used to build a solar panel control console."
	req_tech = list(/decl/tech/power_storage = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/solar_control

/datum/design/circuit/prisonmanage
	name = "Prisoner Management Console"
	desc = "Allows for the construction of circuit boards used to build a prisoner management console."
	build_path = /obj/item/circuitboard/prisoner

/datum/design/circuit/mechacontrol
	name = "Exosuit Control Console"
	desc = "Allows for the construction of circuit boards used to build an exosuit control console."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha_control

/datum/design/circuit/mechapower
	name = "Mech Bay Power Control Console"
	desc = "Allows for the construction of circuit boards used to build a mech bay power control console."
	req_tech = list(/decl/tech/power_storage = 3, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/mech_bay_power_console

/datum/design/circuit/rdconsole
	name = "R&D Console"
	desc = "Allows for the construction of circuit boards used to build core and robotics R&D consoles."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/rdconsole

/datum/design/circuit/ordercomp
	name = "Supply Ordering Console"
	desc = "Allows for the construction of circuit boards used to build a supply ordering console."
	build_path = /obj/item/circuitboard/ordercomp

/datum/design/circuit/supplycomp
	name = "Supply Shuttle Console"
	desc = "Allows for the construction of circuit boards used to build a supply shuttle console."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/supplycomp

/datum/design/circuit/comm_monitor
	name = "Telecommunications Monitor Console"
	desc = "Allows for the construction of circuit boards used to build a telecommunications monitor console."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/comm_monitor

/datum/design/circuit/comm_server
	name = "Telecommunications Server Monitor Console"
	desc = "Allows for the construction of circuit boards used to build a telecommunications server monitor console."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/comm_server

/datum/design/circuit/message_monitor
	name = "Message Monitor Console"
	desc = "Allows for the construction of circuit boards used to build a message monitor console."
	req_tech = list(/decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/message_monitor

/datum/design/circuit/aifixer
	name = "AI System Integrity Restorer"
	desc = "Allows for the construction of circuit boards used to build an AI system integrity restorer."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/aifixer