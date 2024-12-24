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
			/obj/item/mecha_part/chassis/firefighter,
			/obj/item/mecha_part/part/ripley_torso,
			/obj/item/mecha_part/part/ripley_left_arm,
			/obj/item/mecha_part/part/ripley_right_arm,
			/obj/item/mecha_part/part/ripley_left_leg,
			/obj/item/mecha_part/part/ripley_right_leg
		),
		"Rescue Ranger" = list(
			/obj/item/mecha_part/chassis/rescue_ranger,
			/obj/item/mecha_part/part/ripley_torso,
			/obj/item/mecha_part/part/ripley_left_arm,
			/obj/item/mecha_part/part/ripley_right_arm,
			/obj/item/mecha_part/part/ripley_left_leg,
			/obj/item/mecha_part/part/ripley_right_leg
		),
		"Dreadnought" = list(
			/obj/item/mecha_part/chassis/dreadnought,
			/obj/item/mecha_part/part/ripley_torso,
			/obj/item/mecha_part/part/ripley_left_arm,
			/obj/item/mecha_part/part/ripley_right_arm,
			/obj/item/mecha_part/part/ripley_left_leg,
			/obj/item/mecha_part/part/ripley_right_leg
		),
		"Bulwark" = list(
			/obj/item/mecha_part/chassis/bulwark,
			/obj/item/mecha_part/part/ripley_torso,
			/obj/item/mecha_part/part/ripley_left_arm,
			/obj/item/mecha_part/part/ripley_right_arm,
			/obj/item/mecha_part/part/ripley_left_leg,
			/obj/item/mecha_part/part/ripley_right_leg
		),
		"Odysseus" = list(
			/obj/item/mecha_part/chassis/odysseus
		),
		"Gygax" = list(
			/obj/item/mecha_part/chassis/gygax
		),
		"Serenity" = list(
			/obj/item/mecha_part/chassis/serenity
		),
		"Durand" = list(
			/obj/item/mecha_part/chassis/durand
		),
		"Archambeau" = list(),
		"Phazon" = list(),
		"H.O.N.K" = list(
			/obj/item/mecha_part/chassis/honk,
			/obj/item/mecha_part/part/honk_torso,
			/obj/item/mecha_part/part/honk_head,
			/obj/item/mecha_part/part/honk_left_arm,
			/obj/item/mecha_part/part/honk_right_arm,
			/obj/item/mecha_part/part/honk_left_leg,
			/obj/item/mecha_part/part/honk_right_leg
		),
		"General Exosuit Equipment" = list(
			/obj/item/mecha_part/tracking,
			/obj/item/mecha_part/equipment/passenger, // Ported this from NSS Eternal along with the hoverpod. -Frenjo
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