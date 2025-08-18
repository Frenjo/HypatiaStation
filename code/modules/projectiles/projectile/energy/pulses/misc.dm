// Disabler
/obj/item/projectile/energy/pulse/disabler
	name = "disabler pulse"
	icon_state = "bluespark"

	pass_flags = parent_type::pass_flags | PASS_FLAG_SWARMER

	damage_type = HALLOSS
	nodamage = TRUE
	weaken = 5
	agony = 20

// Emitter
/obj/item/projectile/energy/pulse/emitter
	name = "emitter pulse"
	icon_state = "emitter"

	damage = 30

// Sniper
/obj/item/projectile/energy/pulse/sniper
	name = "sniper pulse"
	icon_state = "xray"

	damage = 60
	stun = 5
	weaken = 5
	stutter = 5