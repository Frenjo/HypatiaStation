/turf/simulated
	name = "station"
	initial_gases = list(/decl/xgm_gas/oxygen = MOLES_O2STANDARD, /decl/xgm_gas/nitrogen = MOLES_N2STANDARD)

	var/wet = 0
	var/image/wet_overlay = null

	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/dirt = 0

/turf/simulated/New()
	. = ..()
	GLOBL.simulated_turf_list.Add(src)

/turf/simulated/initialise()
	. = ..()
	for(var/atom/movable/mover in src)
		spawn(0)
			Entered(mover)

/turf/simulated/Destroy()
	GLOBL.simulated_turf_list.Remove(src)
	return ..()

/turf/simulated/Entered(atom/A, atom/OL)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		FEEDBACK_MOVEMENT_ADMIN_DISABLED(usr) // This is to identify lag problems.
		return

	if(iscarbon(A))
		var/mob/living/carbon/M = A
		if(M.lying)
			return
		dirt++
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, src)
		if(dirt >= 50)
			if(isnull(dirtoverlay))
				dirtoverlay = new /obj/effect/decal/cleanable/dirt(src)
				dirtoverlay.alpha = 15
			else if(dirt > 50)
				dirtoverlay.alpha = min(dirtoverlay.alpha + 5, 255)

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.shoes, /obj/item/clothing/shoes/clown_shoes))
				// Disabled footstep spacing, oh god what have I done? -Frenjo
				//var/obj/item/clothing/shoes/clown_shoes/O = H.shoes
				if(IS_RUNNING(H))
					//if(O.footstep >= 2)
						//O.footstep = 0
						//playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
					playsound(src, "clownstep", 20, 1)
					//else
						//O.footstep++
				else
					playsound(src, "clownstep", 20, 1)

			// Tracking blood
			var/list/bloodDNA = null
			var/bloodcolor = ""
			if(isnotnull(H.shoes))
				var/obj/item/clothing/shoes/S = H.shoes
				if(S.track_blood && S.blood_DNA)
					bloodDNA = S.blood_DNA
					bloodcolor = S.blood_color
					S.track_blood--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					bloodcolor = H.feet_blood_color
					H.track_blood--

			if(bloodDNA)
				AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints, bloodDNA, H.dir, 0, bloodcolor) // Coming
				var/turf/simulated/from = get_step(H,reverse_direction(H.dir))
				if(istype(from) && from)
					from.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints, bloodDNA, 0, H.dir, bloodcolor) // Going

				bloodDNA = null

		switch(wet)
			if(1)
				if(ishuman(M)) // Added check since monkeys don't have shoes
					var/mob/living/carbon/human/human = M
					if(IS_RUNNING(human) && !(istype(human.shoes, /obj/item/clothing/shoes) && HAS_ITEM_FLAGS(human.shoes, ITEM_FLAG_NO_SLIP)))
						human.stop_pulling()
						step(human, human.dir)
						to_chat(human, SPAN_INFO("You slipped on the wet floor!"))
						playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
						human.Stun(5)
						human.Weaken(3)
					else
						human.inertia_dir = 0
						return
				else if(!isslime(M))
					if(IS_RUNNING(M))
						M.stop_pulling()
						step(M, M.dir)
						to_chat(M, SPAN_INFO("You slipped on the wet floor!"))
						playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
						M.Stun(5)
						M.Weaken(3)
					else
						M.inertia_dir = 0
						return

			if(2) //lube				//can cause infinite loops - needs work
				if(!isslime(M))
					M.stop_pulling()
					step(M, M.dir)
					spawn(1)
						step(M, M.dir)
					spawn(2)
						step(M, M.dir)
					spawn(3)
						step(M, M.dir)
					spawn(4)
						step(M, M.dir)
					M.take_organ_damage(2) // Was 5 -- TLE
					to_chat(M, SPAN_INFO("You slipped on the floor!"))
					playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
					M.Weaken(10)

			if(3) // Ice
				if(ishuman(M)) // Added check since monkeys don't have shoes
					var/mob/living/carbon/human/human = M
					if(IS_RUNNING(human) && !(istype(human.shoes, /obj/item/clothing/shoes) && HAS_ITEM_FLAGS(human.shoes, ITEM_FLAG_NO_SLIP)) && prob(30))
						human.stop_pulling()
						step(human, human.dir)
						to_chat(human, SPAN_INFO("You slipped on the icy floor!"))
						playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
						human.Stun(4)
						human.Weaken(3)
					else
						M.inertia_dir = 0
						return
				else if(!isslime(M))
					if(IS_RUNNING(M) && prob(30))
						M.stop_pulling()
						step(M, M.dir)
						to_chat(M, SPAN_INFO("You slipped on the icy floor!"))
						playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
						M.Stun(4)
						M.Weaken(3)
					else
						M.inertia_dir = 0
						return

	. = ..()

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M)
	if(!..())
		return 0

	for(var/obj/effect/decal/cleanable/blood/B in contents)
		if(!B.blood_DNA[M.dna.unique_enzymes])
			B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
			B.virus2 = virus_copylist(M.virus2)
		return 1 //we bloodied the floor

	//if there isn't a blood decal already, make one.
	var/obj/effect/decal/cleanable/blood/newblood = new /obj/effect/decal/cleanable/blood(src)

	//Species-specific blood.
	if(M.species)
		newblood.basecolor = M.species.blood_color
	else
		newblood.basecolor = "#A10808"

	newblood.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	newblood.virus2 = virus_copylist(M.virus2)
	newblood.update_icon()

	return 1 //we bloodied the floor

/turf/simulated/proc/AddTracks(typepath, bloodDNA, comingdir, goingdir, bloodcolor = "#A10808")
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(isnull(tracks))
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA, comingdir, goingdir, bloodcolor)

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M)
	if(ismonkey(M))
		var/obj/effect/decal/cleanable/blood/this = new /obj/effect/decal/cleanable/blood(src)
		this.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
		this.basecolor = "#A10808"
		this.update_icon()

	else if(ishuman(M))
		var/obj/effect/decal/cleanable/blood/this = new /obj/effect/decal/cleanable/blood(src)
		var/mob/living/carbon/human/H = M

		//Species-specific blood.
		if(H.species)
			this.basecolor = H.species.blood_color
		else
			this.basecolor = "#A10808"
		this.update_icon()

		this.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type

	else if(isalien(M))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"

	else if(isrobot(M))
		new /obj/effect/decal/cleanable/blood/oil(src)