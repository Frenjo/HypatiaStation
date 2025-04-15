/*
 * Biting.
 */
/decl/unarmed_attack/bite
	attack_verb = list("bite") // 'x has biteed y', needs work.
	attack_sound = 'sound/weapons/melee/bite.ogg'
	shredding = TRUE
	damage = 5
	sharp = TRUE
	edge = TRUE

/decl/unarmed_attack/bite/is_usable(mob/living/carbon/human/user)
	if(user.wear_mask && istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		return FALSE
	return TRUE

/decl/unarmed_attack/bite/strong
	attack_verb = list("maul")
	damage = 15