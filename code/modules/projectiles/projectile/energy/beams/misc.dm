// Disabler
/obj/projectile/energy/beam/disabler
	name = "disabler beam"

	// It's INTENDED that disabler BEAMS do not pass through Swarmers like pulses do, since Swarmers don't use beams!

	damage_type = HALLOSS
	nodamage = TRUE
	weaken = 5
	agony = 20

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

// This refers to actual pulse rifle pulses.
/obj/projectile/energy/beam/pulse
	name = "pulse beam"

	damage = 50

	muzzle_type = /obj/effect/projectile/laser_pulse/muzzle
	tracer_type = /obj/effect/projectile/laser_pulse/tracer
	impact_type = /obj/effect/projectile/laser_pulse/impact

// Emitter
/obj/projectile/energy/beam/emitter
	name = "emitter beam"

	damage = 30

	muzzle_type = /obj/effect/projectile/emitter/muzzle
	tracer_type = /obj/effect/projectile/emitter/tracer
	impact_type = /obj/effect/projectile/emitter/impact

// Sniper
/obj/projectile/energy/beam/sniper
	name = "sniper beam"

	damage = 60
	stun = 5
	weaken = 5
	stutter = 5

	// This needs to be changed later.
	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

// Mindflayer
/obj/projectile/energy/beam/mindflayer
	name = "flayer ray"

	damage = 0
	nodamage = TRUE

/obj/projectile/energy/beam/mindflayer/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.adjustBrainLoss(20)
		M.hallucination += 20