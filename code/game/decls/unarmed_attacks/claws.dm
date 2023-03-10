/*
 * Clawing.
 */
/decl/unarmed_attack/claws
	attack_verb = list("scratch", "claw")
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 5
	sharp = TRUE
	edge = TRUE

/decl/unarmed_attack/claws/strong
	attack_verb = list("slash")
	damage = 10
	shredding = TRUE