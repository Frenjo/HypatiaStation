// Janus Chassis
/datum/construction/mecha_chassis/janus
	result = /datum/construction/reversible/mecha/special/janus
	steps = list(
		list("key" = /obj/item/mecha_part/part/janus/torso),
		list("key" = /obj/item/mecha_part/part/janus/head),
		list("key" = /obj/item/mecha_part/part/janus/left_arm),
		list("key" = /obj/item/mecha_part/part/janus/right_arm),
		list("key" = /obj/item/mecha_part/part/janus/left_leg),
		list("key" = /obj/item/mecha_part/part/janus/right_leg)
	)

// Janus
/datum/construction/reversible/mecha/special/janus
	result = /obj/mecha/combat/phazon/janus

	base_icon_state = "janus"

	central_circuit = /obj/item/circuitboard/mecha/imperion/main
	peripherals_circuit = /obj/item/circuitboard/mecha/imperion/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/imperion/targeting

	scanning_module = /obj/item/stock_part/scanning_module/hyperphasic
	capacitor = /obj/item/stock_part/capacitor/hyper

	// These are placeholders for Durasteel and Morphium respectively.
	internal_armour = /obj/item/stack/sheet/adamantine
	external_armour = /obj/item/stack/sheet/mythril

/datum/construction/reversible/mecha/special/janus/get_circuit_steps()
	. = ..()
	. += list(
		list(
			"desc" = "The [optional_circuit_name] module is secured.",
			"key" = /obj/item/circuitboard/mecha/gygax/peripherals,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed Gygax peripherals module",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened [optional_circuit_name] module"
		),
		list(
			"desc" = "The Gygax peripherals module is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured Gygax peripherals module",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed Gygax peripherals module"
		),
		list(
			"desc" = "The Gygax peripherals module is secured.",
			"key" = /obj/item/prop/alien/phase_coil,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed reverberating phase coil",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened Gygax peripherals module"
		),
		list(
			"desc" = "The reverberating phase coil is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured reverberating phase coil",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed reverberating phase coil"
		),
		list(
			"desc" = "The reverberating phase coil is secured.",
			"key" = /obj/item/circuitboard/mecha/durand/peripherals,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed Durand peripherals module",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened reverberating phase coil"
		),
		list(
			"desc" = "The Durand peripherals module is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured Durand peripherals module",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed Durand peripherals module"
		)
	)

/datum/construction/reversible/mecha/special/janus/get_stock_part_steps()
	. += list(
		list(
			"desc" = "The Durand peripherals module is secured.",
			"key" = scanning_module,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed [scanning_module::name]",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened Durand peripherals module"
		),
		list(
			"desc" = "\A [scanning_module::name] is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured [scanning_module::name]",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed [scanning_module::name]"
		),
		list(
			"desc" = "The [scanning_module::name] is secured.",
			"key" = capacitor,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed [capacitor::name]",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened [scanning_module::name]"
		),
		list(
			"desc" = "\A [capacitor::name] is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured [capacitor::name]",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed [capacitor::name]"
		)
	)

/datum/construction/reversible/mecha/special/janus/spawn_result()
	. = ..()
	feedback_inc("mecha_janus_created", 1)