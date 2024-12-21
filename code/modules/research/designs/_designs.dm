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
	var/list/categories = null // Primarily used for Mech Fabricators, but can be used for anything

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

/////////////////////////////////////////
//////////////////Test///////////////////
/////////////////////////////////////////
	/*	test
			name = "Test Design"
			desc = "A design to test the new protolathe."
			build_type = DESIGN_TYPE_PROTOLATHE
			req_tech = list(/datum/tech/materials = 1)
			materials = list(/decl/material/gold = 3000, "iron" = 15, "copper" = 10, /decl/material/silver = 2500)
			build_path = "/obj/item/banhammer" */