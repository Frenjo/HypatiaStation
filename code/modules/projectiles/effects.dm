/obj/effect/projectile
	icon = 'icons/obj/effects/projectiles.dmi'
	icon_state = "bolt"
	plane = UNLIT_EFFECTS_PLANE

/obj/effect/projectile/New(turf/location)
	. = ..()
	if(istype(location))
		loc = location

/obj/effect/projectile/proc/set_transform(matrix/mat)
	if(istype(mat))
		transform = mat

/obj/effect/projectile/proc/activate()
	spawn(0.3 SECONDS)
		qdel(src)

//----------------------------
// Omni laser beam / Disabler beam
//----------------------------
/obj/effect/projectile/laser_omni/muzzle
	icon_state = "muzzle_omni"

/obj/effect/projectile/laser_omni/tracer
	icon_state = "beam_omni"

/obj/effect/projectile/laser_omni/impact
	icon_state = "impact_omni"

//----------------------------
// Laser beam
//----------------------------
/obj/effect/projectile/laser/muzzle
	icon_state = "muzzle_laser"

/obj/effect/projectile/laser/tracer
	icon_state = "beam"

/obj/effect/projectile/laser/impact
	icon_state = "impact_laser"

//----------------------------
// Blue laser beam
//----------------------------
/obj/effect/projectile/laser_blue/muzzle
	icon_state = "muzzle_blue"

/obj/effect/projectile/laser_blue/tracer
	icon_state = "beam_blue"

/obj/effect/projectile/laser_blue/impact
	icon_state = "impact_blue"

//----------------------------
// Heavy laser beam
//----------------------------
/obj/effect/projectile/laser_heavy/muzzle
	icon_state = "muzzle_beam_heavy"

/obj/effect/projectile/laser_heavy/tracer
	icon_state = "beam_heavy"

/obj/effect/projectile/laser_heavy/impact
	icon_state = "impact_beam_heavy"

//----------------------------
// Xray laser beam
//----------------------------
/obj/effect/projectile/xray/muzzle
	icon_state = "muzzle_xray"

/obj/effect/projectile/xray/tracer
	icon_state = "xray"

/obj/effect/projectile/xray/impact
	icon_state = "impact_xray"

//----------------------------
// Pulse beam
//----------------------------
/obj/effect/projectile/laser_pulse/muzzle
	icon_state = "muzzle_u_laser"

/obj/effect/projectile/laser_pulse/tracer
	icon_state = "u_laser"

/obj/effect/projectile/laser_pulse/impact
	icon_state = "impact_u_laser"

//----------------------------
// Pulse muzzle effect
//----------------------------
/obj/effect/projectile/pulse/muzzle
	icon_state = "muzzle_pulse"

//----------------------------
// Emitter beam
//----------------------------
/obj/effect/projectile/emitter/muzzle
	icon_state = "muzzle_emitter"

/obj/effect/projectile/emitter/tracer
	icon_state = "emitter"

/obj/effect/projectile/emitter/impact
	icon_state = "impact_emitter"

//----------------------------
// Bullet muzzle effect
//----------------------------
/obj/effect/projectile/bullet/muzzle
	icon_state = "muzzle_bullet"