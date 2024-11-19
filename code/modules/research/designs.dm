//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a $ to denote that they aren't reagents.
The currently supporting non-reagent materials:
- $metal (/obj/item/stack/metal).
- $glass (/obj/item/stack/glass).
- $plasma (/obj/item/stack/plasma).
- $silver (/obj/item/stack/silver).
- $gold (/obj/item/stack/gold).
- $uranium (/obj/item/stack/uranium).
- $diamond (/obj/item/stack/diamond).
- $clown (/obj/item/stack/clown). ("Bananium")
- All values are that one sheet = MATERIAL_AMOUNT_PER_SHEET units.
(Insert new ones here)

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- The reliability formula for all R&D built items is reliability_base (a fixed number) + total tech levels required to make it +
reliability_mod (starts at 0, gets improved through experimentation). Example: PACMAN generator. 79 base reliablity + 6 tech
(3 plasmatech, 3 powerstorage) + 0 (since it's completely new) = 85% reliability. Reliability is the chance it works CORRECTLY.
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is MATERIAL_AMOUNT_PER_SHEET units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).
- Add the AUTOLATHE tag to


*/
#define	IMPRINTER	1	//For circuits. Uses glass/chemicals.
#define PROTOLATHE	2	//New stuff. Uses glass/metal/chemicals
#define	AUTOLATHE	4	//Uses glass/metal only.
#define CRAFTLATHE	8	//Uses fuck if I know. For use eventually.
#define MECHFAB		16 //Remember, objects utilising this flag should have construction_time and construction_cost vars.
//Note: More then one of these can be added to a design but imprinter and lathe designs are incompatable.

/datum/design						//Datum for object designs, used in construction
	var/name = "Name"					//Name of the created object.
	var/desc = "Desc"					//Description of the created object.
	var/list/req_tech = list()			//IDs of that techs the object originated from and the minimum level requirements.
	var/reliability_mod = 0				//Reliability modifier of the device at it's starting point.
	var/reliability_base = 100			//Base reliability of a device before modifiers.
	var/reliability = 100				//Reliability of the device.
	var/build_type = null				//Flag as to what kind machine the design is built in. See defines.
	var/list/materials = list()			//List of materials. Format: /decl/material/* = amount.
	var/build_path = null					//The path of the object that gets created
	var/locked = 0						//If true it will spawn inside a lockbox with currently sec access
	var/category = null //Primarily used for Mech Fabricators, but can be used for anything

//A proc to calculate the reliability of a design based on tech levels and innate modifiers.
//Input: A list of /datum/tech; Output: The new reliabilty.
/datum/design/proc/CalcReliability(list/temp_techs)
	var/new_reliability = reliability_mod + reliability_base
	for(var/datum/tech/T in temp_techs)
		if(T.type in req_tech)
			new_reliability += T.level
	new_reliability = clamp(new_reliability, reliability_base, 100)
	reliability = new_reliability
	return

///////////////////Computer Boards///////////////////////////////////
/datum/design/seccamera
	name = "Circuit Design (Security)"
	desc = "Allows for the construction of circuit boards used to build security camera computers."
	req_tech = list(/datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/security

/datum/design/aicore
	name = "Circuit Design (AI Core)"
	desc = "Allows for the construction of circuit boards used to build new AI cores."
	req_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/aicore

/datum/design/aiupload
	name = "Circuit Design (AI Upload)"
	desc = "Allows for the construction of circuit boards used to build an AI Upload Console."
	req_tech = list(/datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/aiupload

/datum/design/borgupload
	name = "Circuit Design (Cyborg Upload)"
	desc = "Allows for the construction of circuit boards used to build a Cyborg Upload Console."
	req_tech = list(/datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/borgupload

/datum/design/med_data
	name = "Circuit Design (Medical Records)"
	desc = "Allows for the construction of circuit boards used to build a medical records console."
	req_tech = list(/datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/med_data

/datum/design/operating
	name = "Circuit Design (Operating Computer)"
	desc = "Allows for the construction of circuit boards used to build an operating computer console."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/operating

/datum/design/pandemic
	name = "Circuit Design (PanD.E.M.I.C. 2200)"
	desc = "Allows for the construction of circuit boards used to build a PanD.E.M.I.C. 2200 console."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pandemic

/datum/design/scan_console
	name = "Circuit Design (DNA Machine)"
	desc = "Allows for the construction of circuit boards used to build a new DNA scanning console."
	req_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/scan_consolenew

/datum/design/comconsole
	name = "Circuit Design (Communications)"
	desc = "Allows for the construction of circuit boards used to build a communications console."
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/communications

/datum/design/idcardconsole
	name = "Circuit Design (ID Computer)"
	desc = "Allows for the construction of circuit boards used to build an ID computer."
	req_tech = list(/datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/card

/datum/design/crewconsole
	name = "Circuit Design (Crew monitoring computer)"
	desc = "Allows for the construction of circuit boards used to build a Crew monitoring computer."
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/biotech = 2, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/crew

/datum/design/teleconsole
	name = "Circuit Design (Teleporter Console)"
	desc = "Allows for the construction of circuit boards used to build a teleporter control console."
	req_tech = list(/datum/tech/programming = 3, /datum/tech/bluespace = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/teleporter

/datum/design/secdata
	name = "Circuit Design (Security Records Console)"
	desc = "Allows for the construction of circuit boards used to build a security records console."
	req_tech = list(/datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/secure_data

/datum/design/atmosalerts
	name = "Circuit Design (Atmosphere Alert)"
	desc = "Allows for the construction of circuit boards used to build an atmosphere alert console.."
	req_tech = list(/datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/atmos_alert

/datum/design/air_management
	name = "Circuit Design (Atmospheric Monitor)"
	desc = "Allows for the construction of circuit boards used to build an Atmospheric Monitor."
	req_tech = list(/datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/air_management

/* Uncomment if someone makes these buildable
/datum/design/general_alert
	name = "Circuit Design (General Alert Console)"
	desc = "Allows for the construction of circuit boards used to build a General Alert console."
	req_tech = list(/datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/general_alert
*/

/datum/design/robocontrol
	name = "Circuit Design (Robotics Control Console)"
	desc = "Allows for the construction of circuit boards used to build a Robotics Control console."
	req_tech = list(/datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/robotics

/datum/design/clonecontrol
	name = "Circuit Design (Cloning Machine Console)"
	desc = "Allows for the construction of circuit boards used to build a new Cloning Machine console."
	req_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/cloning

/datum/design/clonepod
	name = "Circuit Design (Clone Pod)"
	desc = "Allows for the construction of circuit boards used to build a Cloning Pod."
	req_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/clonepod

/datum/design/clonescanner
	name = "Circuit Design (Cloning Scanner)"
	desc = "Allows for the construction of circuit boards used to build a Cloning Scanner."
	req_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/clonescanner

/datum/design/arcademachine
	name = "Circuit Design (Arcade Machine)"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	req_tech = list(/datum/tech/programming = 1)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/arcade

/datum/design/powermonitor
	name = "Circuit Design (Power Monitor)"
	desc = "Allows for the construction of circuit boards used to build a new power monitor"
	req_tech = list(/datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/powermonitor

/datum/design/solarcontrol
	name = "Circuit Design (Solar Control)"
	desc = "Allows for the construction of circuit boards used to build a solar control console"
	req_tech = list(/datum/tech/power_storage = 2, /datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/solar_control

/datum/design/prisonmanage
	name = "Circuit Design (Prisoner Management Console)"
	desc = "Allows for the construction of circuit boards used to build a prisoner management console."
	req_tech = list(/datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/prisoner

/datum/design/mechacontrol
	name = "Circuit Design (Exosuit Control Console)"
	desc = "Allows for the construction of circuit boards used to build an exosuit control console."
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha_control

/datum/design/mechapower
	name = "Circuit Design (Mech Bay Power Control Console)"
	desc = "Allows for the construction of circuit boards used to build a mech bay power control console."
	req_tech = list(/datum/tech/power_storage = 3, /datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mech_bay_power_console

/datum/design/rdconsole
	name = "Circuit Design (R&D Console)"
	desc = "Allows for the construction of circuit boards used to build a new R&D console."
	req_tech = list(/datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rdconsole

/datum/design/ordercomp
	name = "Circuit Design (Supply ordering console)"
	desc = "Allows for the construction of circuit boards used to build a Supply ordering console."
	req_tech = list(/datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/ordercomp

/datum/design/supplycomp
	name = "Circuit Design (Supply shuttle console)"
	desc = "Allows for the construction of circuit boards used to build a Supply shuttle console."
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/supplycomp

/datum/design/comm_monitor
	name = "Circuit Design (Telecommunications Monitoring Console)"
	desc = "Allows for the construction of circuit boards used to build a telecommunications monitor."
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/comm_monitor

/datum/design/comm_server
	name = "Circuit Design (Telecommunications Server Monitoring Console)"
	desc = "Allows for the construction of circuit boards used to build a telecommunication server browser and monitor."
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/comm_server

/datum/design/message_monitor
	name = "Circuit Design (Messaging Monitor Console)"
	desc = "Allows for the construction of circuit boards used to build a messaging monitor console."
	req_tech = list(/datum/tech/programming = 5)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/message_monitor

/datum/design/aifixer
	name = "Circuit Design (AI Integrity Restorer)"
	desc = "Allows for the construction of circuit boards used to build an AI Integrity Restorer."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/aifixer

///////////////////////////////////
//////////AI Module Disks//////////
///////////////////////////////////
/datum/design/safeguard_module
	name = "Module Design (Safeguard)"
	desc = "Allows for the construction of a Safeguard AI Module."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/safeguard

/datum/design/onehuman_module
	name = "Module Design (OneHuman)"
	desc = "Allows for the construction of a OneHuman AI Module."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/oneHuman

/datum/design/protectstation_module
	name = "Module Design (ProtectStation)"
	desc = "Allows for the construction of a ProtectStation AI Module."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/protectStation

/datum/design/notele_module
	name = "Module Design (TeleporterOffline Module)"
	desc = "Allows for the construction of a TeleporterOffline AI Module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/teleporterOffline

/datum/design/quarantine_module
	name = "Module Design (Quarantine)"
	desc = "Allows for the construction of a Quarantine AI Module."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/biotech = 2, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/quarantine

/datum/design/oxygen_module
	name = "Module Design (OxygenIsToxicToHumans)"
	desc = "Allows for the construction of a Safeguard AI Module."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/biotech = 2, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/oxygen

/datum/design/freeform_module
	name = "Module Design (Freeform)"
	desc = "Allows for the construction of a Freeform AI Module."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/freeform

/datum/design/reset_module
	name = "Module Design (Reset)"
	desc = "Allows for the construction of a Reset AI Module."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/reset

/datum/design/purge_module
	name = "Module Design (Purge)"
	desc = "Allows for the construction of a Purge AI Module."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/purge

/datum/design/freeformcore_module
	name = "Core Module Design (Freeform)"
	desc = "Allows for the construction of a Freeform AI Core Module."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/freeformcore

/datum/design/asimov
	name = "Core Module Design (Asimov)"
	desc = "Allows for the construction of a Asimov AI Core Module."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/asimov

/datum/design/paladin_module
	name = "Core Module Design (P.A.L.A.D.I.N.)"
	desc = "Allows for the construction of a P.A.L.A.D.I.N. AI Core Module."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/paladin

/datum/design/tyrant_module
	name = "Core Module Design (T.Y.R.A.N.T.)"
	desc = "Allows for the construction of a T.Y.R.A.N.T. AI Module."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/programming = 4, /datum/tech/syndicate = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/tyrant

///////////////////////////////////
/////Subspace Telecoms////////////
///////////////////////////////////
/datum/design/subspace_receiver
	name = "Circuit Design (Subspace Receiver)"
	desc = "Allows for the construction of Subspace Receiver equipment."
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 4, /datum/tech/bluespace = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/receiver

/datum/design/telecoms_bus
	name = "Circuit Design (Bus Mainframe)"
	desc = "Allows for the construction of Telecommunications Bus Mainframes."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/bus

/datum/design/telecoms_hub
	name = "Circuit Design (Hub Mainframe)"
	desc = "Allows for the construction of Telecommunications Hub Mainframes."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/hub

/datum/design/telecoms_relay
	name = "Circuit Design (Relay Mainframe)"
	desc = "Allows for the construction of Telecommunications Relay Mainframes."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 3, /datum/tech/bluespace = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/relay

/datum/design/telecoms_processor
	name = "Circuit Design (Processor Unit)"
	desc = "Allows for the construction of Telecommunications Processor equipment."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/processor

/datum/design/telecoms_server
	name = "Circuit Design (Server Mainframe)"
	desc = "Allows for the construction of Telecommunications Servers."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/server

/datum/design/subspace_broadcaster
	name = "Circuit Design (Subspace Broadcaster)"
	desc = "Allows for the construction of Subspace Broadcasting equipment."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/programming = 4, /datum/tech/bluespace = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/telecoms/broadcaster

///////////////////////////////////
/////Non-Board Computer Stuff//////
///////////////////////////////////
/datum/design/intellicard
	name = "Intellicard AI Transportation System"
	desc = "Allows for the construction of an intellicard."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/programming = 4)
	build_type = PROTOLATHE
	materials = list(/decl/material/glass = 1000, /decl/material/gold = 200)
	build_path = /obj/item/aicard

/datum/design/paicard
	name = "Personal Artificial Intelligence Card"
	desc = "Allows for the construction of a pAI Card"
	req_tech = list(/datum/tech/programming = 2)
	build_type = PROTOLATHE
	materials = list(/decl/material/glass = 500, MATERIAL_METAL = 500)
	build_path = /obj/item/paicard

/datum/design/posibrain
	name = "Positronic Brain"
	desc = "Allows for the construction of a positronic brain"
	req_tech = list(/datum/tech/materials = 6, /datum/tech/engineering = 4, /datum/tech/programming = 4, /datum/tech/bluespace = 2)

	build_type = PROTOLATHE
	materials = list(
		MATERIAL_METAL = 2000, /decl/material/glass = 1000, /decl/material/silver = 1000,
		/decl/material/gold = 500, /decl/material/diamond = 100, /decl/material/plasma = 500
	)
	build_path = /obj/item/mmi/posibrain

///////////////////////////////////
//////////Mecha Module Disks///////
///////////////////////////////////
/datum/design/ripley_main
	name = "Circuit Design (APLU \"Ripley\" Central Control module)"
	desc = "Allows for the construction of a \"Ripley\" Central Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/ripley/main

/datum/design/ripley_peri
	name = "Circuit Design (APLU \"Ripley\" Peripherals Control module)"
	desc = "Allows for the construction of a  \"Ripley\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals

/datum/design/odysseus_main
	name = "Circuit Design (\"Odysseus\" Central Control module)"
	desc = "Allows for the construction of a \"Odysseus\" Central Control module."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/odysseus/main

/datum/design/odysseus_peri
	name = "Circuit Design (\"Odysseus\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Odysseus\" Peripheral Control module."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals

/datum/design/gygax_main
	name = "Circuit Design (\"Gygax\" Central Control module)"
	desc = "Allows for the construction of a \"Gygax\" Central Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/gygax/main

/datum/design/gygax_peri
	name = "Circuit Design (\"Gygax\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Gygax\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/design/gygax_targ
	name = "Circuit Design (\"Gygax\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Gygax\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/combat = 2, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting

/datum/design/durand_main
	name = "Circuit Design (\"Durand\" Central Control module)"
	desc = "Allows for the construction of a \"Durand\" Central Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/durand/main

/datum/design/durand_peri
	name = "Circuit Design (\"Durand\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Durand\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals

/datum/design/durand_targ
	name = "Circuit Design (\"Durand\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Durand\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/combat = 2, /datum/tech/programming = 4)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/durand/targeting

/datum/design/honker_main
	name = "Circuit Design (\"H.O.N.K\" Central Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Central Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/honker/main

/datum/design/honker_peri
	name = "Circuit Design (\"H.O.N.K\" Peripherals Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/honker/peripherals

/datum/design/honker_targ
	name = "Circuit Design (\"H.O.N.K\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/honker/targeting

////////////////////////////////////////
/////////// Mecha Equpment /////////////
////////////////////////////////////////
/datum/design/mech_scattershot
	name = "Exosuit Weapon Design (LBX AC 10 \"Scattershot\")"
	desc = "Allows for the construction of LBX AC 10."
	build_type = MECHFAB
	req_tech = list(/datum/tech/combat = 4)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/scattershot
	category = "Exosuit Equipment"

/datum/design/mech_laser
	name = "Exosuit Weapon Design (CH-PS \"Immolator\" Laser)"
	desc = "Allows for the construction of CH-PS Laser."
	build_type = MECHFAB
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/combat = 3)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/laser
	category = "Exosuit Equipment"

/datum/design/mech_laser_heavy
	name = "Exosuit Weapon Design (CH-LC \"Solaris\" Laser Cannon)"
	desc = "Allows for the construction of CH-LC Laser Cannon."
	build_type = MECHFAB
	req_tech = list(/datum/tech/magnets = 4, /datum/tech/combat = 4)
	build_path = /obj/item/mecha_part/equipment/weapon/energy/laser/heavy
	category = "Exosuit Equipment"

/datum/design/mech_grenade_launcher
	name = "Exosuit Weapon Design (SGL-6 Grenade Launcher)"
	desc = "Allows for the construction of SGL-6 Grenade Launcher."
	build_type = MECHFAB
	req_tech = list(/datum/tech/combat = 3)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/flashbang
	category = "Exosuit Equipment"

/datum/design/clusterbang_launcher
	name = "Exosuit Module Design (SOP-6 Clusterbang Launcher)"
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute"
	build_type = MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 5, /datum/tech/syndicate = 3)
	build_path = /obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited
	category = "Exosuit Equipment"

/datum/design/mech_wormhole_gen
	name = "Exosuit Module Design (Localized Wormhole Generator)"
	desc = "An exosuit module that allows generating of small quasi-stable wormholes."
	build_type = MECHFAB
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/bluespace = 3)
	build_path = /obj/item/mecha_part/equipment/wormhole_generator
	category = "Exosuit Equipment"

/datum/design/mech_teleporter
	name = "Exosuit Module Design (Teleporter Module)"
	desc = "An exosuit module that allows exosuits to teleport to any position in view."
	build_type = MECHFAB
	req_tech = list(/datum/tech/magnets = 5, /datum/tech/bluespace = 10)
	build_path = /obj/item/mecha_part/equipment/teleporter
	category = "Exosuit Equipment"

/datum/design/mech_rcd
	name = "Exosuit Module Design (RCD Module)"
	desc = "An exosuit-mounted Rapid Construction Device."
	build_type = MECHFAB
	req_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/engineering = 4,
		/datum/tech/power_storage = 4, /datum/tech/bluespace = 3
	)
	build_path = /obj/item/mecha_part/equipment/tool/rcd
	category = "Exosuit Equipment"

/datum/design/mech_gravcatapult
	name = "Exosuit Module Design (Gravitational Catapult Module)"
	desc = "An exosuit mounted Gravitational Catapult."
	build_type = MECHFAB
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/engineering = 3, /datum/tech/bluespace = 2)
	build_path = /obj/item/mecha_part/equipment/gravcatapult
	category = "Exosuit Equipment"

/datum/design/mech_repair_droid
	name = "Exosuit Module Design (Repair Droid Module)"
	desc = "Automated Repair Droid. BEEP BOOP"
	build_type = MECHFAB
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_path = /obj/item/mecha_part/equipment/repair_droid
	category = "Exosuit Equipment"

/datum/design/mech_plasma_generator
	name = "Exosuit Module Design (Plasma Converter Module)"
	desc = "Exosuit-mounted plasma converter."
	build_type = MECHFAB
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 2, /datum/tech/plasma = 2)
	build_path = /obj/item/mecha_part/equipment/generator
	category = "Exosuit Equipment"

/datum/design/mech_energy_relay
	name = "Exosuit Module Design (Tesla Energy Relay)"
	desc = "Tesla Energy Relay"
	build_type = MECHFAB
	req_tech = list(/datum/tech/magnets = 4, /datum/tech/power_storage = 3)
	build_path = /obj/item/mecha_part/equipment/tesla_energy_relay
	category = "Exosuit Equipment"

/datum/design/mech_ccw_armor
	name = "Exosuit Module Design(Reactive Armor Booster Module)"
	desc = "Exosuit-mounted armor booster."
	build_type = MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 4)
	build_path = /obj/item/mecha_part/equipment/anticcw_armor_booster
	category = "Exosuit Equipment"

/datum/design/mech_proj_armor
	name = "Exosuit Module Design(Reflective Armor Booster Module)"
	desc = "Exosuit-mounted armor booster."
	build_type = MECHFAB
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 5, /datum/tech/engineering = 3)
	build_path = /obj/item/mecha_part/equipment/antiproj_armor_booster
	category = "Exosuit Equipment"

/datum/design/mech_syringe_gun
	name = "Exosuit Module Design(Syringe Gun)"
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	build_type = MECHFAB
	req_tech = list(
		/datum/tech/materials = 3, /datum/tech/magnets = 4, /datum/tech/biotech = 4,
		/datum/tech/programming = 3
	)
	build_path = /obj/item/mecha_part/equipment/tool/syringe_gun
	category = "Exosuit Equipment"

/datum/design/mech_diamond_drill
	name = "Exosuit Module Design (Diamond Mining Drill)"
	desc = "An upgraded version of the standard drill"
	build_type = MECHFAB
	req_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 3)
	build_path = /obj/item/mecha_part/equipment/tool/drill/diamond
	category = "Exosuit Equipment"

/datum/design/mech_generator_nuclear
	name = "Exosuit Module Design (ExoNuclear Reactor)"
	desc = "Compact nuclear reactor module"
	build_type = MECHFAB
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/power_storage = 3)
	build_path = /obj/item/mecha_part/equipment/generator/nuclear
	category = "Exosuit Equipment"

////////////////////////////////////////
//////////Disk Construction Disks///////
////////////////////////////////////////
/datum/design/design_disk
	name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	req_tech = list(/datum/tech/programming = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 10)
	build_path = /obj/item/disk/design

/datum/design/tech_disk
	name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	req_tech = list(/datum/tech/programming = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 10)
	build_path = /obj/item/disk/tech

////////////////////////////////////////
/////////////Stock Parts////////////////
////////////////////////////////////////
/datum/design/basic_capacitor
	name = "Basic Capacitor"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/power_storage = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/stock_part/capacitor

/datum/design/basic_sensor
	name = "Basic Sensor Module"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/magnets = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/scanning_module

/datum/design/micro_mani
	name = "Micro Manipulator"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 1, /datum/tech/programming = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 30)
	build_path = /obj/item/stock_part/manipulator

/datum/design/basic_micro_laser
	name = "Basic Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/magnets = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/micro_laser

/datum/design/basic_matter_bin
	name = "Basic Matter Bin"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 1)
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(MATERIAL_METAL = 80)
	build_path = /obj/item/stock_part/matter_bin

/datum/design/adv_capacitor
	name = "Advanced Capacitor"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/stock_part/capacitor/adv

/datum/design/adv_sensor
	name = "Advanced Sensor Module"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/magnets = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/scanning_module/adv

/datum/design/nano_mani
	name = "Nano Manipulator"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/programming = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30)
	build_path = /obj/item/stock_part/manipulator/nano

/datum/design/high_micro_laser
	name = "High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/magnets = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20)
	build_path = /obj/item/stock_part/micro_laser/high

/datum/design/adv_matter_bin
	name = "Advanced Matter Bin"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 80)
	build_path = /obj/item/stock_part/matter_bin/adv

/datum/design/super_capacitor
	name = "Super Capacitor"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/power_storage = 5)
	build_type = PROTOLATHE
	reliability_base = 71
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50, /decl/material/gold = 20)
	build_path = /obj/item/stock_part/capacitor/super

/datum/design/phasic_sensor
	name = "Phasic Sensor Module"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/magnets = 5)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20, /decl/material/silver = 10)
	reliability_base = 72
	build_path = /obj/item/stock_part/scanning_module/phasic

/datum/design/pico_mani
	name = "Pico Manipulator"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/programming = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30)
	reliability_base = 73
	build_path = /obj/item/stock_part/manipulator/pico

/datum/design/ultra_micro_laser
	name = "Ultra-High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 5)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20, /decl/material/uranium = 10)
	reliability_base = 70
	build_path = /obj/item/stock_part/micro_laser/ultra

/datum/design/super_matter_bin
	name = "Super Matter Bin"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 5)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 80)
	reliability_base = 75
	build_path = /obj/item/stock_part/matter_bin/super

// Rating 4 -Frenjo.
/datum/design/hyper_capacitor
	name = "Hyper Capacitor"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/power_storage = 7)
	build_type = PROTOLATHE
	reliability_base = 71
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50, /decl/material/silver = 20, /decl/material/gold = 20)
	build_path = /obj/item/stock_part/capacitor/hyper

/datum/design/hyperphasic_sensor
	name = "Hyper-Phasic Sensor Module"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/magnets = 7)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20, /decl/material/silver = 10, /decl/material/gold = 10)
	reliability_base = 72
	build_path = /obj/item/stock_part/scanning_module/hyperphasic

/datum/design/femto_mani
	name = "Femto Manipulator"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 7, /datum/tech/programming = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30)
	reliability_base = 73
	build_path = /obj/item/stock_part/manipulator/femto

/datum/design/hyper_ultra_micro_laser
	name = "Hyper-Ultra-High-Power Micro-Laser"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 7)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/glass = 20, /decl/material/uranium = 10, /decl/material/plasma = 10)
	reliability_base = 70
	build_path = /obj/item/stock_part/micro_laser/hyperultra

/datum/design/hyper_matter_bin
	name = "Hyper Matter Bin"
	desc = "A stock part used in the construction of various devices."
	req_tech = list(/datum/tech/materials = 7)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 80)
	reliability_base = 75
	build_path = /obj/item/stock_part/matter_bin/hyper

////////////////////////////////////////
///////////////Subspace/////////////////
////////////////////////////////////////
/datum/design/subspace_ansible
	name = "Subspace Ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/programming = 3, /datum/tech/bluespace = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 80, /decl/material/silver = 20)
	build_path = /obj/item/stock_part/subspace/ansible

/datum/design/hyperwave_filter
	name = "Hyperwave Filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/programming = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 40, /decl/material/silver = 10)
	build_path = /obj/item/stock_part/subspace/filter

/datum/design/subspace_amplifier
	name = "Subspace Amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/programming = 3, /datum/tech/bluespace = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/gold = 30, /decl/material/uranium = 15)
	build_path = /obj/item/stock_part/subspace/amplifier

/datum/design/subspace_treatment
	name = "Subspace Treatment Disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 2, /datum/tech/programming = 3, /datum/tech/bluespace = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/silver = 20)
	build_path = /obj/item/stock_part/subspace/treatment

/datum/design/subspace_analyser
	name = "Subspace Analyser"
	desc = "A sophisticated analyser capable of analyzing cryptic subspace wavelengths."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/programming = 3, /datum/tech/bluespace = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10, /decl/material/gold = 15)
	build_path = /obj/item/stock_part/subspace/analyser

/datum/design/subspace_crystal
	name = "Ansible Crystal"
	desc = "A sophisticated analyser capable of analyzing cryptic subspace wavelengths."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/bluespace = 2)
	build_type = PROTOLATHE
	materials = list(/decl/material/glass = 1000, /decl/material/silver = 20, /decl/material/gold = 20)
	build_path = /obj/item/stock_part/subspace/crystal

/datum/design/subspace_transmitter
	name = "Subspace Transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 5, /datum/tech/bluespace = 3)
	build_type = PROTOLATHE
	materials = list(/decl/material/glass = 100, /decl/material/silver = 10, /decl/material/uranium = 15)
	build_path = /obj/item/stock_part/subspace/transmitter

////////////////////////////////////////
//////////////////Power/////////////////
////////////////////////////////////////
/datum/design/basic_cell
	name = "Basic Power Cell"
	desc = "A basic power cell that holds 1000 units of energy"
	req_tech = list(/datum/tech/power_storage = 1)
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 700, /decl/material/glass = 50)
	build_path = /obj/item/cell
	category = "Misc"

/datum/design/high_cell
	name = "High-Capacity Power Cell"
	desc = "A power cell that holds 10000 units of energy"
	req_tech = list(/datum/tech/power_storage = 2)
	build_type = PROTOLATHE | AUTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 700, /decl/material/glass = 60)
	build_path = /obj/item/cell/high
	category = "Misc"

/datum/design/super_cell
	name = "Super-Capacity Power Cell"
	desc = "A power cell that holds 20000 units of energy"
	req_tech = list(/datum/tech/materials = 2, /datum/tech/power_storage = 3)
	reliability_base = 75
	build_type = PROTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 700, /decl/material/glass = 70)
	build_path = /obj/item/cell/super
	category = "Misc"

/datum/design/hyper_cell
	name = "Hyper-Capacity Power Cell"
	desc = "A power cell that holds 30000 units of energy"
	req_tech = list(/datum/tech/materials = 4, /datum/tech/power_storage = 5)
	reliability_base = 70
	build_type = PROTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 400, /decl/material/glass = 70, /decl/material/silver = 150, /decl/material/gold = 150)
	build_path = /obj/item/cell/hyper
	category = "Misc"

/datum/design/light_replacer
	name = "Light Replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 1500, /decl/material/glass = 3000, /decl/material/silver = 150)
	build_path = /obj/item/lightreplacer

////////////////////////////////////////
//////////////MISC Boards///////////////
////////////////////////////////////////
/datum/design/destructive_analyser
	name = "Destructive Analyser Board"
	desc = "The circuit board for a destructive analyser."
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/destructive_analyser

/datum/design/protolathe
	name = "Protolathe Board"
	desc = "The circuit board for a protolathe."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/protolathe

/datum/design/circuit_imprinter
	name = "Circuit Imprinter Board"
	desc = "The circuit board for a circuit imprinter."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/circuit_imprinter

/datum/design/autolathe
	name = "Autolathe Board"
	desc = "The circuit board for a autolathe."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/autolathe

/datum/design/rdservercontrol
	name = "R&D Server Control Console Board"
	desc = "The circuit board for a R&D Server Control Console"
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rdservercontrol

/datum/design/rdserver
	name = "R&D Server Board"
	desc = "The circuit board for an R&D Server"
	req_tech = list(/datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rdserver

/datum/design/mechfab
	name = "Exosuit Fabricator Board"
	desc = "The circuit board for an Exosuit Fabricator"
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_type = IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mechfab

/////////////////////////////////////////
////////////Power Stuff//////////////////
/////////////////////////////////////////
/datum/design/pacman
	name = "PACMAN-type Generator Board"
	desc = "The circuit board that for a PACMAN-type portable generator."
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/power_storage = 3, /datum/tech/programming = 3, /datum/tech/plasma = 3)
	build_type = IMPRINTER
	reliability_base = 79
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pacman

/datum/design/superpacman
	name = "SUPERPACMAN-type Generator Board"
	desc = "The circuit board that for a SUPERPACMAN-type portable generator."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/power_storage = 4, /datum/tech/programming = 3)
	build_type = IMPRINTER
	reliability_base = 76
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pacman/super

/datum/design/mrspacman
	name = "MRSPACMAN-type Generator Board"
	desc = "The circuit board that for a MRSPACMAN-type portable generator."
	req_tech = list(/datum/tech/engineering = 5, /datum/tech/power_storage = 5, /datum/tech/programming = 3)
	build_type = IMPRINTER
	reliability_base = 74
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pacman/mrs

/////////////////////////////////////////
////////////Medical Tools////////////////
/////////////////////////////////////////
/datum/design/mass_spectrometer
	name = "Mass-Spectrometer"
	desc = "A device for analyzing chemicals in the blood."
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/biotech = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 20)
	reliability_base = 76
	build_path = /obj/item/mass_spectrometer

/datum/design/adv_mass_spectrometer
	name = "Advanced Mass-Spectrometer"
	desc = "A device for analyzing chemicals in the blood and their quantities."
	req_tech = list(/datum/tech/magnets = 4, /datum/tech/biotech = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 20)
	reliability_base = 74
	build_path = /obj/item/mass_spectrometer/adv

/datum/design/reagent_scanner
	name = "Reagent Scanner"
	desc = "A device for identifying chemicals."
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/biotech = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 20)
	reliability_base = 76
	build_path = /obj/item/reagent_scanner

/datum/design/adv_reagent_scanner
	name = "Advanced Reagent Scanner"
	desc = "A device for identifying chemicals and their proportions."
	req_tech = list(/datum/tech/magnets = 4, /datum/tech/biotech = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 20)
	reliability_base = 74
	build_path = /obj/item/reagent_scanner/adv

/datum/design/mmi
	name = "Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
	req_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 2)
	build_type = PROTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 1000, /decl/material/glass = 500)
	reliability_base = 76
	build_path = /obj/item/mmi
	category = "Misc"

/datum/design/mmi_radio
	name = "Radio-enabled Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
	req_tech = list(/datum/tech/biotech = 4, /datum/tech/programming = 2)
	build_type = PROTOLATHE | MECHFAB
	materials = list(MATERIAL_METAL = 1200, /decl/material/glass = 500)
	reliability_base = 74
	build_path = /obj/item/mmi/radio_enabled
	category = "Misc"

/datum/design/synthetic_flash
	name = "Synthetic Flash"
	desc = "When a problem arises, SCIENCE is the solution."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/combat = 2)
	build_type = MECHFAB
	materials = list(MATERIAL_METAL = 750, /decl/material/glass = 750)
	reliability_base = 76
	build_path = /obj/item/flash/synthetic
	category = "Misc"

/datum/design/nanopaste
	name = "nanopaste"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 7000, /decl/material/glass = 7000)
	build_path = /obj/item/stack/nanopaste

/datum/design/implant_loyal
	name = "loyalty implant"
	desc = "Makes you loyal or such."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/biotech = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 7000, /decl/material/glass = 7000)
	build_path = /obj/item/implant/loyalty

/datum/design/implant_chem
	name = "chemical implant"
	desc = "Injects things."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/biotech = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/implant/chem

/datum/design/implant_free
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	req_tech = list(/datum/tech/biotech = 3, /datum/tech/syndicate = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/implant/freedom

/datum/design/chameleon
	name = "Chameleon Jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	req_tech = list(/datum/tech/syndicate = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 500)
	build_path = /obj/item/clothing/under/chameleon

/datum/design/bluespacebeaker
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/bluespace = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 3000, /decl/material/diamond = 500, /decl/material/plasma = 3000)
	reliability_base = 76
	build_path = /obj/item/reagent_holder/glass/beaker/bluespace

/datum/design/noreactbeaker
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	req_tech = list(/datum/tech/materials = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 3000)
	reliability_base = 76
	build_path = /obj/item/reagent_holder/glass/beaker/noreact
	category = "Misc"

/datum/design/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/magnets = 2, /datum/tech/biotech = 2)
	build_type = PROTOLATHE
	materials = list(/decl/material/steel = 12500, /decl/material/glass = 7500)
	build_path = /obj/item/scalpel/laser1

/datum/design/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/biotech = 3)
	build_type = PROTOLATHE
	materials = list(/decl/material/steel = 12500, /decl/material/glass = 7500, /decl/material/silver = 2500)
	build_path = /obj/item/scalpel/laser2

/datum/design/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	req_tech = list(/datum/tech/materials = 6, /datum/tech/magnets = 5, /datum/tech/biotech = 4)
	build_type = PROTOLATHE
	materials = list(/decl/material/steel = 12500, /decl/material/glass = 7500, /decl/material/silver = 2000, /decl/material/gold = 1500)
	build_path = /obj/item/scalpel/laser3

/datum/design/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	req_tech = list(/datum/tech/materials = 7, /datum/tech/magnets = 5, /datum/tech/biotech = 4, /datum/tech/programming = 4)
	build_type = PROTOLATHE
	materials = list (/decl/material/steel = 12500, /decl/material/glass = 7500, /decl/material/silver = 1500, /decl/material/gold = 1500, /decl/material/diamond = 750)
	build_path = /obj/item/scalpel/manager

// Added hypospray to protolathe with some sensible-looking variables. -Frenjo
/datum/design/hypospray
	name = "Hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/biotech = 4, /datum/tech/engineering = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 7500, /decl/material/glass = 4500, /decl/material/silver = 1500, /decl/material/gold = 1500)
	build_path = /obj/item/reagent_holder/hypospray

/////////////////////////////////////////
/////////////////Weapons/////////////////
/////////////////////////////////////////
/datum/design/nuclear_gun
	name = "Advanced Energy Gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 3, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000, /decl/material/uranium = 500)
	reliability_base = 76
	build_path = /obj/item/gun/energy/gun/nuclear
	locked = 1

/datum/design/stunrevolver
	name = "Stun Revolver"
	desc = "The prize of the Head of Security."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 3, /datum/tech/power_storage = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver
	locked = 1

/datum/design/lasercannon
	name = "Laser Cannon"
	desc = "A heavy duty laser cannon."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 4, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 10000, /decl/material/glass = 1000, /decl/material/diamond = 2000)
	build_path = /obj/item/gun/energy/lasercannon
	locked = 1

/datum/design/decloner
	name = "Decloner"
	desc = "Your opponent will bubble into a messy pile of goop."
	req_tech = list(/datum/tech/materials = 7, /datum/tech/biotech = 5, /datum/tech/combat = 8, /datum/tech/power_storage = 6)
	build_type = PROTOLATHE
	materials = list(/decl/material/gold = 5000, /decl/material/uranium = 10000, "mutagen" = 40)
	build_path = /obj/item/gun/energy/decloner
	locked = 1

/datum/design/chemsprayer
	name = "Chem Sprayer"
	desc = "An advanced chem spraying device."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/biotech = 2, /datum/tech/engineering = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000)
	reliability_base = 100
	build_path = /obj/item/reagent_holder/spray/chemsprayer

/datum/design/rapidsyringe
	name = "Rapid Syringe Gun"
	desc = "A gun that fires many syringes."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/biotech = 2, /datum/tech/combat = 3, /datum/tech/engineering = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000)
	build_path = /obj/item/gun/syringe/rapidsyringe

/*
/datum/design/largecrossbow
	name = "Energy Crossbow"
	desc = "A weapon favoured by syndicate infiltration teams."
	req_tech = list(/datum/tech/materials = 5, /datum/tech/biotech = 4, /datum/tech/combat = 4, /datum/tech/engineering = 3, /datum/tech/syndicate = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000, /decl/material/silver = 1000, /decl/material/uranium = 1000)
	build_path = /obj/item/gun/energy/crossbow/largecrossbow
*/

/datum/design/temp_gun
	name = "Temperature Gun"
	desc = "A gun that shoots temperature bullet energythings to change temperature."//Change it if you want
	req_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 2, /datum/tech/combat = 3, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 500, /decl/material/silver = 3000)
	build_path = /obj/item/gun/energy/temperature
	locked = 1

/datum/design/flora_gun
	name = "Floral Somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells. Harmless to other organic life."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/biotech = 3, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 2000, /decl/material/glass = 500, /decl/material/uranium = 500)
	build_path = /obj/item/gun/energy/floragun

/datum/design/large_grenade
	name = "Large Grenade"
	desc = "A grenade that affects a larger area and use larger containers."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/combat = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 3000)
	reliability_base = 79
	build_path = /obj/item/grenade/chemical/large

/datum/design/smg
	name = "Submachine Gun"
	desc = "A lightweight, fast firing gun."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 8000, /decl/material/silver = 2000, /decl/material/diamond = 1000)
	build_path = /obj/item/gun/projectile/automatic
	locked = 1

/datum/design/ammo_9mm
	name = "Ammunition Box (9mm)"
	desc = "A box of prototype 9mm ammunition."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET, /decl/material/silver = 100)
	build_path = /obj/item/ammo_magazine/c9mm

/datum/design/stunshell
	name = "Stun Shell"
	desc = "A stunning shell for a shotgun."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell

/datum/design/plasmapistol
	name = "plasma pistol"
	desc = "A specialized firearm designed to fire lethal bolts of toxins."
	req_tech = list(/datum/tech/combat = 5, /datum/tech/plasma = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 5000, /decl/material/glass = 1000, /decl/material/plasma = 3000)
	build_path = /obj/item/gun/energy/toxgun

/////////////////////////////////////////
/////////////////Mining//////////////////
/////////////////////////////////////////
/datum/design/jackhammer
	name = "Sonic Jackhammer"
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	req_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 2, /datum/tech/power_storage = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 2000, /decl/material/glass = 500, /decl/material/silver = 500)
	build_path = /obj/item/pickaxe/jackhammer

/datum/design/drill
	name = "Mining Drill"
	desc = "Yours is the drill that will pierce through the rock walls."
	req_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 6000, /decl/material/glass = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill

/datum/design/plasmacutter
	name = "Plasma Cutter"
	desc = "You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 3, /datum/tech/plasma = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 1500, /decl/material/glass = 500, /decl/material/gold = 500, /decl/material/plasma = 500)
	reliability_base = 79
	build_path = /obj/item/pickaxe/plasmacutter

/datum/design/pick_diamond
	name = "Diamond Pickaxe"
	desc = "A pickaxe with a diamond pick head, this is just like minecraft."
	req_tech = list(/datum/tech/materials = 6)
	build_type = PROTOLATHE
	materials = list(/decl/material/diamond = 3000)
	build_path = /obj/item/pickaxe/diamond

/datum/design/drill_diamond
	name = "Diamond Mining Drill"
	desc = "Yours is the drill that will pierce the heavens!"
	req_tech = list(/datum/tech/materials = 6, /datum/tech/engineering = 4, /datum/tech/power_storage = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 3000, /decl/material/glass = 1000, /decl/material/diamond = MATERIAL_AMOUNT_PER_SHEET) //Yes, a whole diamond is needed.
	reliability_base = 79
	build_path = /obj/item/pickaxe/diamonddrill

/datum/design/mesons
	name = "Optical Meson Scanners"
	desc = "Used for seeing walls, floors, and stuff through anything."
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/engineering = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/clothing/glasses/meson

/////////////////////////////////////////
//////////////Blue Space/////////////////
/////////////////////////////////////////
/datum/design/beacon
	name = "Tracking Beacon"
	desc = "A blue space tracking beacon."
	req_tech = list(/datum/tech/bluespace = 1)
	build_type = PROTOLATHE
	materials = list (MATERIAL_METAL = 20, /decl/material/glass = 10)
	build_path = /obj/item/radio/beacon

/datum/design/bag_holding
	name = "Bag of Holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	req_tech = list(/datum/tech/materials = 6, /datum/tech/bluespace = 4)
	build_type = PROTOLATHE
	materials = list(/decl/material/gold = 3000, /decl/material/diamond = 1500, /decl/material/uranium = 250)
	reliability_base = 80
	build_path = /obj/item/storage/backpack/holding

/datum/design/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	desc = "A small blue crystal with mystical properties."
	req_tech = list(/datum/tech/materials = 7, /datum/tech/bluespace = 5)
	build_type = PROTOLATHE
	materials = list(/decl/material/gold = 1500, /decl/material/diamond = 3000, /decl/material/plasma = 1500)
	reliability_base = 100
	build_path = /obj/item/bluespace_crystal/artificial

/datum/design/miningsatchel_holding
	name = "Mining Satchel of Holding"
	desc = "A mining satchel that can hold an infinite amount of ores."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/bluespace = 3)
	build_type = PROTOLATHE
	materials = list(/decl/material/gold = 500, /decl/material/diamond = 500, /decl/material/uranium = 500) //quite cheap, for more convenience
	reliability_base = 100
	build_path = /obj/item/storage/bag/ore/holding

/////////////////////////////////////////
/////////////////HUDs////////////////////
/////////////////////////////////////////
/datum/design/health_hud
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/biotech = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/clothing/glasses/hud/health

/datum/design/security_hud
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/combat = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/clothing/glasses/hud/security
	locked = 1

/////////////////////////////////////////
//////////////////Test///////////////////
/////////////////////////////////////////
	/*	test
			name = "Test Design"
			desc = "A design to test the new protolathe."
			build_type = PROTOLATHE
			req_tech = list(/datum/tech/materials = 1)
			materials = list(/decl/material/gold = 3000, "iron" = 15, "copper" = 10, /decl/material/silver = 2500)
			build_path = "/obj/item/banhammer" */

/////////////////////////////////////////
//////////////Borg Upgrades//////////////
/////////////////////////////////////////
/datum/design/borg_syndicate_module
	name = "Borg Illegal Weapons Upgrade"
	desc = "Allows for the construction of illegal upgrades for cyborgs"
	build_type = MECHFAB
	req_tech = list(/datum/tech/combat = 4, /datum/tech/syndicate = 3)
	build_path = /obj/item/borg/upgrade/syndicate
	category = "Robotic Upgrade Modules"

/////////////////////////////////////////
/////////////PDA and Radio stuff/////////
/////////////////////////////////////////
/datum/design/binaryencrypt
	name = "Binary Encrpytion Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	req_tech = list(/datum/tech/syndicate = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 300, /decl/material/glass = 300)
	build_path = /obj/item/encryptionkey/binary

/datum/design/pda
	name = "PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/pda

/datum/design/cart_basic
	name = "Generic Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge

/datum/design/cart_engineering
	name = "Power-ON Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/engineering

/datum/design/cart_atmos
	name = "BreatheDeep Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/atmos

/datum/design/cart_medical
	name = "Med-U Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/medical

/datum/design/cart_chemistry
	name = "ChemWhiz Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/chemistry

/datum/design/cart_security
	name = "R.O.B.U.S.T. Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/security
	locked = 1

/datum/design/cart_janitor
	name = "CustodiPRO Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/janitor

/datum/design/cart_clown
	name = "Honkworks 5.0 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/clown

/datum/design/cart_mime
	name = "Gestur-O 1000 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/mime

/datum/design/cart_toxins
	name = "Signal Ace 2 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/signal/toxins

/datum/design/cart_quartermaster
	name = "Space Parts & Space Vendors Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/quartermaster
	locked = 1

/datum/design/cart_hop
	name = "Human Resources 9001 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/hop
	locked = 1

/datum/design/cart_hos
	name = "R.O.B.U.S.T. DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/hos
	locked = 1

/datum/design/cart_ce
	name = "Power-On DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/ce
	locked = 1

/datum/design/cart_cmo
	name = "Med-U DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/cmo
	locked = 1

/datum/design/cart_rd
	name = "Signal Ace DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/rd
	locked = 1

/datum/design/cart_captain
	name = "Value-PAK Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/captain
	locked = 1