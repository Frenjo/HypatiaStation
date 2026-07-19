/decl/special_role/traitor
	name = "Traitor"

	role_type = SPECIAL_ROLE_TRAITOR
	role_flag = BE_TRAITOR

	restricted_jobs = list(/datum/job/robot) // They are part of the AI if he is traitor so are they, they use to get double chances
	protected_jobs = list(
		/datum/job/officer, /datum/job/warden, /datum/job/detective,
		/datum/job/hos, /datum/job/captain
	) // AI is currently out of the list as malf does not work for shit.

/decl/special_role/traitor/setup(mob/living/traitor, traitor_type = TRAITOR_NORMAL)
	. = ..()
	global.PCticker.mode.traitors.Add(traitor)
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		forge_traitor_objectives(traitor, traitor_type)
	finalise_traitor(traitor, traitor_type)
	greet_traitor(traitor, traitor_type)

/decl/special_role/traitor/proc/forge_traitor_objectives(mob/living/traitor, traitor_type)
	var/datum/mind/traitor_mind = traitor.mind
	switch(traitor_type)
		if(TRAITOR_NORMAL)
			if(issilicon(traitor))
				forge_silicon_objectives(traitor_mind)
			else
				forge_normal_objectives(traitor_mind)

		if(TRAITOR_SURVIVOR)
			var/datum/objective/survive/survive_objective = new /datum/objective/survive()
			survive_objective.owner = traitor_mind
			traitor_mind.objectives += survive_objective

		if(TRAITOR_HIGHLANDER)
			forge_highlander_objectives(traitor_mind)

		if(TRAITOR_BEACON)
			forge_beacon_objectives(traitor_mind)

/decl/special_role/traitor/proc/forge_silicon_objectives(datum/mind/traitor_mind)
	var/datum/objective/assassinate/kill_objective = new /datum/objective/assassinate()
	kill_objective.owner = traitor_mind
	kill_objective.find_target()
	traitor_mind.objectives += kill_objective

	var/datum/objective/survive/survive_objective = new /datum/objective/survive()
	survive_objective.owner = traitor_mind
	traitor_mind.objectives += survive_objective

	if(prob(10))
		var/datum/objective/block/block_objective = new /datum/objective/block()
		block_objective.owner = traitor_mind
		traitor_mind.objectives += block_objective

/decl/special_role/traitor/proc/forge_normal_objectives(datum/mind/traitor_mind)
	switch(rand(1, 100))
		if(1 to 33)
			var/datum/objective/assassinate/kill_objective = new /datum/objective/assassinate()
			kill_objective.owner = traitor_mind
			kill_objective.find_target()
			traitor_mind.objectives += kill_objective
		if(34 to 50)
			var/datum/objective/brig/brig_objective = new /datum/objective/brig()
			brig_objective.owner = traitor_mind
			brig_objective.find_target()
			traitor_mind.objectives += brig_objective
		if(51 to 66)
			var/datum/objective/harm/harm_objective = new /datum/objective/harm()
			harm_objective.owner = traitor_mind
			harm_objective.find_target()
			traitor_mind.objectives += harm_objective
		else
			var/datum/objective/steal/steal_objective = new /datum/objective/steal()
			steal_objective.owner = traitor_mind
			steal_objective.find_target()
			traitor_mind.objectives += steal_objective

	switch(rand(1, 100))
		if(1 to 100)
			if(!(locate(/datum/objective/escape) in traitor_mind.objectives))
				var/datum/objective/escape/escape_objective = new /datum/objective/escape()
				escape_objective.owner = traitor_mind
				traitor_mind.objectives += escape_objective

		else
			if(!(locate(/datum/objective/hijack) in traitor_mind.objectives))
				var/datum/objective/hijack/hijack_objective = new /datum/objective/hijack()
				hijack_objective.owner = traitor_mind
				traitor_mind.objectives += hijack_objective

/decl/special_role/traitor/proc/forge_highlander_objectives(datum/mind/traitor_mind)
	var/datum/objective/steal/steal_objective = new /datum/objective/steal()
	steal_objective.owner = traitor_mind
	steal_objective.set_target("nuclear authentication disk")
	traitor_mind.objectives += steal_objective

	var/datum/objective/hijack/hijack_objective = new /datum/objective/hijack()
	hijack_objective.owner = traitor_mind
	traitor_mind.objectives += hijack_objective

/decl/special_role/traitor/proc/forge_beacon_objectives(datum/mind/traitor_mind)
	var/objective = "Free Objective"
	switch(rand(1, 100))
		if(1 to 50)
			objective = "Steal [pick("a hand teleporter", "the Captain's antique laser gun", "a jetpack", "the Captain's ID", "the Captain's jumpsuit")]."
		if(51 to 60)
			objective = "Destroy 70% or more of the station's plasma tanks."
		if(61 to 70)
			objective = "Cut power to 80% or more of the station's tiles."
		if(71 to 80)
			objective = "Destroy the AI."
		if(81 to 90)
			objective = "Kill all monkeys aboard the station."
		else
			objective = "Make certain at least 80% of the station evacuates on the shuttle."

	var/datum/objective/custom_objective = new /datum/objective(objective)
	custom_objective.owner = traitor_mind
	traitor_mind.objectives += custom_objective

	var/datum/objective/escape/escape_objective = new /datum/objective/escape()
	escape_objective.owner = traitor_mind
	traitor_mind.objectives += escape_objective

/decl/special_role/traitor/proc/finalise_traitor(mob/living/carbon/human/traitor, traitor_type)
	if(issilicon(traitor))
		global.PCticker.mode.add_law_zero(traitor)
		return

	if(traitor_type == TRAITOR_NORMAL)
		global.PCticker.mode.equip_traitor(traitor)

	else if(traitor_type == TRAITOR_HIGHLANDER)
		for(var/obj/item/I in traitor)
			if(istype(I, /obj/item/implant))
				continue
			qdel(I)

		traitor.equip_outfit(/decl/hierarchy/outfit/highlander)

		var/obj/item/card/id/W = new /obj/item/card/id(traitor)
		W.name = "[traitor.real_name]'s ID Card"
		W.icon_state = "centcom"
		W.access = get_all_station_access()
		W.access += get_all_centcom_access()
		W.assignment = "Highlander"
		W.registered_name = traitor.real_name
		traitor.equip_to_slot_or_del(W, SLOT_ID_ID_STORE)

/decl/special_role/traitor/proc/greet_traitor(mob/living/traitor, traitor_type)
	switch(traitor_type)
		if(TRAITOR_NORMAL, TRAITOR_HIGHLANDER)
			to_chat(traitor, "<B><font size=3 color=red>You are the traitor.</font></B>")
		if(TRAITOR_SURVIVOR)
			to_chat(traitor, "<B><font size=3 color=red>You are the survivor.</font></B>")
			to_chat(traitor, SPAN_DANGER("Your own safety matters above all else, trust no one and kill anyone who gets in your way. However, armed as you are, now would be the perfect time to settle that score or grab that pair of yellow gloves you've been eyeing..."))

	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		var/obj_count = 1
		for_no_type_check(var/datum/objective/objective, traitor.mind.objectives)
			to_chat(traitor, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++
	else
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(traitor)