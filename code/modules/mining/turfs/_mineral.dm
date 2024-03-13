/*
 * Mineral Deposits
 */
GLOBAL_GLOBL_LIST_NEW(artifact_spawning_turfs)

/turf/simulated/mineral //wall piece
	name = "rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"

	opacity = TRUE
	density = TRUE
	turf_flags = TURF_FLAG_BLOCKS_AIR

	initial_gases = null
	temperature = T0C

	explosion_resistance = 2

	var/decl/mineral/mineral = null
	var/mined_ore = 0
	var/last_act = 0

	var/datum/geosample/geologic_data = null
	var/excavation_level = 0
	var/list/finds = null
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/last_find
	var/datum/artifact_find/artifact_find = null

/turf/simulated/mineral/initialise()
	. = ..()
	update_and_spread_mineral()

	// I've tidied this up but I still hate it.
	var/turf/T = get_step(src, NORTH)
	if(isnotnull(T))
		if(istype(T, /turf/simulated/floor) || isspace(T) || istype(T, /turf/simulated/shuttle/floor))
			T.overlays.Add(image('icons/turf/walls.dmi', "rock_side_s"))
		T = null
	T = get_step(src, SOUTH)
	if(isnotnull(T))
		if(istype(T, /turf/simulated/floor) || isspace(T) || istype(T, /turf/simulated/shuttle/floor))
			T.overlays.Add(image('icons/turf/walls.dmi', "rock_side_n", layer = 6))
		T = null
	T = get_step(src, EAST)
	if(isnotnull(T))
		if(istype(T, /turf/simulated/floor) || isspace(T) || istype(T, /turf/simulated/shuttle/floor))
			T.overlays.Add(image('icons/turf/walls.dmi', "rock_side_w", layer = 6))
		T = null
	T = get_step(src, WEST)
	if(isnotnull(T))
		if(istype(T, /turf/simulated/floor) || isspace(T) || istype(T, /turf/simulated/shuttle/floor))
			T.overlays.Add(image('icons/turf/walls.dmi', "rock_side_e", layer = 6))

/turf/simulated/mineral/ex_act(severity)
	switch(severity)
		if(2)
			if(prob(70))
				mined_ore = 1 //some of the stuff gets blown up
				GetDrilled()
		if(1)
			mined_ore = 2 //some of the stuff gets blown up
			GetDrilled()

/turf/simulated/mineral/Bumped(AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(istype(H.l_hand, /obj/item/pickaxe) && !H.hand)
			attackby(H.l_hand, H)
		else if(istype(H.r_hand, /obj/item/pickaxe) && H.hand)
			attackby(H.r_hand, H)

	else if(isrobot(AM))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active, /obj/item/pickaxe))
			attackby(R.module_active, R)

	else if(ismecha(AM))
		var/obj/mecha/M = AM
		if(istype(M.selected, /obj/item/mecha_parts/mecha_equipment/tool/drill))
			M.selected.action(src)

/turf/simulated/mineral/attack_tool(obj/item/tool, mob/user)
	if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey)) // If there's ever something pre-attack_tool(), then this should be moved there.
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return TRUE

	if(istype(tool, /obj/item/core_sampler))
		geologic_data.UpdateNearbyArtifactInfo(src)
		var/obj/item/core_sampler/sampler = tool
		sampler.sample_item(src, user)
		return TRUE

	if(istype(tool, /obj/item/depth_scanner))
		var/obj/item/depth_scanner/scanner = tool
		scanner.scan_atom(user, src)
		return TRUE

	if(istype(tool, /obj/item/measuring_tape))
		var/obj/item/measuring_tape/tape = tool
		user.visible_message(
			SPAN_INFO("[user] extends \the [tape] towards \the [src]."),
			SPAN_INFO("You extend \the [tape] towards \the [src].")
		)
		if(do_after(user, 2.5 SECONDS))
			user.visible_message(
				SPAN_INFO("\icon[tape] [user] measures the excavation depth of \the [src]."),
				SPAN_INFO("\icon[tape] [src] has been excavated to a depth of [2 * excavation_level]cm.")
			)
		return TRUE

	return ..()

// Not even going to touch this pile of spaghetti.
/turf/simulated/mineral/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pickaxe))
		var/turf/T = user.loc
		if(!(isturf(T)))
			return

		var/obj/item/pickaxe/P = W
		if(last_act + P.digspeed > world.time)//prevents message spam
			return
		last_act = world.time

		playsound(user, P.drill_sound, 20, 1)

		//handle any archaeological finds we might uncover
		var/fail_message
		if(length(finds))
			var/datum/find/F = finds[1]
			if(excavation_level + P.excavation_amount > F.excavation_required)
				//Chance to destroy / extract any finds here
				fail_message = ", <b>[pick("there is a crunching noise", "[W] collides with some different rock", "part of the rock face crumbles away", "something breaks under [W]")]</b>"

		to_chat(user, SPAN_WARNING("You start [P.drill_verb][fail_message ? fail_message : ""]."))

		if(fail_message && prob(90))
			if(prob(25))
				excavate_find(5, finds[1])
			else if(prob(50))
				finds.Remove(finds[1])
				if(prob(50))
					artifact_debris()

		if(do_after(user, P.digspeed))
			to_chat(user, SPAN_INFO("You finish [P.drill_verb] the rock."))

			if(length(finds))
				var/datum/find/F = finds[1]
				if(round(excavation_level + P.excavation_amount) == F.excavation_required)
					//Chance to extract any items here perfectly, otherwise just pull them out along with the rock surrounding them
					if(excavation_level + P.excavation_amount > F.excavation_required)
						//if you can get slightly over, perfect extraction
						excavate_find(100, F)
					else
						excavate_find(80, F)

				else if(excavation_level + P.excavation_amount > F.excavation_required - F.clearance_range)
					//just pull the surrounding rock out
					excavate_find(0, F)

			if(excavation_level + P.excavation_amount >= 100)
				//if players have been excavating this turf, leave some rocky debris behind
				var/obj/structure/boulder/B
				if(artifact_find)
					if(excavation_level > 0 || prob(15))
						//boulder with an artifact inside
						B = new(src)
						if(artifact_find)
							B.artifact_find = artifact_find
					else
						artifact_debris(1)
				else if(prob(15))
					//empty boulder
					B = new(src)

				if(B)
					GetDrilled(0)
				else
					GetDrilled(1)
				return

			excavation_level += P.excavation_amount

			//archaeo overlays
			if(!archaeo_overlay && length(finds))
				var/datum/find/F = finds[1]
				if(F.excavation_required <= excavation_level + F.view_range)
					archaeo_overlay = "overlay_archaeo[rand(1,3)]"
					overlays += archaeo_overlay

			//there's got to be a better way to do this
			var/update_excav_overlay = 0
			if(excavation_level >= 75)
				if(excavation_level - P.excavation_amount < 75)
					update_excav_overlay = 1
			else if(excavation_level >= 50)
				if(excavation_level - P.excavation_amount < 50)
					update_excav_overlay = 1
			else if(excavation_level >= 25)
				if(excavation_level - P.excavation_amount < 25)
					update_excav_overlay = 1

			//update overlays displaying excavation level
			if(!(excav_overlay && excavation_level > 0) || update_excav_overlay)
				var/excav_quadrant = round(excavation_level / 25) + 1
				excav_overlay = "overlay_excv[excav_quadrant]_[rand(1,3)]"
				overlays += excav_overlay

			/* Nope.
			//extract pesky minerals while we're excavating
			while(length(excavation_minerals) && excavation_level > excavation_minerals[length(excavation_minerals)])
				DropMineral()
				pop(excavation_minerals)
				mineralAmt-- */

			//drop some rocks
			next_rock += P.excavation_amount * 10
			while(next_rock > 100)
				next_rock -= 100
				var/obj/item/ore/O = new /obj/item/ore(src)
				geologic_data.UpdateNearbyArtifactInfo(src)
				O.geologic_data = geologic_data
	else
		return attack_hand(user)

// Updates the turf's mineral and, if applicable, attempts to spread it.
/turf/simulated/mineral/proc/update_and_spread_mineral()
	if(ispath(mineral, /decl/mineral))
		mineral = GET_DECL_INSTANCE(mineral)
	if(isnull(mineral))
		return

	var/lower_name = lowertext(mineral.name)
	name = "\improper [lower_name] deposit"
	icon_state = "rock_[lower_name]"

	if(!mineral.ore_spread || !mineral.ore_spread_chance)
		return

	for(var/try_dir in GLOBL.cardinal)
		if(prob(mineral.ore_spread_chance))
			var/turf/simulated/mineral/random/target_turf = get_step(src, try_dir)
			if(istype(target_turf) && isnull(target_turf.mineral))
				target_turf.mineral = mineral
				target_turf.update_and_spread_mineral()

/turf/simulated/mineral/proc/DropMineral()
	if(isnull(mineral))
		return
	if(!ispath(mineral.ore_path, /obj/item/ore))
		return

	var/obj/item/ore/O = new mineral.ore_path(src)
	if(istype(O))
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data
	return O

/turf/simulated/mineral/proc/GetDrilled(artifact_fail = 0)
	//var/destroyed = 0 //used for breaking strange rocks
	if(mineral && mineral.ore_result_amount)
		//if the turf has already been excavated, some of it's ore has been removed
		for(var/i = 1 to mineral.ore_result_amount - mined_ore)
			DropMineral()

	//destroyed artifacts have weird, unpleasant effects
	//make sure to destroy them before changing the turf though
	if(artifact_find && artifact_fail)
		var/pain = 0
		if(prob(50))
			pain = 1
		for(var/mob/living/M in range(src, 200))
			to_chat(M, SPAN_DANGER("[pick("A high pitched [pick("keening", "wailing", "whistle")]", "A rumbling noise like [pick("thunder", "heavy machinery")]")] somehow penetrates your mind before fading away!"))
			if(pain)
				flick("pain", M.pain)
				if(prob(50))
					M.adjustBruteLoss(5)
			else
				flick("flash", M.flash)
				if(prob(50))
					M.Stun(5)
			M.apply_effect(25, IRRADIATE)

	var/turf/simulated/floor/plating/airless/asteroid/N = ChangeTurf(/turf/simulated/floor/plating/airless/asteroid)
	N.full_update_mineral_overlays()

	if(rand(1, 500) == 1)
		visible_message(SPAN_NOTICE("An old dusty crate was buried within!"))
		new /obj/structure/closet/crate/secure/loot(src)

/turf/simulated/mineral/proc/excavate_find(prob_clean = 0, datum/find/F)
	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	var/obj/item/X
	if(prob_clean)
		X = new /obj/item/archaeological_find(src, new_item_type = F.find_type)
	else
		X = new /obj/item/ore/strangerock(src, inside_item_type = F.find_type)
		geologic_data.UpdateNearbyArtifactInfo(src)
		X:geologic_data = geologic_data

	//some find types delete the /obj/item/archaeological_find and replace it with something else, this handles when that happens
	//yuck
	var/display_name = "something"
	if(isnull(X))
		X = last_find
	if(isnotnull(X))
		display_name = X.name

	//many finds are ancient and thus very delicate - luckily there is a specialised energy suspension field which protects them when they're being extracted
	if(prob(F.prob_delicate))
		var/obj/effect/suspension_field/S = locate() in src
		if(isnull(S) || S.field_type != get_responsive_reagent(F.find_type))
			if(isnotnull(X))
				visible_message(SPAN_DANGER("[pick("[display_name] crumbles away into dust", "[display_name] breaks apart")]."))
				qdel(X)

	finds.Remove(F)

/turf/simulated/mineral/proc/artifact_debris(severity = 0)
	//cael's patented random limited drop componentized loot system!
	//sky's patented not-fucking-retarded overhaul!

	//Give a random amount of loot from 1 to 3 or 5, varying on severity.
	for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
		switch(rand(1, 7))
			if(1)
				var/obj/item/stack/rods/R = new /obj/item/stack/rods(src)
				R.amount = rand(5, 25)

			if(2)
				var/obj/item/stack/tile/R = new /obj/item/stack/tile(src)
				R.amount = rand(1, 5)

			if(3)
				var/obj/item/stack/sheet/metal/R = new /obj/item/stack/sheet/metal(src)
				R.amount = rand(5, 25)

			if(4)
				var/obj/item/stack/sheet/plasteel/R = new /obj/item/stack/sheet/plasteel(src)
				R.amount = rand(5, 25)

			if(5)
				var/quantity = rand(1, 3)
				for(var/i = 0, i < quantity, i++)
					new /obj/item/shard(src)

			if(6)
				var/quantity = rand(1, 3)
				for(var/i = 0, i < quantity, i++)
					new /obj/item/shard/plasma(src)

			if(7)
				var/obj/item/stack/sheet/mineral/uranium/R = new /obj/item/stack/sheet/mineral/uranium(src)
				R.amount = rand(5, 25)