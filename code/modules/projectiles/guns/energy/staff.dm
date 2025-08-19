/obj/item/gun/energy/staff
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	icon_state = "staffofchange"
	item_state = "staffofchange"

	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	origin_tech = null

	fire_sound = 'sound/weapons/gun/emitter.ogg'

	clumsy_check = FALSE

	charge_cost = 200

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/projectile/change)

	self_charging = TRUE
	recharge_time = 0.4 SECONDS

/obj/item/gun/energy/staff/update_icon()
	return

/obj/item/gun/energy/staff/click_empty(mob/user = null)
	if(isnotnull(user))
		user.visible_message(
			"*fizzle*",
			SPAN_DANGER("*fizzle*")
		)
	else
		visible_message("*fizzle*")
	playsound(src, 'sound/effects/sparks/sparks1.ogg', 100, 1)

/obj/item/gun/energy/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."

	charge_cost = 100

	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/projectile/animate)

/obj/item/gun/energy/staff/focus
	name = "mental focus"
	desc = "An artefact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "focus"
	item_state = "focus"

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/projectile/forcebolt)
	/*
	attack_self(mob/living/user)
		if(projectile_type == "/obj/projectile/forcebolt")
			charge_cost = 200
			user << "\red The [name] will now strike a small area."
			projectile_type = "/obj/projectile/forcebolt/strong"
		else
			charge_cost = 100
			user << "\red The [name] will now strike only a single person."
			projectile_type = "/obj/projectile/forcebolt"
	*/