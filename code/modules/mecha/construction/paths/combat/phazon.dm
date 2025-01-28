// Phazon Chassis
/datum/construction/mecha_chassis/phazon
	result = /datum/construction/reversible/mecha/phazon
	steps = list(
		list("key" = /obj/item/mecha_part/part/phazon/torso),
		list("key" = /obj/item/mecha_part/part/phazon/head),
		list("key" = /obj/item/mecha_part/part/phazon/left_arm),
		list("key" = /obj/item/mecha_part/part/phazon/right_arm),
		list("key" = /obj/item/mecha_part/part/phazon/left_leg),
		list("key" = /obj/item/mecha_part/part/phazon/right_leg)
	)

// Phazon
/datum/construction/reversible/mecha/phazon
	result = /obj/mecha/combat/phazon

	base_icon_state = "phazon"

	central_circuit = /obj/item/circuitboard/mecha/phazon/main
	peripherals_circuit = /obj/item/circuitboard/mecha/phazon/peripherals

	var/scanning_module = /obj/item/stock_part/scanning_module/hyperphasic
	var/scanning_module_name = /obj/item/stock_part/scanning_module/hyperphasic::name
	var/capacitor = /obj/item/stock_part/capacitor/hyper
	var/capacitor_name = /obj/item/stock_part/capacitor/hyper::name

/datum/construction/reversible/mecha/phazon/get_circuit_steps()
	. = ..()
	. += list(
		list(
			"desc" = "The peripherals control module is secured.",
			"key" = /obj/item/circuitboard/mecha/phazon/targeting,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed targeting module",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened peripherals control module"
		),
		list(
			"desc" = "The targeting module is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured targeting module",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed targeting module"
		)
	)

/datum/construction/reversible/mecha/phazon/get_stock_part_steps()
	. = ..()
	. += list(
		list(
			"desc" = "The targeting module is secured.",
			"key" = scanning_module,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed [scanning_module_name]",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened targeting module"
		),
		list(
			"desc" = "\A [scanning_module_name] is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured [scanning_module_name]",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed [scanning_module_name]"
		),
		list(
			"desc" = "The [scanning_module_name] is secured.",
			"key" = capacitor,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed [capacitor_name]",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened [scanning_module_name]"
		),
		list(
			"desc" = "\A [capacitor_name] is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured [capacitor_name]",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed [capacitor_name]"
		)
	)

/datum/construction/reversible/mecha/phazon/get_other_steps()
	. = ..()
	. += list(
		list(
			"desc" = "The [capacitor_name] is secured.",
			"key" = /obj/item/bluespace_crystal/artificial,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed artificial bluespace crystal",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened [capacitor_name]"
		),
		list(
			"desc" = "An artificial bluespace crystal is installed.",
			"key" = /obj/item/stack/cable_coil,
			"amount" = 4,
			"message" = "wired artificial bluespace crystal",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed artificial bluespace crystal"
		),
		list(
			"desc" = "The artificial bluespace crystal is wired.",
			"key" = /obj/item/screwdriver,
			"amount" = 4,
			"message" = "secured artificial bluespace crystal",
			"back_key" = /obj/item/wirecutters,
			"back_message" = "disconnected artificial bluespace crystal"
		),
		list(
			"desc" = "The artificial bluespace crystal is secured.",
			"key" = /obj/item/stack/sheet/plasteel,
			"amount" = 5,
			"message" = "installed internal armour layer",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened artificial bluespace crystal"
		),
		list(
			"desc" = "The internal armour layer is installed.",
			"key" = /obj/item/wrench,
			"message" = "wrenched internal armour layer",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed internal armour layer"
		),
		list(
			"desc" = "The internal armour layer is wrenched.",
			"key" = /obj/item/weldingtool,
			"message" = "welded internal armour layer",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened internal armour layer"
		),
		list(
			"desc" = "The internal armour layer is welded.",
			"key" = /obj/item/mecha_part/part/phazon/armour,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed external armour plates",
			"back_key" = /obj/item/weldingtool,
			"back_message" = "cut away internal armour layer"
		),
		list(
			"desc" = "The external armour plates are installed.",
			"key" = /obj/item/wrench,
			"message" = "wrenched external armour plates",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed external armour plates"
		),
		// 20
		list(
			"desc" = "The external armour plates are wrenched.",
			"key" = /obj/item/weldingtool,
			"message" = "welded external armour plates",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external armour plates"
		)
	)

/datum/construction/reversible/mecha/phazon/spawn_result()
	. = ..()
	feedback_inc("mecha_phazon_created", 1)