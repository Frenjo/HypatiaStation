//////////////////////////////
///// Robotic Fabricator /////
//////////////////////////////
/obj/machinery/robotics_fabricator/robotic
	name = "robotic fabricator"
	icon = 'icons/obj/machines/fabricators/robotic.dmi'

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
	icon = 'icons/obj/machines/fabricators/mecha.dmi'

	ui_id = "mecha_fabricator"
	design_flag = DESIGN_TYPE_MECHFAB

	part_sets = list(
		"Ripley", "Firefighter", "Rescue Ranger", "Dreadnought", "Bulwark",
		"Odysseus",
		"Gygax", "Serenity",
		"Durand", "Archambeau",
		"Phazon",
		"H.O.N.K",
		"Reticence",
		"General Exosuit Equipment",
		"Working Exosuit Equipment",
		"Medical Exosuit Equipment",
		"Combat Exosuit Equipment", "Exosuit Weapons",
		"Power Cells"
	)

/obj/machinery/robotics_fabricator/mecha/add_parts()
	. = ..()
	component_parts.Add(new /obj/item/circuitboard/mechfab(src))