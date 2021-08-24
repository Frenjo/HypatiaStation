/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle."
	name = "magboots"
	icon_state = "magboots0"
	species_restricted = null
	var/magpulse = 0
	icon_action_button = "action_blank"
	action_button_name = "Toggle the magboots"
//	flags = NOSLIP //disabled by default

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		flags &= ~NOSLIP
		slowdown = SHOES_SLOWDOWN
		magpulse = 0
		icon_state = "magboots0"
		to_chat(user, "You disable the mag-pulse traction system.")
	else
		flags |= NOSLIP
		slowdown = 2
		magpulse = 1
		icon_state = "magboots1"
		to_chat(user, "You enable the mag-pulse traction system.")
	user.update_inv_shoes()	//so our mob-overlays update

/obj/item/clothing/shoes/magboots/examine()
	set src in view()
	..()
	var/state = "disabled"
	if(src.flags & NOSLIP)
		state = "enabled"
	to_chat(usr, "Its mag-pulse traction system appears to be [state].")

// Added advanced magboots for the CE, they're even that weird off-white colour like the hardsuit. -Frenjo
/obj/item/clothing/shoes/magboots/advanced
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. These look advanced."
	name = "advanced magboots"
	icon_state = "advmagboots0"

/obj/item/clothing/shoes/magboots/advanced/attack_self(mob/user)
	if(magpulse)
		flags &= ~NOSLIP
		slowdown = SHOES_SLOWDOWN
		magpulse = 0
		icon_state = "advmagboots0"
		to_chat(user, "You disable the advanced mag-pulse traction system.")
	else
		flags |= NOSLIP
		slowdown = 1
		magpulse = 1
		icon_state = "advmagboots1"
		to_chat(user, "You enable the advanced mag-pulse traction system.")
	user.update_inv_shoes()

/obj/item/clothing/shoes/magboots/advanced/examine()
	set src in view()
	..()
	var/state = "disabled"
	if(src.flags & NOSLIP)
		state = "enabled"
	to_chat(usr, "Its advanced mag-pulse traction system appears to be [state].")