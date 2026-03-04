//////////////////////////////
///// Robotic Fabricator /////
//////////////////////////////
/obj/machinery/robotics_fabricator/robotic
	name = "robotic fabricator"
	desc = "A machine that fabricates robot parts, internal components, upgrade modules and power cells."
	icon = 'icons/obj/machines/fabricators/robotic.dmi'

	accepted_materials = list(
		/decl/material/iron, /decl/material/steel, /decl/material/plastic,
		/decl/material/glass, /decl/material/silver, /decl/material/gold,
		/decl/material/diamond, /decl/material/uranium, /decl/material/plasma,
		/decl/material/bananium
	)

	ui_id = "robotic_fabricator"
	design_flag = DESIGN_TYPE_ROBOFAB

	part_sets = list(
		"Robot",
		"Robot Internal Components",
		"Robot Upgrade Modules",
		"Power Cells"
	)

/obj/machinery/robotics_fabricator/robotic/add_parts()
	. = ..()
	component_parts.Add(new /obj/item/circuitboard/robofab(src))

////////////////////////////
///// Mecha Fabricator /////
////////////////////////////
/obj/machinery/robotics_fabricator/mecha
	name = "exosuit fabricator"
	desc = "A machine that fabricates exosuit parts, equipment and power cells."
	icon = 'icons/obj/machines/fabricators/mecha.dmi'

	// Durasteel, verdantium and morphium are considered "hidden materials" meaning they won't display unless present.
	accepted_materials = list(
		/decl/material/iron, /decl/material/steel, /decl/material/plastic,
		/decl/material/glass, /decl/material/silver, /decl/material/gold,
		/decl/material/diamond, /decl/material/uranium, /decl/material/plasma,
		/decl/material/bananium, /decl/material/tranquilite, /decl/material/durasteel,
		/decl/material/verdantium, /decl/material/morphium
	)

	ui_id = "mecha_fabricator"
	design_flag = DESIGN_TYPE_MECHFAB

	part_sets = list(
		"Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark",
		"Clarke",
		"Odysseus",
		"Gygax", "Serenity",
		"Durand", "Archambeau", "Brigand",
		"Phazon", "Janus" = FALSE, "Imperion" = FALSE, // These are so high tech they need the safeties disabled (they need it emagged).
		"H.O.N.K",
		"Reticence",
		"Justice" = FALSE, // This one's associative because it's hidden unless emagged.
		"General Exosuit Equipment",
		"Working Exosuit Equipment",
		"Medical Exosuit Equipment",
		"Combat Exosuit Equipment", "Exosuit Weapons",
		"Exosuit Conversion Kits",
		"Power Cells"
	)

/obj/machinery/robotics_fabricator/mecha/add_parts()
	. = ..()
	component_parts.Add(new /obj/item/circuitboard/mechfab(src))