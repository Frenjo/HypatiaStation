/obj/item/mecha_equipment/weapon
	name = "mecha weapon"
	range = RANGED
	origin_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 3)

	mecha_flags = MECHA_FLAG_COMBAT

	destruction_sound = 'sound/mecha/voice/weapdestr.ogg'

	var/projectile //Type of projectile fired.
	var/projectiles = 1 //Amount of projectiles loaded.
	var/projectiles_per_shot = 1 //Amount of projectiles fired per single shot.
	var/deviation = 0 //Inaccuracy of shots.
	var/fire_cooldown = 0 //Duration of sleep between firing projectiles in single shot.
	var/fire_sound //Sound played while firing.
	var/fire_volume = 50 //How loud it is played.
	var/auto_rearm = 0 //Does the weapon reload itself after each shot?

/obj/item/mecha_equipment/weapon/action_checks(atom/target)
	if(projectiles <= 0)
		return FALSE
	return ..()

/obj/item/mecha_equipment/weapon/action(atom/target)
	if(!..())
		return FALSE
	var/turf/curloc = chassis.loc
	var/turf/targloc = GET_TURF(target)
	if(isnull(curloc) || isnull(targloc))
		return FALSE
	chassis.use_power(energy_drain)
	chassis.visible_message(SPAN_WARNING("[chassis] fires [src]!"))
	occupant_message(SPAN_WARNING("You fire [src]!"))
	log_message("Fired from [src], targeting [target].")
	for(var/i = 1 to min(projectiles, projectiles_per_shot))
		var/turf/aimloc = targloc
		if(deviation)
			aimloc = locate(targloc.x + GaussRandRound(deviation, 1), targloc.y + GaussRandRound(deviation, 1), targloc.z)
		if(!aimloc || aimloc == curloc)
			break
		playsound(chassis, fire_sound, fire_volume, 1)
		projectiles--
		var/P = new projectile(curloc)
		Fire(P, target, aimloc)
		if(fire_cooldown)
			sleep(fire_cooldown)
	if(auto_rearm)
		projectiles = projectiles_per_shot
	set_ready_state(0)
	do_after_cooldown()
	return TRUE

/obj/item/mecha_equipment/weapon/proc/Fire(atom/A, atom/target, turf/aimloc)
	var/obj/item/projectile/P = A
	P.shot_from = src
	P.original = target
	P.starting = P.loc
	P.current = P.loc
	P.firer = chassis.occupant
	P.yo = aimloc.y - P.loc.y
	P.xo = aimloc.x - P.loc.x
	P.process()