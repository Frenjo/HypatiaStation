/*
 * Contains:
 *		Security
 *		Detective
 *		Head of Security
 */

/*
 * Security
 */
/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpsuit"
	icon_state = "warden"
	item_state = "r_suit"
	item_color = "warden"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "security"
	item_state = "r_suit"
	item_color = "secred"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon_state = "dispatch"
	item_state = "dispatch"
	item_color = "dispatch"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security2
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "redshirt2"
	item_state = "r_suit"
	item_color = "redshirt2"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security/corp
	icon_state = "sec_corporate"
	item_state = "sec_corporate"
	item_color = "sec_corporate"

/obj/item/clothing/under/rank/warden/corp
	icon_state = "warden_corporate"
	item_state = "warden_corporate"
	item_color = "warden_corporate"

/obj/item/clothing/under/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "swatunder"
	item_state = "swatunder"
	item_color = "swatunder"
	armor = list(melee = 10, bullet = 5, laser = 5, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/*
 * Detective
 */
/obj/item/clothing/under/det
	name = "hard-worn suit"
	desc = "Someone who wears this means business."
	icon_state = "detective"
	item_state = "det"
	item_color = "detective"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/det/black
	icon_state = "detective2"
	item_color = "detective2"

/obj/item/clothing/under/det/slob
	icon_state = "polsuit"
	item_color = "polsuit"

/obj/item/clothing/under/det/slob/verb/rollup()
	set category = PANEL_OBJECT
	set name = "Roll suit sleeves"
	set src in usr

	item_color = item_color == "polsuit" ? "polsuit_rolled" : "polsuit"
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_wear_uniform(1)

/obj/item/clothing/head/det_hat
	name = "hat"
	desc = "Someone who wears this will look very smart."
	icon_state = "detective"
	armor = list(melee = 50, bullet = 5, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/head/det_hat/black
	icon_state = "detective2"


/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armour to protect the wearer."
	name = "head of security's jumpsuit"
	icon_state = "hos"
	item_state = "r_suit"
	item_color = "hosred"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/head_of_security/corp
	icon_state = "hos_corporate"
	item_state = "hos_corporate"
	item_color = "hos_corporate"

/obj/item/clothing/head/helmet/HoS
	name = "head of security's hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	item_flags = ITEM_FLAG_COVERS_EYES
	armor = list(melee = 80, bullet = 60, laser = 50, energy = 10, bomb = 25, bio = 10, rad = 0)
	inv_flags = INV_FLAG_HIDE_EARS
	siemens_coefficient = 0.8

/obj/item/clothing/suit/armor/hos
	name = "armoured coat"
	desc = "A greatcoat enhanced with a special alloy for some protection and style."
	icon_state = "hos"
	item_state = "hos"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	inv_flags = INV_FLAG_HIDE_JUMPSUIT
	siemens_coefficient = 0.6


/obj/item/clothing/head/helmet/HoS/dermal
	name = "dermal armour patch"
	desc = "You're not quite sure how you manage to take it on and off, but it implants nicely in your head."
	icon_state = "dermal"
	item_state = "dermal"
	siemens_coefficient = 0.6

//Jensen cosplay gear
/obj/item/clothing/under/rank/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon_state = "jensen"
	item_state = "jensen"
	item_color = "jensen"
	siemens_coefficient = 0.6

/obj/item/clothing/suit/armor/hos/jensen
	name = "armoured trenchcoat"
	desc = "A trenchcoat augmented with a special alloy for some protection and style."
	icon_state = "jensencoat"
	item_state = "jensencoat"
	inv_flags = null
	siemens_coefficient = 0.6