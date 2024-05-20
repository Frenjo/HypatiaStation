/*
 * Subspace Stock Parts
 */
/obj/item/stock_part/subspace
	matter_amounts = list(MATERIAL_METAL = 30, MATERIAL_GLASS = 10)

// Subspace Ansible
/obj/item/stock_part/subspace/ansible
	name = "subspace ansible"
	icon_state = "subspace_ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	origin_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 5, /datum/tech/programming = 3,
		/datum/tech/bluespace = 2
	)

// Hyperwave Filter
/obj/item/stock_part/subspace/filter
	name = "hyperwave filter"
	icon_state = "hyperwave_filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	origin_tech = list(/datum/tech/magnets = 2, /datum/tech/programming = 4)

// Subspace Amplifier
/obj/item/stock_part/subspace/amplifier
	name = "subspace amplifier"
	icon_state = "subspace_amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	origin_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/programming = 3,
		/datum/tech/bluespace = 2
	)

// Subspace Treatment Disk
/obj/item/stock_part/subspace/treatment
	name = "subspace treatment disk"
	icon_state = "treatment_disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	origin_tech = list(
		/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/programming = 3,
		/datum/tech/bluespace = 2
	)

// Subspace Wavelength Analyser
/obj/item/stock_part/subspace/analyser
	name = "subspace wavelength analyser"
	icon_state = "wavelength_analyser"
	desc = "A sophisticated analyser capable of analyzing cryptic subspace wavelengths."
	origin_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/programming = 3,
		/datum/tech/bluespace = 2
	)

// Ansible Crystal
/obj/item/stock_part/subspace/crystal
	name = "ansible crystal"
	icon_state = "ansible_crystal"
	desc = "A crystal made from pure glass used to transmit laser databursts to subspace."
	matter_amounts = list(MATERIAL_GLASS = 50)
	origin_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/bluespace = 2)

// Subspace Transmitter
/obj/item/stock_part/subspace/transmitter
	name = "subspace transmitter"
	icon_state = "subspace_transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	matter_amounts = list(MATERIAL_METAL = 50)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 5, /datum/tech/bluespace = 3)