/*
 * Clawing.
 */
/decl/unarmed_attack/claws
	attack_verb = list("scratch", "claw")
	attack_sound = 'sound/weapons/melee/slice.ogg'
	miss_sound = 'sound/weapons/melee/slashmiss.ogg'
	damage = 5
	sharp = TRUE
	edge = TRUE

/decl/unarmed_attack/claws/strong
	attack_verb = list("slash")
	damage = 10
	shredding = TRUE