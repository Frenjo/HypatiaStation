/*
 * Mineral Deposits
 */
GLOBAL_GLOBL_LIST_TYPED_NEW(all_rock_turfs, /turf/closed/rock)
GLOBAL_GLOBL_LIST_TYPED_NEW(artifact_spawning_turfs, /turf/closed/rock)

/turf/closed/rock //wall piece
	name = "rock"
	icon = 'icons/turf/walls/rocks_ores.dmi'
	icon_state = "rock_no_chance"

	temperature = T0C

	explosion_resistance = 2

	var/decl/ore/ore = null
	var/mined_ore = 0
	var/last_act = 0

	var/datum/geosample/geologic_data = null
	var/excavation_level = 0
	var/list/datum/find/finds = null
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/last_find
	var/datum/artifact_find/artifact_find = null

/turf/closed/rock/initialise()
	. = ..()
	icon_state = "rock"
	GLOBL.all_rock_turfs.Add(src)
	update_and_spread_mineral()

	// I've tidied this up but I still hate it.
	var/turf/T = get_step(src, NORTH)
	var/is_space = FALSE
	if(isnotnull(T))
		is_space = isspace(T)
		if(isfloorturf(T) || is_space)
			var/image/overlay = image(icon, "rock_side_s")
			if(is_space)
				overlay.plane = SPACE_PLANE_ABOVE_PARALLAX
			T.add_overlay(overlay)
		T = null
		is_space = FALSE
	T = get_step(src, SOUTH)
	if(isnotnull(T))
		is_space = isspace(T)
		if(isfloorturf(T) || is_space)
			var/image/overlay = image(icon, "rock_side_n", layer = 6)
			if(is_space)
				overlay.plane = SPACE_PLANE_ABOVE_PARALLAX
			T.add_overlay(overlay)
		T = null
		is_space = FALSE
	T = get_step(src, EAST)
	if(isnotnull(T))
		is_space = isspace(T)
		if(isfloorturf(T) || is_space)
			var/image/overlay = image(icon, "rock_side_w", layer = 6)
			if(is_space)
				overlay.plane = SPACE_PLANE_ABOVE_PARALLAX
			T.add_overlay(overlay)
		T = null
		is_space = FALSE
	T = get_step(src, WEST)
	if(isnotnull(T))
		is_space = isspace(T)
		if(isfloorturf(T) || is_space)
			var/image/overlay = image(icon, "rock_side_e", layer = 6)
			if(is_space)
				overlay.plane = SPACE_PLANE_ABOVE_PARALLAX
			T.add_overlay(overlay)

/turf/closed/rock/Destroy()
	GLOBL.all_rock_turfs.Remove(src)
	QDEL_NULL(geologic_data)
	LAZYCLEARLIST(finds)
	last_find = null
	QDEL_NULL(artifact_find)
	return ..()

/turf/closed/rock/ex_act(severity)
	switch(severity)
		if(2)
			if(prob(70))
				mined_ore = 1 //some of the stuff gets blown up
				get_drilled()
		if(1)
			mined_ore = 2 //some of the stuff gets blown up
			get_drilled()

/turf/closed/rock/Bumped(AM)
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
		if(istype(M.selected, /obj/item/mecha_equipment/tool/drill))
			M.selected.action(src)

// Updates the turf's ore and, if applicable, attempts to spread it.
/turf/closed/rock/proc/update_and_spread_mineral()
	if(ispath(ore, /decl/ore))
		ore = GET_DECL_INSTANCE(ore)
	if(isnull(ore))
		return

	var/lower_name = lowertext(ore.name)
	name = "\improper [lower_name] deposit"
	icon_state = "rock_[lower_name]"

	if(!ore.does_spread || !ore.spread_chance)
		return

	for(var/try_dir in GLOBL.cardinal)
		if(prob(ore.spread_chance))
			var/turf/closed/rock/random_ore/target_turf = get_step(src, try_dir)
			if(istype(target_turf) && isnull(target_turf.ore))
				target_turf.ore = ore
				target_turf.update_and_spread_mineral()

/turf/closed/rock/proc/drop_ore()
	if(isnull(ore))
		return
	if(!ispath(ore.item_path, /obj/item/ore))
		return

	var/obj/item/ore/O = new ore.item_path(src)
	if(istype(O))
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data
	return O

/turf/closed/rock/proc/get_drilled(artifact_fail = FALSE)
	//var/destroyed = 0 //used for breaking strange rocks
	if(isnotnull(ore) && ore.result_amount)
		//if the turf has already been excavated, some of it's ore has been removed
		for(var/i in 1 to (ore.result_amount - mined_ore))
			drop_ore()

	//destroyed artifacts have weird, unpleasant effects
	//make sure to destroy them before changing the turf though
	if(artifact_find && artifact_fail)
		var/pain = FALSE
		if(prob(50))
			pain = TRUE
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

	var/turf/open/floor/plating/asteroid/airless/N = ChangeTurf(/turf/open/floor/plating/asteroid/airless)
	N.full_update_mineral_overlays()

	if(rand(1, 500) == 1)
		visible_message(SPAN_NOTICE("An old dusty crate was buried within!"))
		new /obj/structure/closet/crate/secure/loot(src)

/turf/closed/rock/proc/excavate_find(prob_clean = 0, datum/find/F)
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

/turf/closed/rock/proc/artifact_debris(severity = 0)
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
				new /obj/item/stack/sheet/steel(src, rand(5, 25))

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
				var/obj/item/stack/sheet/uranium/R = new /obj/item/stack/sheet/uranium(src)
				R.amount = rand(5, 25)