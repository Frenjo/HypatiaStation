var/list/beam_master = list()
//Use: Caches beam state images and holds turfs that had these images overlaid.
//Structure:
//beam_master
//	icon_states/dirs of beams
//		image for that beam
//	references for fired beams
//		icon_states/dirs for each placed beam image
//			turfs that have that icon_state/dir

/obj/item/projectile/energy/beam
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 40
	damage_type = BURN
	flag = "laser"
	eyeblur = 4
	var/frequency = 1
	invisibility = INVISIBILITY_MAXIMUM

/obj/item/projectile/energy/beam/process()
	var/reference = "\ref[src]" //So we do not have to recalculate it a ton
	var/first = 1 //So we don't make the overlay in the same tile as the firer
	spawn while(src) //Move until we hit something
		if(!current || loc == current) //If we pass our target
			current = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z)
		if(x == 1 || x == world.maxx || y == 1 || y == world.maxy)
			src = null //Delete if it passes the world edge
			return
		step_towards(src, current) //Move~

		if(kill_count < 1)
			//src = null
			qdel(src)
		kill_count--

		if(!bumped && !isturf(original))
			if(loc == get_turf(original))
				if(!(original in permutated))
					Bump(original)

		if(!first) //Add the overlay as we pass over tiles
			var/target_dir = get_dir(src, current) //So we don't call this too much

			//If the icon has not been added yet
			if(!("[icon_state][target_dir]" in beam_master))
				var/image/I = image(icon, icon_state, 10, target_dir) //Generate it.
				beam_master["[icon_state][target_dir]"] = I //And cache it!

			//Finally add the overlay
			src.loc.overlays += beam_master["[icon_state][target_dir]"]

			//Add the turf to a list in the beam master so they can be cleaned up easily.
			if(reference in beam_master)
				var/list/turf_master = beam_master[reference]
				if("[icon_state][target_dir]" in turf_master)
					var/list/turfs = turf_master["[icon_state][target_dir]"]
					turfs += loc
				else
					turf_master["[icon_state][target_dir]"] = list(loc)
			else
				var/list/turfs = list()
				turfs["[icon_state][target_dir]"] = list(loc)
				beam_master[reference] = turfs
		else
			first = 0
	cleanup(reference)
	return

/obj/item/projectile/energy/beam/Destroy()
	cleanup("\ref[src]")
	return ..()

/obj/item/projectile/energy/beam/proc/cleanup(reference) //Waits .3 seconds then removes the overlay.
	src = null //we're getting deleted! this will keep the code running
	spawn(3)
		var/list/turf_master = beam_master[reference]
		for(var/laser_state in turf_master)
			var/list/turfs = turf_master[laser_state]
			for(var/turf/T in turfs)
				T.overlays -= beam_master[laser_state]
	return

/obj/item/projectile/energy/beam/laser
	name = "laser beam"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 40
	damage_type = BURN
	flag = "laser"
	eyeblur = 4

/obj/item/projectile/energy/beam/laser/practice
	name = "laser"
	damage = 0
	eyeblur = 2

/obj/item/projectile/energy/beam/laser/heavy
	name = "heavy laser beam"
	icon_state = "heavylaser"
	damage = 40

/obj/item/projectile/energy/beam/laser/death
	name = "death laser beam"
	icon_state = "heavylaser"
	damage = 60

/obj/item/projectile/energy/beam/laser/xray
	name = "xray beam"
	icon_state = "xray"
	damage = 30

/obj/item/projectile/energy/beam/disabler
	name = "disabler beam"
	icon_state = "bluespark"
	nodamage = 1
	weaken = 5
	agony = 20
	damage_type = HALLOSS

/obj/item/projectile/energy/beam/pulse
	name = "pulse beam"
	icon_state = "u_laser"
	damage = 50

/obj/item/projectile/energy/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	damage = 30

/obj/item/projectile/energy/beam/laser/tag
	name = "lasertag beam"
	damage = 0
	damage_type = BURN
	flag = "laser"

/obj/item/projectile/energy/beam/laser/tag/blue
	icon_state = "bluelaser"

/obj/item/projectile/energy/beam/laser/tag/blue/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.Weaken(5)
	return 1

/obj/item/projectile/energy/beam/laser/tag/red
	icon_state = "laser"

/obj/item/projectile/energy/beam/laser/tag/red/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.Weaken(5)
	return 1

/obj/item/projectile/energy/beam/laser/tag/omni	//A laser tag bolt that stuns EVERYONE
	icon_state = "omnilaser"

/obj/item/projectile/energy/beam/laser/tag/omni/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag) || istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.Weaken(5)
	return 1

/obj/item/projectile/energy/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	damage = 60
	stun = 5
	weaken = 5
	stutter = 5