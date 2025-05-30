
//malfunctioning combat drones
/mob/living/simple/hostile/retaliate/malf_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon_state = "drone3"
	icon_living = "drone3"
	icon_dead = "drone_dead"
	ranged = 1
	rapid = 1
	speak_chance = 5
	turns_per_move = 3
	response_help = "pokes the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speak = list("ALERT.", "Hostile-ile-ile entities dee-twhoooo-wected.", "Threat parameterszzzz- szzet.", "Bring sub-sub-sub-systems uuuup to combat alert alpha-a-a.")
	emote_see = list("beeps menacingly", "whirrs threateningly", "scans its immediate vicinity")
	a_intent = "harm"
	stop_automated_movement_when_pulled = FALSE
	health = 300
	maxHealth = 300
	speed = 8
	projectiletype = /obj/item/projectile/energy/beam/laser/drone
	projectilesound = 'sound/weapons/gun/laser3.ogg'
	destroy_surroundings = 0

	// Drones aren't affected by atmos.
	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0

	faction = "malf_drone"

	var/datum/effect/system/ion_trail_follow/ion_trail

	//the drone randomly switches between these states because it's malfunctioning
	var/hostile_drone = 0
	//0 - retaliate, only attack enemies that attack it
	//1 - hostile, attack everything that comes near

	var/turf/patrol_target
	var/explode_chance = 1
	var/disabled = 0
	var/exploding = 0

	var/has_loot = 1

/mob/living/simple/hostile/retaliate/malf_drone/New()
	..()
	if(prob(5))
		projectiletype = /obj/item/projectile/energy/beam/pulse/drone
		projectilesound = 'sound/weapons/gun/pulse2.ogg'
	ion_trail = new
	ion_trail.set_up(src)
	ion_trail.start()

/mob/living/simple/hostile/retaliate/malf_drone/Process_Spacemove(check_drift = 0)
	return 1

/*
// This did literally exactly the same thing as the new parent proc does.
/mob/living/simple/hostile/retaliate/malf_drone/list_targets()
	if(hostile_drone)
		return view(src, 10)
	else
		return ..()
*/

//self repair systems have a chance to bring the drone back to life
/mob/living/simple/hostile/retaliate/malf_drone/Life()
	//emps and lots of damage can temporarily shut us down
	if(disabled > 0)
		stat = UNCONSCIOUS
		icon_state = "drone_dead"
		disabled--
		wander = FALSE
		speak_chance = 0
		if(disabled <= 0)
			stat = CONSCIOUS
			icon_state = "drone0"
			wander = TRUE
			speak_chance = 5

	//repair a bit of damage
	if(prob(1))
		src.visible_message(SPAN_WARNING("\icon[src] [src] shudders and shakes as some of it's damaged systems come back online."))
		make_sparks(3, TRUE, src)
		health += rand(25,100)

	//spark for no reason
	if(prob(5))
		make_sparks(3, TRUE, src)

	//sometimes our targetting sensors malfunction, and we attack anyone nearby
	if(prob(disabled ? 0 : 1))
		if(hostile_drone)
			src.visible_message(SPAN_INFO("\icon[src] [src] retracts several targetting vanes, and dulls it's running lights."))
			hostile_drone = 0
		else
			src.visible_message(SPAN_WARNING("\icon[src] [src] suddenly lights up, and additional targetting vanes slide into place."))
			hostile_drone = 1

	if(health / maxHealth > 0.9)
		icon_state = "drone3"
		explode_chance = 0
	else if(health / maxHealth > 0.7)
		icon_state = "drone2"
		explode_chance = 0
	else if(health / maxHealth > 0.5)
		icon_state = "drone1"
		explode_chance = 0.5
	else if(health / maxHealth > 0.3)
		icon_state = "drone0"
		explode_chance = 5
	else if(health > 0)
		//if health gets too low, shut down
		icon_state = "drone_dead"
		exploding = 0
		if(!disabled)
			if(prob(50))
				src.visible_message(SPAN_INFO("\icon[src] [src] suddenly shuts down!"))
			else
				src.visible_message(SPAN_INFO("\icon[src] [src] suddenly lies still and quiet."))
			disabled = rand(150, 600)
			walk(src, 0)

	if(exploding && prob(20))
		if(prob(50))
			src.visible_message(SPAN_WARNING("\icon[src] [src] begins to spark and shake violenty!"))
		else
			src.visible_message(SPAN_WARNING("\icon[src] [src] sparks and shakes like it's about to explode!"))
		make_sparks(3, TRUE, src)

	if(!exploding && !disabled && prob(explode_chance))
		exploding = 1
		stat = UNCONSCIOUS
		wander = TRUE
		walk(src,0)
		spawn(rand(50, 150))
			if(!disabled && exploding)
				explosion(GET_TURF(src), 0, 1, 4, 7)
				//proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1)
	..()

//ion rifle!
/mob/living/simple/hostile/retaliate/malf_drone/emp_act(severity)
	health -= rand(3,15) * (severity + 1)
	disabled = rand(150, 600)
	hostile_drone = 0
	walk(src,0)

/mob/living/simple/hostile/retaliate/malf_drone/death()
	..(null, "suddenly breaks apart.")
	qdel(src)

/mob/living/simple/hostile/retaliate/malf_drone/Destroy()
	//some random debris left behind
	if(has_loot)
		make_sparks(3, TRUE, src)
		var/obj/O

		//shards
		O = new /obj/item/shard(loc)
		step_to(O, GET_TURF(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/shard(loc)
			step_to(O, GET_TURF(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/shard(loc)
			step_to(O, GET_TURF(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/shard(loc)
			step_to(O, GET_TURF(pick(view(7, src))))

		//rods
		O = new /obj/item/stack/rods(loc)
		step_to(O, GET_TURF(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/stack/rods(loc)
			step_to(O, GET_TURF(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/stack/rods(loc)
			step_to(O, GET_TURF(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/stack/rods(loc)
			step_to(O, GET_TURF(pick(view(7, src))))

		//plasteel
		O = new /obj/item/stack/sheet/plasteel(loc)
		step_to(O, GET_TURF(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/stack/sheet/plasteel(loc)
			step_to(O, GET_TURF(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/stack/sheet/plasteel(loc)
			step_to(O, GET_TURF(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/stack/sheet/plasteel(loc)
			step_to(O, GET_TURF(pick(view(7, src))))

		//also drop dummy circuit boards deconstructable for research (loot)
		var/obj/item/circuitboard/C = new /obj/item/circuitboard(loc)

		//spawn 1-4 boards of a random type
		var/spawnees = 0
		var/num_boards = rand(1,4)
		var/list/options = list(1,2,4,8,16,32,64,128,256, 512)
		for(var/i = 0, i < num_boards, i++)
			var/chosen = pick(options)
			options.Remove(options.Find(chosen))
			spawnees |= chosen

		if(spawnees & 1)
			C.name = "circuit board (drone CPU motherboard)"
			C.origin_tech = alist(/decl/tech/programming = rand(3, 6))

		if(spawnees & 2)
			C.name = "circuit board (drone neural interface)"
			C.origin_tech = alist(/decl/tech/biotech = rand(3, 6))

		if(spawnees & 4)
			C.name = "circuit board (drone suspension processor)"
			C.origin_tech = alist(/decl/tech/magnets = rand(3, 6))

		if(spawnees & 8)
			C.name = "circuit board (drone shielding controller)"
			C.origin_tech = alist(/decl/tech/bluespace = rand(3, 6))

		if(spawnees & 16)
			C.name = "circuit board (drone power capacitor)"
			C.origin_tech = alist(/decl/tech/power_storage = rand(3, 6))

		if(spawnees & 32)
			C.name = "circuit board (drone hull reinforcer)"
			C.origin_tech = alist(/decl/tech/materials = rand(3, 6))

		if(spawnees & 64)
			C.name = "circuit board (drone auto-repair system)"
			C.origin_tech = alist(/decl/tech/engineering = rand(3, 6))

		if(spawnees & 128)
			C.name = "circuit board (drone plasma overcharge counter)"
			C.origin_tech = alist(/decl/tech/plasma = rand(3, 6))

		if(spawnees & 256)
			C.name = "circuit board (drone targeting circuit)"
			C.origin_tech = alist(/decl/tech/combat = rand(3, 6))

		if(spawnees & 512)
			C.name = "circuit board (corrupted drone morality core)"
			C.origin_tech = alist(/decl/tech/syndicate = rand(3, 6))

	return ..()

/obj/item/projectile/energy/beam/laser/drone
	damage = 15

/obj/item/projectile/energy/beam/pulse/drone
	damage = 10
