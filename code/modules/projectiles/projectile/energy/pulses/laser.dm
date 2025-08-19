/obj/projectile/energy/pulse/laser
	name = "laser pulse"
	icon_state = "laser"

	damage = 25
	flag = "laser"
	eyeblur = 4

	var/frequency = 1

/obj/projectile/energy/pulse/laser/heavy
	name = "heavy laser pulse"
	icon_state = "heavylaser"

	damage = 40

/obj/projectile/energy/pulse/laser/heavy/death
	name = "death laser pulse"

	damage = 60

/obj/projectile/energy/pulse/laser/practice
	damage = 0
	nodamage = TRUE

	eyeblur = 2

// X-ray
/obj/projectile/energy/pulse/laser/xray
	name = "xray pulse"
	icon_state = "xray"

	damage = 30

/*
 * Laser Tag Projectiles
 */
/obj/projectile/energy/pulse/laser/tag/blue
	name = "lasertag pulse"
	icon_state = "bluelaser"

	damage = 0
	nodamage = TRUE

/obj/projectile/energy/pulse/laser/tag/blue/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/red))
			M.Weaken(5)
	return 1

/obj/projectile/energy/pulse/laser/tag/red
	name = "lasertag pulse"
	icon_state = "laser"

	damage = 0
	nodamage = TRUE

/obj/projectile/energy/pulse/laser/tag/red/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/blue))
			M.Weaken(5)
	return 1

/obj/projectile/energy/pulse/laser/tag/omni//A laser tag bolt that stuns EVERYONE
	name = "lasertag pulse"
	icon_state = "omnilaser"

	damage = 0
	nodamage = TRUE

/obj/projectile/energy/pulse/laser/tag/omni/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/blue) || istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/red))
			M.Weaken(5)
	return 1