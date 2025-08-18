/obj/item/projectile/energy/beam/laser
	name = "laser beam"

	damage = 25

	muzzle_type = /obj/effect/projectile/laser/muzzle
	tracer_type = /obj/effect/projectile/laser/tracer
	impact_type = /obj/effect/projectile/laser/impact

/obj/item/projectile/energy/beam/laser/heavy
	name = "heavy laser beam"

	damage = 40

	muzzle_type = /obj/effect/projectile/laser_heavy/muzzle
	tracer_type = /obj/effect/projectile/laser_heavy/tracer
	impact_type = /obj/effect/projectile/laser_heavy/impact

/obj/item/projectile/energy/beam/laser/heavy/death
	name = "death laser beam"

	damage = 60

/obj/item/projectile/energy/beam/laser/practice
	damage = 0
	nodamage = TRUE

	eyeblur = 2

// X-ray
/obj/item/projectile/energy/beam/laser/xray
	name = "xray laser beam"

	damage = 30

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/*
 * Laser Tag Projectiles
 */
/obj/item/projectile/energy/beam/laser/tag
	name = "lasertag beam"

	damage = 0
	nodamage = TRUE

/obj/item/projectile/energy/beam/laser/tag/blue
	muzzle_type = /obj/effect/projectile/laser_blue/muzzle
	tracer_type = /obj/effect/projectile/laser_blue/tracer
	impact_type = /obj/effect/projectile/laser_blue/impact

/obj/item/projectile/energy/beam/laser/tag/blue/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/red))
			M.Weaken(5)
	return 1

/obj/item/projectile/energy/beam/laser/tag/red
	muzzle_type = /obj/effect/projectile/laser/muzzle
	tracer_type = /obj/effect/projectile/laser/tracer
	impact_type = /obj/effect/projectile/laser/impact

/obj/item/projectile/energy/beam/laser/tag/red/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/blue))
			M.Weaken(5)
	return 1

/obj/item/projectile/energy/beam/laser/tag/omni // A laser tag bolt that stuns EVERYONE
	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

/obj/item/projectile/energy/beam/laser/tag/omni/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/blue) || istype(M.wear_suit, /obj/item/clothing/suit/laser_tag/red))
			M.Weaken(5)
	return 1