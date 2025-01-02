/datum/construction/reversible/mecha/combat
	var/optional_circuit = null
	var/optional_circuit_name = "targeting" // This should either be "targeting" or "medical".

	var/scanning_module = null
	var/scanning_module_name = null // I have to do this manually on each subtype because I can't dynamically do scanning_module::name.
	var/capacitor = null
	var/capacitor_name = null // See above.

	var/internal_armour = null
	var/external_armour = null
	var/is_external_carapace = FALSE

/datum/construction/reversible/mecha/combat/get_circuit_steps()
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

/datum/construction/reversible/mecha/combat/get_stock_part_steps()
	. = ..()
	. += list(
		list(
			"desc" = "The [optional_circuit_name] module is secured.",
			"key" = scanning_module,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed [scanning_module_name]",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened [optional_circuit_name] module"
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

/datum/construction/reversible/mecha/combat/get_other_steps()
	. = ..()
	. += list(
		list(
			"desc" = "The [capacitor_name] is secured.",
			"key" = internal_armour,
			"amount" = 5,
			"message" = "installed internal armour layer",
			"back_key" = /obj/item/screwdriver,
			"back_message" = "unfastened [capacitor_name]"
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
			"key" = external_armour,
			"action" = CONSTRUCTION_ACTION_DELETE,
			"message" = "installed external [is_external_carapace ? "carapace" : "armour plates"]",
			"back_key" = /obj/item/weldingtool,
			"back_message" = "cut away internal armour layer"
		),
		list(
			"desc" = "The external [is_external_carapace ? "carapace is " : "armour plates are "]installed.",
			"key" = /obj/item/wrench,
			"message" = "wrenched external [is_external_carapace ? "carapace" : "armour plates"]",
			"back_key" = /obj/item/crowbar,
			"back_message" = "removed external [is_external_carapace ? "carapace" : "armour plates"]"
		)
	)