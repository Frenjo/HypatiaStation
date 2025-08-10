/obj/item/projectile/energy/pulse/laser
	name = "laser pulse"
	icon_state = "laser"

	pass_flags = parent_type::pass_flags | PASS_FLAG_GLASS | PASS_FLAG_GRILLE

	damage = 40
	flag = "laser"
	eyeblur = 4

	var/frequency = 1

/obj/item/projectile/energy/pulse/laser/heavy
	name = "heavy laser pulse"
	icon_state = "heavylaser"

/obj/item/projectile/energy/pulse/laser/heavy/death
	name = "death laser pulse"

	damage = 60

/obj/item/projectile/energy/pulse/laser/practice
	damage = 0
	eyeblur = 2

// X-ray
/obj/item/projectile/energy/pulse/laser/xray
	name = "xray pulse"
	icon_state = "xray"

	damage = 30

// Disabler
/obj/item/projectile/energy/pulse/disabler
	name = "disabler pulse"
	icon_state = "bluespark"

	pass_flags = parent_type::pass_flags | PASS_FLAG_SWARMER

	damage_type = HALLOSS
	nodamage = TRUE
	weaken = 5
	agony = 20

// Pulse
/obj/item/projectile/energy/pulse/pulse
	name = "pulse"
	icon_state = "u_laser"

	damage = 50

	muzzle_type = /obj/effect/projectile/pulse/muzzle

/obj/item/projectile/energy/pulse/deathlaser
	name = "death laser pulse"
	icon_state = "heavylaser"

	damage = 60

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

/*
 * Laser Tag Projectiles
 */
/obj/item/projectile/energy/pulse/laser/tag/blue
	name = "lasertag pulse"
	icon_state = "bluelaser"

	damage = 0
	nodamage = TRUE

/obj/item/projectile/energy/pulse/laser/tag/blue/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/red))
			M.Weaken(5)
	return 1

/obj/item/projectile/energy/pulse/laser/tag/red
	name = "lasertag pulse"
	icon_state = "laser"

	damage = 0
	nodamage = TRUE

/obj/item/projectile/energy/pulse/laser/tag/red/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/blue))
			M.Weaken(5)
	return 1

/obj/item/projectile/energy/pulse/laser/tag/omni//A laser tag bolt that stuns EVERYONE
	name = "lasertag pulse"
	icon_state = "omnilaser"

	damage = 0
	nodamage = TRUE

/obj/item/projectile/energy/pulse/laser/tag/omni/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/blue) || istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/red))
			M.Weaken(5)
	return 1