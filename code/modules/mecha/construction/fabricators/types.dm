//////////////////////////////
///// Robotic Fabricator /////
//////////////////////////////
/obj/machinery/robotics_fabricator/robotic
	name = "robotic fabricator"
	icon = 'icons/obj/machines/fabricators/robotic.dmi'

	ui_id = "robotic_fabricator"
	design_flag = DESIGN_TYPE_ROBOFAB

	part_sets = list(
		"Robot" = list(
			/obj/item/robot_parts/robot_suit,
			/obj/item/robot_parts/chest,
			/obj/item/robot_parts/head,
			/obj/item/robot_parts/l_arm,
			/obj/item/robot_parts/r_arm,
			/obj/item/robot_parts/l_leg,
			/obj/item/robot_parts/r_leg
		),
		"Robot Internal Components" = list(
			/obj/item/robot_parts/robot_component/binary_communication_device,
			/obj/item/robot_parts/robot_component/radio,
			/obj/item/robot_parts/robot_component/actuator,
			/obj/item/robot_parts/robot_component/diagnosis_unit,
			/obj/item/robot_parts/robot_component/camera,
			/obj/item/robot_parts/robot_component/armour
		),
		"Robot Upgrade Modules" = list(
			/obj/item/borg/upgrade/reset,
			/obj/item/borg/upgrade/rename,
			/obj/item/borg/upgrade/restart,
			/obj/item/borg/upgrade/vtec,
			/obj/item/borg/upgrade/tasercooler,
			/obj/item/borg/upgrade/jetpack
		),
		"Power Cells" = list(
			/obj/item/cell
		)
	)

/obj/machinery/robotics_fabricator/robotic/New()
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
		"Ripley" = list(
			/obj/item/mecha_part/chassis/ripley,
			/obj/item/mecha_part/part/ripley_torso,
			/obj/item/mecha_part/part/ripley_left_arm,
			/obj/item/mecha_part/part/ripley_right_arm,
			/obj/item/mecha_part/part/ripley_left_leg,
			/obj/item/mecha_part/part/ripley_right_leg
		),
		"Firefighter" = list(
			/obj/item/mecha_part/chassis/firefighter
		),
		"Odysseus" = list(
			/obj/item/mecha_part/chassis/odysseus
		),
		"Gygax" = list(
			/obj/item/mecha_part/chassis/gygax,
			/obj/item/mecha_part/part/gygax_torso,
			/obj/item/mecha_part/part/gygax_head,
			/obj/item/mecha_part/part/gygax_left_arm,
			/obj/item/mecha_part/part/gygax_right_arm,
			/obj/item/mecha_part/part/gygax_left_leg,
			/obj/item/mecha_part/part/gygax_right_leg,
			/obj/item/mecha_part/part/gygax_armour
		),
		"Durand" = list(
			/obj/item/mecha_part/chassis/durand,
			/obj/item/mecha_part/part/durand_torso,
			/obj/item/mecha_part/part/durand_head,
			/obj/item/mecha_part/part/durand_left_arm,
			/obj/item/mecha_part/part/durand_right_arm,
			/obj/item/mecha_part/part/durand_left_leg,
			/obj/item/mecha_part/part/durand_right_leg,
			/obj/item/mecha_part/part/durand_armour
		),
		"Phazon" = list(),
		"H.O.N.K" = list(
			/obj/item/mecha_part/chassis/honker,
			/obj/item/mecha_part/part/honker_torso,
			/obj/item/mecha_part/part/honker_head,
			/obj/item/mecha_part/part/honker_left_arm,
			/obj/item/mecha_part/part/honker_right_arm,
			/obj/item/mecha_part/part/honker_left_leg,
			/obj/item/mecha_part/part/honker_right_leg
		),
		"General Exosuit Equipment" = list(
			/obj/item/mecha_part/tracking,
			/obj/item/mecha_part/equipment/tool/passenger, // Ported this from NSS Eternal along with the hoverpod. -Frenjo
			///obj/item/mecha_part/equipment/jetpack, //TODO MECHA JETPACK SPRITE MISSING,
		),
		"Working Exosuit Equipment" = list(
			/obj/item/mecha_part/equipment/tool/hydraulic_clamp,
			/obj/item/mecha_part/equipment/tool/drill,
			/obj/item/mecha_part/equipment/tool/extinguisher,
			/obj/item/mecha_part/equipment/tool/cable_layer
		),
		"Medical Exosuit Equipment" = list(),
		"Combat Exosuit Equipment" = list(),
		"Exosuit Weapons" = list(
			/obj/item/mecha_part/equipment/weapon/energy/taser,
			/obj/item/mecha_part/equipment/weapon/ballistic/lmg,
			/obj/item/mecha_part/equipment/weapon/honker,
			/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/banana_mortar,
			/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/banana_mortar/mousetrap_mortar
		),
		"Power Cells" = list(
			/obj/item/cell
		)
	)

/obj/machinery/robotics_fabricator/mecha/New()
	. = ..()
	component_parts.Add(new /obj/item/circuitboard/mechfab(src))