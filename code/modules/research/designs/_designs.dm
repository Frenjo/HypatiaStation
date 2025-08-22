//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc.
The currently supported non-reagent materials are:
- /decl/material/iron
- /decl/material/steel
- /decl/material/plastic
- /decl/material/glass
- /decl/material/silver
- /decl/material/gold
- /decl/material/diamond
- /decl/material/uranium
- /decl/material/plasma
- /decl/material/bananium
- /decl/material/tranquilite
- All values are that one sheet = 1 MATERIAL_SHEET units.
(Insert new ones here)

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- The reliability formula for all R&D built items is reliability_base (a fixed number) + total tech levels required to make it +
reliability_mod (starts at 0, gets improved through experimentation). Example: PACMAN generator. 79 base reliablity + 6 tech
(3 plasmatech, 3 powerstorage) + 0 (since it's completely new) = 85% reliability. Reliability is the chance it works CORRECTLY.
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 1 MATERIAL_SHEET units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).
- Add the AUTOLATHE tag to


*/

/datum/design						//Datum for object designs, used in construction
	var/name = "Name"					//Name of the created object.
	var/desc = "Desc"					//Description of the created object.
	var/alist/req_tech = alist()		// Associative list of tech typepaths the object originated from and their minimum level requirements.
	var/reliability_mod = 0				//Reliability modifier of the device at it's starting point.
	var/reliability_base = 100			//Base reliability of a device before modifiers.
	var/reliability = 100				//Reliability of the device.
	var/build_type = null				//Flag as to what kind machine the design is built in. See defines.
	var/alist/materials = alist()		// Associative list of materials. Format: /decl/material/* = amount.
	var/build_time = 3.2 SECONDS		// The time it takes to build this design.
	var/build_path = null				//The path of the object that gets created
	var/locked = 0						//If true it will spawn inside a lockbox with currently sec access
	var/list/categories = null // Primarily used for Mech Fabricators, but can be used for anything

	var/name_prefix = null

	var/hidden = FALSE // If true, this design is only visible when the machine is hacked or emagged.

/datum/design/New()
	. = ..()
	if(isnotnull(name_prefix))
		name = "[name_prefix] ([name])"

//A proc to calculate the reliability of a design based on tech levels and innate modifiers.
//Input: A list of /decl/tech; Output: The new reliabilty.
/datum/design/proc/CalcReliability(list/temp_techs)
	var/new_reliability = reliability_mod + reliability_base
	for(var/decl/tech/T in temp_techs)
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
			req_tech = alist(/decl/tech/materials = 1)
			materials = alist(/decl/material/gold = 3000, "iron" = 15, "copper" = 10, /decl/material/silver = 2500)
			build_path = "/obj/item/banhammer" */