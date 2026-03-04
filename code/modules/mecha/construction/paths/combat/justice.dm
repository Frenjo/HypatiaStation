// Justice Chassis
/datum/component/construction/mecha_chassis/justice
	result = /datum/component/construction/reversible/mecha/combat/justice
	steps = list(
		list("key" = /obj/item/mecha_part/part/justice/torso),
		list("key" = /obj/item/mecha_part/part/justice/left_arm),
		list("key" = /obj/item/mecha_part/part/justice/right_arm),
		list("key" = /obj/item/mecha_part/part/justice/left_leg),
		list("key" = /obj/item/mecha_part/part/justice/right_leg)
	)

// Justice
/datum/component/construction/reversible/mecha/combat/justice
	result = /obj/mecha/combat/justice

	base_icon_state = "justice"

	scanning_module = /obj/item/stock_part/scanning_module/adv
	capacitor = /obj/item/stock_part/capacitor/adv

// This one is a weirdo and has no peripherals board.
/datum/component/construction/reversible/mecha/combat/justice/get_circuit_steps()
	. = list(
		list(
			"desc" = "The wiring is adjusted.",
			"key" = /obj/item/circuitboard/mecha/justice/main,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed central control module",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "disconnected wiring"
		),
		list(
			"desc" = "The central control module is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured central control module",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed central control module"
		),
		list(
			"desc" = "The central control module is secured.",
			"key" = /obj/item/circuitboard/mecha/justice/targeting,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed targeting module",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened central control module"
		),
		list(
			"desc" = "The targeting module is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured targeting module",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed targeting module"
		)
	)

/datum/component/construction/reversible/mecha/combat/justice/get_other_steps()
	. = list(
		list(
			"desc" = "The [capacitor::name] is secured.",
			"key" = /obj/item/bluespace_crystal/artificial,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed artificial bluespace crystal",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened [capacitor::name]"
		),
		list(
			"desc" = "An artificial bluespace crystal is installed.",
			"key" = /obj/item/mecha_part/part/justice/armour,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed external armour plates",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "removed artificial bluespace crystal"
		),
		list(
			"desc" = "The external armour plates are installed.",
			"key" = /obj/item/wrench,
			"message" = "wrenched external armour plates",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed external armour plates"
		),
		list(
			"desc" = "The external armour plates are wrenched.",
			"key" = /obj/item/welding_torch,
			"message" = "welded external armour plates",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened external armour plates"
		)
	)