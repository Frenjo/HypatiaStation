// Special
// This is only used for the Phazon and Eidolon currently.
/datum/construction/reversible/mecha/special
	var/optional_circuit = null
	var/optional_circuit_name = "targeting" // This will basically never change but is here for future-proofing.

	var/obj/item/stock_part/scanning_module/scanning_module = null
	var/obj/item/stock_part/capacitor/capacitor = null

	var/internal_armour = null
	var/external_armour = null

/datum/construction/reversible/mecha/special/get_circuit_steps()
	. = ..()
	. += list(
		list(
			"desc" = "The peripherals control module is secured.",
			"key" = optional_circuit,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed [optional_circuit_name] module",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened peripherals control module"
		),
		list(
			"desc" = "The [optional_circuit_name] module is installed.",
			"key" = /obj/item/screwdriver,
			"message" = "secured [optional_circuit_name] module",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed [optional_circuit_name] module"
		)
	)

/datum/construction/reversible/mecha/special/get_stock_part_steps()
	. = ..()
	. += list(
		list(
			"desc" = "The [optional_circuit_name] module is secured.",
			"key" = scanning_module,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed [scanning_module::name]",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened [optional_circuit_name] module"
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

/datum/construction/reversible/mecha/special/get_other_steps()
	. = ..()
	. += list(
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
			"key" = internal_armour,
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