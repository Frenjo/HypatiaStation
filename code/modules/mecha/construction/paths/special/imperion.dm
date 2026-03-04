// Imperion Chassis
/datum/component/construction/mecha_chassis/imperion
	result = /datum/component/construction/reversible/mecha/special/imperion
	steps = list(
		list("key" = /obj/item/mecha_part/part/imperion/torso),
		list("key" = /obj/item/mecha_part/part/imperion/head),
		list("key" = /obj/item/mecha_part/part/imperion/left_arm),
		list("key" = /obj/item/mecha_part/part/imperion/right_arm),
		list("key" = /obj/item/mecha_part/part/imperion/left_leg),
		list("key" = /obj/item/mecha_part/part/imperion/right_leg)
	)

// Imperion
/datum/component/construction/reversible/mecha/special/imperion
	result = /obj/mecha/combat/phazon/imperion

	base_icon_state = "imperion"

	central_circuit = /obj/item/circuitboard/mecha/imperion/main
	peripherals_circuit = /obj/item/circuitboard/mecha/imperion/peripherals
	optional_circuit = /obj/item/circuitboard/mecha/imperion/targeting

	scanning_module = /obj/item/stock_part/scanning_module/hyperphasic
	capacitor = /obj/item/stock_part/capacitor/hyper

	internal_armour = /obj/item/stack/sheet/durasteel
	external_armour = /obj/item/mecha_part/part/imperion/armour

/datum/component/construction/reversible/mecha/special/imperion/get_circuit_steps()
	. = ..()
	. += list(
		list(
			"desc" = "The [optional_circuit_name] module is secured.",
			"key" = /obj/item/circuitboard/mecha/imperion/phasing,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed phasing control module",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened [optional_circuit_name] module"
		),
		list(
			"desc" = "The phasing control module is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured phasing control module",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed phasing control module"
		),
		list(
			"desc" = "The phasing control module is secured.",
			"key" = /obj/item/stack/sheet/morphium,
			"amount" = 5,
			"message" = "applied inner morphium layer",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened phasing control module"
		)
	)

/datum/component/construction/reversible/mecha/special/imperion/get_stock_part_steps()
	. = list(
		list(
			"desc" = "The inner morphium layer is applied.",
			"key" = /obj/item/brain,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed organic central processor",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed inner morphium layer"
		),
		list(
			"desc" = "The organic central processor is installed.",
			"key" = /obj/item/cautery,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "cauterised nerve endings",
			"back_key" = /obj/item/hemostat,
			"back_message" = "removed organic central processor"
		),
		list(
			"desc" = "The organic central processor is connected.",
			"key" = scanning_module,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed [scanning_module::name]",
			"back_key" = /obj/item/scalpel,
			"back_message" = "disconnected organic central processor"
		),
		list(
			"desc" = "\A [scanning_module::name] is installed.",
			"key" = /obj/item/stack/nanopaste,
			"message" = "absorbed [scanning_module::name]",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed [scanning_module::name]"
		),
		list(
			"desc" = "The [scanning_module::name] has been absorbed.",
			"key" = /obj/item/heart,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed organic fluid circulator",
			"back_key" = /obj/item/hemostat,
			"back_message" = "resurfaced [scanning_module::name]"
		),
		list(
			"desc" = "The organic fluid circulator is installed.",
			"key" = /obj/item/cautery,
			"message" = "cauterised exposed veins",
			"back_key" = /obj/item/hemostat,
			"back_message" = "removed organic fluid circulator"
		),
		list(
			"desc" = "The organic fluid circulator is connected.",
			"key" = capacitor,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed [capacitor::name]",
			"back_key" = /obj/item/scalpel,
			"back_message" = "disconnected organic fluid circulator"
		),
		list(
			"desc" = "\A [capacitor::name] is installed.",
			"key" = /obj/item/stack/nanopaste,
			"message" = "absorbed [capacitor::name]",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed [capacitor::name]"
		)
	)

/datum/component/construction/reversible/mecha/special/imperion/get_other_steps()
	. = list(
		list(
			"desc" = "\The [capacitor::name] has been absorbed.",
			"key" = /obj/item/prop/alien/phase_coil,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed reverberating phase coil",
			"back_key" = /obj/item/hemostat,
			"back_message" = "resurfaced [capacitor::name]"
		),
		list(
			"desc" = "The reverberating phase coil is installed.",
			"key" = /obj/item/stack/nanopaste,
			"message" = "absorbed reverberating phase coil",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed reverberating phase coil"
		),
		list(
			"desc" = "The reverberating phase coil has been absorbed.",
			"key" = /obj/item/bluespace_crystal/artificial,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed artificial bluespace crystal",
			"back_key" = /obj/item/hemostat,
			"back_message" = "resurfaced reverberating phase coil"
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
			"key" = /obj/item/stack/nanopaste,
			"amount" = 4,
			"message" = "absorbed artificial bluespace crystal",
			"back_key" = /obj/item/wirecutters,
			"back_message" = "disconnected artificial bluespace crystal"
		),
		list(
			"desc" = "The artificial bluespace crystal has been absorbed.",
			"key" = internal_armour,
			"amount" = 5,
			"message" = "installed internal armour layer",
			"back_key" = /obj/item/hemostat,
			"back_message" = "resurfaced artificial bluespace crystal"
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
			"key" = /obj/item/welding_torch,
			"message" = "welded internal armour layer",
			"back_key" = /obj/item/wrench,
			"back_message" = "unfastened internal armour layer"
		),
		list(
			"desc" = "The internal armour layer is welded.",
			"key" = external_armour,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed external armour plates",
			"back_key" = /obj/item/welding_torch,
			"back_message" = "cut away internal armour layer"
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

/datum/component/construction/reversible/mecha/special/imperion/spawn_result()
	. = ..()
	feedback_inc("mecha_imperion_created", 1)