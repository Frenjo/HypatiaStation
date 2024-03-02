/obj/item/melee/cultblade
	name = "Cult Blade"
	desc = "An arcane weapon wielded by the followers of Nar-Sie"
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "cultblade"
	item_state = "cultblade"
	w_class = 4
	force = 30
	throwforce = 10
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/melee/cultblade/attack(mob/living/target as mob, mob/living/carbon/human/user as mob)
	if(iscultist(user))
		playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
		return ..()
	else
		user.Paralyse(5)
		to_chat(user, SPAN_WARNING("An unexplicable force powerfully repels the sword from [target]!"))
		var/organ = ((user.hand ? "l_" : "r_") + "arm")
		var/datum/organ/external/affecting = user.get_organ(organ)
		if(affecting.take_damage(rand(force / 2, force))) //random amount of damage between half of the blade's force and the full force of the blade.
			user.UpdateDamageIcon()
	return

/obj/item/melee/cultblade/pickup(mob/living/user as mob)
	if(!iscultist(user))
		to_chat(user, SPAN_WARNING("An overwhelming feeling of dread comes over you as you pick up the cultist's sword. It would be wise to be rid of this blade quickly."))
		user.make_dizzy(120)

/obj/item/clothing/head/culthood
	name = "cult hood"
	icon_state = "culthood"
	desc = "A hood worn by the followers of Nar-Sie."
	item_flags = ITEM_FLAG_COVERS_EYES
	inv_flags = INV_FLAG_HIDE_FACE
	armor = list(melee = 30, bullet = 10, laser = 5, energy = 5, bomb = 0, bio = 0, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/culthood/alt
	icon_state = "cult_hoodalt"
	item_state = "cult_hoodalt"

/obj/item/clothing/suit/cultrobes/alt
	icon_state = "cultrobesalt"
	item_state = "cultrobesalt"

/obj/item/clothing/suit/cultrobes
	name = "cult robes"
	desc = "A set of armored robes worn by the followers of Nar-Sie"
	icon_state = "cultrobes"
	item_state = "cultrobes"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 20, bomb = 25, bio = 10, rad = 0)
	inv_flags = INV_FLAG_HIDE_JUMPSUIT
	siemens_coefficient = 0

/obj/item/clothing/head/magus
	name = "magus helm"
	icon_state = "magus"
	item_state = "magus"
	desc = "A helm worn by the followers of Nar-Sie."
	item_flags = ITEM_FLAG_COVERS_EYES | ITEM_FLAG_COVERS_MOUTH
	inv_flags = INV_FLAG_HIDE_FACE | INV_FLAG_BLOCK_HAIR
	armor = list(melee = 30, bullet = 30, laser = 30, energy = 20, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0

/obj/item/clothing/suit/magusred
	name = "magus robes"
	desc = "A set of armored robes worn by the followers of Nar-Sie"
	icon_state = "magusred"
	item_state = "magusred"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 20, bomb = 25, bio = 10, rad = 0)
	inv_flags = INV_FLAG_HIDE_GLOVES | INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES
	siemens_coefficient = 0

/obj/item/clothing/head/helmet/space/cult
	name = "cult helmet"
	desc = "A space worthy helmet used by the followers of Nar-Sie"
	icon_state = "cult_helmet"
	item_state = "cult_helmet"
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0

/obj/item/clothing/suit/space/cult
	name = "cult armour"
	icon_state = "cult_armour"
	item_state = "cult_armour"
	desc = "A bulky suit of armour, bristling with spikes. It looks space proof."
	w_class = 3
	allowed = list(
		/obj/item/tome,
		/obj/item/melee/cultblade,
		/obj/item/tank/emergency/oxygen,
		/obj/item/suit_cooling_unit
	)
	slowdown = 1
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0