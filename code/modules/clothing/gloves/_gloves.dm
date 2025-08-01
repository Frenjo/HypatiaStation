/*
 * Gloves
 */
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = 2.0
	icon = 'icons/obj/items/clothing/gloves.dmi'
	siemens_coefficient = 0.50

	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	species_restricted = list("exclude", SPECIES_SOGHUN, SPECIES_TAJARAN)

	var/wired = FALSE
	var/obj/item/cell/cell = 0
	var/clipped = FALSE

/obj/item/clothing/gloves/emp_act(severity)
	if(isnotnull(cell))
		//why is this not part of the powercell code?
		cell.charge -= 1000 / severity
		if(cell.charge < 0)
			cell.charge = 0
		if(cell.reliability != 100 && prob(50 / severity))
			cell.reliability -= 10 / severity
	..()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(atom/A, proximity)
	return 0 // return 1 to cancel attack_hand()