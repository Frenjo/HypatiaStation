/decl/special_role/raider
	name = "Vox Raider"

	role_type = SPECIAL_ROLE_VOX_RAIDER
	role_flag = BE_RAIDER

	var/list/turf/raider_spawns = list()
	var/list/raider_objectives = null

/decl/special_role/raider/New()
	. = ..()
	for_no_type_check(var/obj/effect/landmark/L, GLOBL.landmark_list)
		if(L.name == "voxstart")
			raider_spawns += GET_TURF(L)
			qdel(L)
			continue

	// Generate objectives for the group.
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		raider_objectives = forge_vox_objectives()

/decl/special_role/raider/setup(mob/living/carbon/human/vox)
	. = ..()

	var/static/index = 1
	if(index > length(raider_spawns))
		index = 1

	vox.forceMove(raider_spawns[index])
	index++

	var/sounds = rand(2, 8)
	var/i = 0
	var/newname = ""

	while(i <= sounds)
		i++
		newname += pick(list("ti", "hi", "ki", "ya", "ta", "ha", "ka", "ya", "chi", "cha", "kah"))

	vox.real_name = capitalize(newname)
	vox.name = vox.real_name
	vox.mind.name = vox.name
	vox.age = rand(12, 20)
	vox.dna.mutantrace = "vox"
	vox.set_species(SPECIES_VOX)
	vox.languages = list() // Removing language from chargen.
	vox.flavor_text = ""
	vox.add_language("Vox-Pidgin")
	vox.h_style = "Short Vox Quills"
	vox.f_style = "Shaved"
	for(var/datum/organ/external/limb in vox.organs)
		limb.status &= ~(ORGAN_DESTROYED | ORGAN_ROBOT)
	equip_vox_raider(vox)
	vox.regenerate_icons()

	vox.mind.objectives = raider_objectives
	greet_vox_raider(vox)

/decl/special_role/raider/proc/forge_vox_objectives()
	RETURN_TYPE(/list/datum/objective)

	. = list()

	var/i = 1
	var/max_objectives = pick(2, 2, 2, 2, 3, 3, 3, 4)
	while(i <= max_objectives)
		var/list/goals = list("kidnap", "loot", "salvage")
		var/goal = pick(goals)
		var/datum/objective/heist/O

		if(goal == "kidnap")
			goals -= "kidnap"
			O = new /datum/objective/heist/kidnap()
		else if(goal == "loot")
			O = new /datum/objective/heist/loot()
		else
			O = new /datum/objective/heist/salvage()
		O.choose_target()
		. += O

		i++

	// -All- vox raids have these two objectives. Failing them loses the game.
	. += new /datum/objective/heist/inviolate_crew()
	. += new /datum/objective/heist/inviolate_death()

/decl/special_role/raider/proc/equip_vox_raider(mob/living/carbon/human/raider)
	var/static/vox_tick = 1
	switch(vox_tick)
		if(1) // Vox raider!
			raider.equip_outfit(/decl/hierarchy/outfit/vox/raider)
		if(2) // Vox engineer!
			raider.equip_outfit(/decl/hierarchy/outfit/vox/engineer)
		if(3) // Vox saboteur!
			raider.equip_outfit(/decl/hierarchy/outfit/vox/saboteur)
		if(4) // Vox medic!
			raider.equip_outfit(/decl/hierarchy/outfit/vox/medic)

	var/obj/item/card/id/syndicate/C = new /obj/item/card/id/syndicate(src)
	C.name = "[raider.real_name]'s Legitimate Human ID Card"
	C.icon_state = "id"
	C.access = list(ACCESS_SYNDICATE)
	C.assignment = "Trader"
	C.registered_name = raider.real_name
	C.registered_user = src

	var/obj/item/storage/wallet/W = new /obj/item/storage/wallet(src)
	W.handle_item_insertion(C)
	spawn_money(rand(50, 150) * 10, W)
	raider.equip_to_slot_or_del(W, SLOT_ID_ID_STORE)

	vox_tick++
	if(vox_tick > 4)
		vox_tick = 1

/decl/special_role/raider/proc/greet_vox_raider(mob/living/carbon/human/raider)
	to_chat(raider, SPAN_INFO_B("You are a Vox Raider, fresh from the Shoal!"))
	to_chat(raider, SPAN_INFO("The Vox are a race of cunning, sharp-eyed nomadic raiders and traders endemic to Tau Ceti and much of the unexplored galaxy. You and the crew have come to the [GLOBL.current_map.short_name] for plunder, trade or both."))
	to_chat(raider, SPAN_INFO("Vox are cowardly and will flee from larger groups, but corner one or find them en masse and they are vicious."))
	to_chat(raider, SPAN_INFO("Use :V to voxtalk, :H to talk on your encrypted channel, and don't forget to turn on your nitrogen internals!"))
	to_chat(raider, SPAN_WARNING("IF YOU HAVE NOT PLAYED A VOX BEFORE, REVIEW THIS THREAD: http://baystation12.net/forums/viewtopic.php?f=6&t=8657.")) // TODO: Do some research into this, maybe use the wayback machine or just talk to Loaf?
	var/obj_count = 1
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		for(var/datum/objective/objective in raider.mind.objectives)
			to_chat(raider, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++
	else
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(raider)