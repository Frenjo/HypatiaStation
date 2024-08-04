//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
GLOBAL_GLOBL_LIST_NEW(all_objectives)

/datum/objective
	var/datum/mind/owner = null			//Who owns the objective.
	var/explanation_text = "Nothing"	//What that person is supposed to do.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = 0					//currently only used for custom objectives.

/datum/objective/New(text)
	GLOBL.all_objectives |= src
	if(text)
		explanation_text = text
	..()

/datum/objective/Destroy()
	GLOBL.all_objectives -= src
	return ..()

/datum/objective/proc/check_completion()
	return completed

/datum/objective/proc/find_target()
	var/list/possible_targets = list()
	for_no_type_check(var/datum/mind/possible_target, global.PCticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && possible_target.current.stat != DEAD)
			possible_targets += possible_target
	if(length(possible_targets))
		target = pick(possible_targets)

/datum/objective/proc/find_target_by_role(role, role_type = 0)//Option sets either to check assigned role or special role. Default to assigned.
	for_no_type_check(var/datum/mind/possible_target, global.PCticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (role_type ? possible_target.special_role : possible_target.assigned_role) == role)
			target = possible_target
			break


/datum/objective/assassinate

/datum/objective/assassinate/find_target()
	..()
	if(target && target.current)
		explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/assassinate/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Assassinate [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/assassinate/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current) || target.current.z > 6 || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 1
		return 0
	return 1


/datum/objective/mutiny

/datum/objective/mutiny/find_target()
	..()
	if(target && target.current)
		explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/mutiny/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Assassinate [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/mutiny/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || !ishuman(target.current) || !target.current.ckey)
			return 1
		var/turf/T = get_turf(target.current)
		if(T && isnotstationlevel(T.z))			//If they leave the station they count as dead for this
			return 2
		return 0
	return 1


/datum/objective/mutiny/rp

/datum/objective/mutiny/rp/find_target()
	..()
	if(target && target.current)
		explanation_text = "Assassinate, capture or convert [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/mutiny/rp/find_target_by_role(role, role_type=0)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Assassinate, capture or convert [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"
	return target

// less violent rev objectives
/datum/objective/mutiny/rp/check_completion()
	var/rval = 1
	if(isnotnull(target?.current))
		//assume that only carbon mobs can become rev heads for now
		if(target.current.stat == DEAD || target.current:handcuffed || !ishuman(target.current))
			return 1
		// Check if they're converted
		if(IS_GAME_MODE(/datum/game_mode/revolution))
			var/datum/game_mode/revolution/rev = global.PCticker.mode
			if(target in rev.head_revolutionaries)
				return 1
		var/turf/T = get_turf(target.current)
		if(isnotnull(T) && isnotstationlevel(T.z)) // If they leave the station they count as dead for this.
			rval = 2
		return 0
	return rval


/datum/objective/anti_revolution/execute

/datum/objective/anti_revolution/execute/find_target()
	..()
	if(isnotnull(target?.current))
		explanation_text = "[target.current.real_name], the [target.assigned_role] has extracted confidential information above their clearance. Execute \him[target.current]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/execute/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if(isnotnull(target?.current))
		explanation_text = "[target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] has extracted confidential information above their clearance. Execute \him[target.current]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/execute/check_completion()
	if(isnotnull(target?.current))
		if(target.current.stat == DEAD || !ishuman(target.current))
			return 1
		return 0
	return 1


/datum/objective/anti_revolution/brig
	var/already_completed = 0

/datum/objective/anti_revolution/brig/find_target()
	..()
	if(isnotnull(target?.current))
		explanation_text = "Brig [target.current.real_name], the [target.assigned_role] for 20 minutes to set an example."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/brig/find_target_by_role(role, role_type=0)
	..(role, role_type)
	if(isnotnull(target?.current))
		explanation_text = "Brig [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] for 20 minutes to set an example."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/brig/check_completion()
	if(already_completed)
		return 1

	if(isnotnull(target?.current))
		if(target.current.stat == DEAD)
			return 0
		if(target.is_brigged(10 * 60 * 10))
			already_completed = 1
			return 1
		return 0
	return 0


/datum/objective/anti_revolution/demote

/datum/objective/anti_revolution/demote/find_target()
	..()
	if(isnotnull(target?.current))
		explanation_text = "[target.current.real_name], the [target.assigned_role]  has been classified as harmful to NanoTrasen's goals. Demote \him[target.current] to assistant."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/demote/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if(isnotnull(target?.current))
		explanation_text = "[target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] has been classified as harmful to NanoTrasen's goals. Demote \him[target.current] to assistant."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/anti_revolution/demote/check_completion()
	if(isnotnull(target?.current) && ishuman(target))
		var/obj/item/card/id/I = target.current:id_store
		if(istype(I, /obj/item/pda))
			var/obj/item/pda/P = I
			I = P.id

		if(!istype(I))
			return 1

		if(I.assignment == "Assistant")
			return 1
		else
			return 0
	return 1


/datum/objective/debrain//I want braaaainssss

/datum/objective/debrain/find_target()
	..()
	if(isnotnull(target?.current))
		explanation_text = "Steal the brain of [target.current.real_name]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/debrain/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if(isnotnull(target?.current))
		explanation_text = "Steal the brain of [target.current.real_name] the [!role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/debrain/check_completion()
	if(isnull(target))//If it's a free objective.
		return 1
	if(isnull(owner.current) || owner.current.stat == DEAD)//If you're otherwise dead.
		return 0
	if(isnull(target.current) || !isbrain(target.current))
		return 0
	var/atom/A = target.current
	while(A.loc)			//check to see if the brainmob is on our person
		A = A.loc
		if(A == owner.current)
			return 1
	return 0


/datum/objective/protect//The opposite of killing a dude.

/datum/objective/protect/find_target()
	..()
	if(isnotnull(target?.current))
		explanation_text = "Protect [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/protect/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if(isnotnull(target?.current))
		explanation_text = "Protect [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/protect/check_completion()
	if(isnull(target))	//If it's a free objective.
		return 1
	if(isnotnull(target.current))
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current))
			return 0
		return 1
	return 0


/datum/objective/hijack
	explanation_text = "Hijack the emergency shuttle by escaping alone."

/datum/objective/hijack/check_completion()
	if(isnull(owner.current) || owner.current.stat)
		return 0
	if(!global.PCemergency.returned())
		return 0
	if(issilicon(owner.current))
		return 0
	var/area/shuttle = locate(/area/shuttle/escape/centcom)
	var/list/protected_mobs = list(/mob/living/silicon/ai, /mob/living/silicon/pai)
	for(var/mob/living/player in GLOBL.player_list)
		if(player.type in protected_mobs)
			continue
		if(isnotnull(player.mind) && (player.mind != owner))
			if(player.stat != DEAD)			//they're not dead!
				if(get_turf(player) in shuttle)
					return 0
	return 1


/datum/objective/block
	explanation_text = "Do not allow any organic lifeforms to escape on the shuttle alive."

/datum/objective/block/check_completion()
	if(!issilicon(owner.current))
		return 0
	if(!global.PCemergency.returned())
		return 0
	if(isnull(owner.current))
		return 0
	var/area/shuttle = locate(/area/shuttle/escape/centcom)
	var/list/protected_mobs = list(/mob/living/silicon/ai, /mob/living/silicon/pai, /mob/living/silicon/robot)
	for(var/mob/living/player in GLOBL.player_list)
		if(player.type in protected_mobs)
			continue
		if(isnotnull(player.mind))
			if(player.stat != DEAD)
				if(get_turf(player) in shuttle)
					return 0
	return 1


/datum/objective/silence
	explanation_text = "Do not allow anyone to escape the station.  Only allow the shuttle to be called when everyone is dead and your story is the only one left."

/datum/objective/silence/check_completion()
	if(!global.PCemergency.returned())
		return 0

	for(var/mob/living/player in GLOBL.player_list)
		if(player == owner.current)
			continue
		if(isnotnull(player.mind))
			if(player.stat != DEAD)
				var/turf/T = get_turf(player)
				if(!T)
					continue
				switch(T.loc.type)
					if(/area/shuttle/escape/centcom, /area/shuttle/escape_pod1/centcom, /area/shuttle/escape_pod2/centcom, /area/shuttle/escape_pod3/centcom, /area/shuttle/escape_pod5/centcom, /area/shuttle/arrival/centcom)
						return 0
	return 1


/datum/objective/escape
	explanation_text = "Escape on the shuttle or an escape pod alive and free."


/datum/objective/escape/check_completion()
	if(issilicon(owner.current))
		return 0
	if(isbrain(owner.current))
		return 0
	if(!global.PCemergency.returned())
		return 0
	if(isnull(owner.current) || owner.current.stat == DEAD)
		return 0
	var/turf/location = get_turf(owner.current.loc)
	if(isnull(location))
		return 0

	if(istype(location, /turf/simulated/shuttle/floor/brig)) // Fails traitors if they are in the shuttle brig -- Polymorph
		if(iscarbon(owner.current))
			var/mob/living/carbon/C = owner.current
			if(!C.handcuffed)
				return 1
		return 0

	var/area/check_area = location.loc
	if(istype(check_area, /area/shuttle/escape/centcom))
		return 1
	if(istype(check_area, /area/shuttle/escape_pod1/centcom))
		return 1
	if(istype(check_area, /area/shuttle/escape_pod2/centcom))
		return 1
	if(istype(check_area, /area/shuttle/escape_pod3/centcom))
		return 1
	if(istype(check_area, /area/shuttle/escape_pod5/centcom))
		return 1
	if(istype(check_area, /area/shuttle/arrival/centcom))
		return 1
	else
		return 0


/datum/objective/survive
	explanation_text = "Stay alive until the end."

/datum/objective/survive/check_completion()
	if(isnull(owner.current) || owner.current.stat == DEAD || isbrain(owner.current))
		return 0		//Brains no longer win survive objectives. --NEO
	if(issilicon(owner.current) && owner.current != owner.original)
		return 0
	return 1

// Similar to the anti-rev objective, but for traitors
/datum/objective/brig
	var/already_completed = 0

/datum/objective/brig/find_target()
	..()
	if(isnotnull(target?.current))
		explanation_text = "Have [target.current.real_name], the [target.assigned_role] brigged for 10 minutes."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/brig/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if(isnotnull(target?.current))
		explanation_text = "Have [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role] brigged for 10 minutes."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/brig/check_completion()
	if(already_completed)
		return 1

	if(isnotnull(target?.current))
		if(target.current.stat == DEAD)
			return 0
		// Make the actual required time a bit shorter than the official time
		if(target.is_brigged(10 * 60 * 5))
			already_completed = 1
			return 1
		return 0
	return 0

// Harm a crew member, making an example of them
/datum/objective/harm
	var/already_completed = 0

/datum/objective/harm/find_target()
	..()
	if(isnotnull(target?.current))
		explanation_text = "Make an example of [target.current.real_name], the [target.assigned_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
	else
		explanation_text = "Free Objective"
	return target


/datum/objective/harm/find_target_by_role(role, role_type = 0)
	..(role, role_type)
	if(isnotnull(target?.current))
		explanation_text = "Make an example of [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/harm/check_completion()
	if(already_completed)
		return 1

	if(isnotnull(target?.current) && ishuman(target.current))
		if(target.current.stat == DEAD)
			return 0

		var/mob/living/carbon/human/H = target.current
		for(var/datum/organ/external/E in H.organs)
			if(E.status & ORGAN_BROKEN)
				already_completed = 1
				return 1
			if(E.status & ORGAN_DESTROYED && !E.amputated)
				already_completed = 1
				return 1

		var/datum/organ/external/head/head = H.get_organ("head")
		if(head.disfigured)
			return 1
	return 0


/datum/objective/nuclear
	explanation_text = "Destroy the station with a nuclear device."


/datum/objective/steal
	var/obj/item/steal_target
	var/target_name

	var/static/list/possible_items = list(
		"the captain's antique laser gun" = /obj/item/gun/energy/laser/captain,
		"a hand teleporter" = /obj/item/hand_tele,
		"an RCD" = /obj/item/rcd,
		"a jetpack" = /obj/item/tank/jetpack,
		"a captain's jumpsuit" = /obj/item/clothing/under/rank/captain,
		"a functional AI" = /obj/item/aicard,
		"a pair of magboots" = /obj/item/clothing/shoes/magboots,
		"the station blueprints" = /obj/item/blueprints,
		"a nasa voidsuit" = /obj/item/clothing/suit/space/nasavoid,
		"28 moles of plasma (full tank)" = /obj/item/tank,
		"a sample of slime extract" = /obj/item/slime_extract,
		"a piece of corgi meat" = /obj/item/reagent_containers/food/snacks/meat/corgi,
		"a research director's jumpsuit" = /obj/item/clothing/under/rank/research_director,
		"a chief engineer's jumpsuit" = /obj/item/clothing/under/rank/chief_engineer,
		"a chief medical officer's jumpsuit" = /obj/item/clothing/under/rank/chief_medical_officer,
		"a head of security's jumpsuit" = /obj/item/clothing/under/rank/head_of_security,
		"a head of personnel's jumpsuit" = /obj/item/clothing/under/rank/head_of_personnel,
		"the hypospray" = /obj/item/reagent_containers/hypospray,
		"the captain's pinpointer" = /obj/item/pinpointer,
		"an ablative armor vest" = /obj/item/clothing/suit/armor/laserproof,
	)

	var/static/list/possible_items_special = list(
		/*"nuclear authentication disk" = /obj/item/disk/nuclear,*///Broken with the change to nuke disk making it respawn on z level change.
		"nuclear gun" = /obj/item/gun/energy/gun/nuclear,
		"diamond drill" = /obj/item/pickaxe/diamonddrill,
		"bag of holding" = /obj/item/storage/backpack/holding,
		"hyper-capacity cell" = /obj/item/cell/hyper,
		"10 diamonds" = /obj/item/stack/sheet/diamond,
		"50 gold bars" = /obj/item/stack/sheet/gold,
		"25 refined uranium bars" = /obj/item/stack/sheet/uranium,
	)


/datum/objective/steal/proc/set_target(item_name)
	target_name = item_name
	steal_target = possible_items[target_name]
	if(isnull(steal_target))
		steal_target = possible_items_special[target_name]
	explanation_text = "Steal [target_name]."
	return steal_target


/datum/objective/steal/find_target()
	return set_target(pick(possible_items))


/datum/objective/steal/proc/select_target()
	var/list/possible_items_all = possible_items + possible_items_special + "custom"
	var/new_target = input("Select target:", "Objective target", steal_target) as null|anything in possible_items_all
	if(isnull(new_target))
		return
	if(new_target == "custom")
		var/obj/item/custom_target = input("Select type:", "Type") as null|anything in typesof(/obj/item)
		if(isnull(custom_target))
			return
		var/obj/tmp_obj = new custom_target()
		var/custom_name = tmp_obj.name
		qdel(tmp_obj)
		custom_name = copytext(sanitize(input("Enter target name:", "Objective target", custom_name) as text|null), 1, MAX_MESSAGE_LEN)
		if(isnull(custom_name))
			return
		target_name = custom_name
		steal_target = custom_target
		explanation_text = "Steal [target_name]."
	else
		set_target(new_target)
	return steal_target

/datum/objective/steal/check_completion()
	if(isnull(steal_target) || isnull(owner.current))
		return 0
	if(!isliving(owner.current))
		return 0
	var/list/all_items = owner.current.get_contents()
	switch(target_name)
		if("28 moles of plasma (full tank)", "10 diamonds", "50 gold bars", "25 refined uranium bars")
			var/target_amount = text2num(target_name)//Non-numbers are ignored.
			var/found_amount = 0.0//Always starts as zero.

			for(var/obj/item/I in all_items) //Check for plasma tanks
				if(istype(I, steal_target))
					found_amount += (target_name == "28 moles of plasma (full tank)") ? I:air_contents:gas[/decl/xgm_gas/plasma] : I:amount
			return found_amount >= target_amount

		if("50 coins (in bag)")
			var/obj/item/moneybag/B = locate() in all_items
			if(isnotnull(B))
				var/target = text2num(target_name)
				var/found_amount = 0.0
				for(var/obj/item/coin/C in B)
					found_amount++
				return found_amount >= target

		if("a functional AI")
			for(var/obj/item/aicard/C in all_items) //Check for ai card
				for(var/mob/living/silicon/ai/M in C)
					if(isAI(M) && M.stat != DEAD) //See if any AI's are alive inside that card.
						return 1

			for(var/obj/item/clothing/suit/space/space_ninja/S in all_items) //Let an AI downloaded into a space ninja suit count
				if(isnotnull(S.AI) && S.AI.stat != DEAD)
					return 1

			for_no_type_check(var/mob/living/silicon/ai/ai, GLOBL.ai_list)
				if(isturf(ai.loc))
					var/area/check_area = get_area(ai)
					if(istype(check_area, /area/shuttle/escape/centcom))
						return 1
					if(istype(check_area, /area/shuttle/escape_pod1/centcom))
						return 1
					if(istype(check_area, /area/shuttle/escape_pod2/centcom))
						return 1
					if(istype(check_area, /area/shuttle/escape_pod3/centcom))
						return 1
					if(istype(check_area, /area/shuttle/escape_pod5/centcom))
						return 1
					if(istype(check_area, /area/shuttle/arrival/centcom))
						return 1

		else
			for(var/obj/I in all_items) //Check for items
				if(istype(I, steal_target))
					return 1
	return 0


/datum/objective/download

/datum/objective/download/proc/gen_amount_goal()
	target_amount = rand(10, 20)
	explanation_text = "Download [target_amount] research levels."
	return target_amount

/datum/objective/download/check_completion()
	if(!ishuman(owner.current))
		return 0
	if(isnull(owner.current) || owner.current.stat == DEAD)
		return 0
	if(!(istype(owner.current:wear_suit, /obj/item/clothing/suit/space/space_ninja) && owner.current:wear_suit:s_initialized))
		return 0
	var/current_amount
	var/obj/item/clothing/suit/space/space_ninja/S = owner.current:wear_suit
	if(!length(S.stored_research))
		return 0
	else
		for(var/datum/tech/current_data in S.stored_research)
			if(current_data.level > 1)
				current_amount += (current_data.level - 1)
	if(current_amount<target_amount)
		return 0
	return 1


/datum/objective/capture
/datum/objective/capture/proc/gen_amount_goal()
	target_amount = rand(5, 10)
	explanation_text = "Accumulate [target_amount] capture points."
	return target_amount

/datum/objective/capture/check_completion()//Basically runs through all the mobs in the area to determine how much they are worth.
	var/captured_amount = 0
	var/area/centcom/holding/A = locate()
	for(var/mob/living/carbon/human/M in A)//Humans.
		if(M.stat == DEAD)//Dead folks are worth less.
			captured_amount += 0.5
			continue
		captured_amount += 1
	for(var/mob/living/carbon/monkey/M in A)//Monkeys are almost worthless, you failure.
		captured_amount += 0.1
	for(var/mob/living/carbon/alien/larva/M in A)//Larva are important for research.
		if(M.stat == DEAD)
			captured_amount += 0.5
			continue
		captured_amount += 1
		/*for(var/mob/living/carbon/alien/humanoid/M in A)//Aliens are worth twice as much as humans.
			if(istype(M, /mob/living/carbon/alien/humanoid/queen))//Queens are worth three times as much as humans.
				if(M.stat==2)
					captured_amount+=1.5
				else
					captured_amount+=3
				continue
			if(M.stat==2)
				captured_amount+=1
				continue
			captured_amount+=2*/
	if(captured_amount < target_amount)
		return 0
	return 1


/datum/objective/absorb

/datum/objective/absorb/proc/gen_amount_goal(lowbound = 4, highbound = 6)
	target_amount = rand (lowbound, highbound)
	if(isnotnull(global.PCticker))
		var/n_p = 1 //autowin
		if(global.PCticker.current_state == GAME_STATE_SETTING_UP)
			for(var/mob/new_player/P in GLOBL.dead_mob_list)
				if(isnotnull(P.client) && P.ready && P.mind != owner)
					n_p ++
		else if(global.PCticker.current_state == GAME_STATE_PLAYING)
			for(var/mob/living/carbon/human/P in GLOBL.player_list)
				if(isnotnull(P.client) && !(P.mind in global.PCticker.mode.changelings) && P.mind != owner)
					n_p ++
		target_amount = min(target_amount, n_p)

	explanation_text = "Absorb [target_amount] compatible genomes."
	return target_amount

/datum/objective/absorb/check_completion()
	if(isnotnull(owner?.changeling) && owner.changeling.absorbed_dna && owner.changeling.absorbedcount >= target_amount)
		return 1
	else
		return 0



/* Isn't suited for global objectives
/*---------CULTIST----------*/

		eldergod
			explanation_text = "Summon Nar-Sie via the use of an appropriate rune. It will only work if nine cultists stand on and around it."

			check_completion()
				if(eldergod) //global var, defined in rune4.dm
					return 1
				return 0

		survivecult
			var/num_cult

			explanation_text = "Our knowledge must live on. Make sure at least 5 acolytes escape on the shuttle to spread their work on an another station."

			check_completion()
				//if(emergency_shuttle.location<2)
				if(emergency_shuttle.returned()) // Updated to reflect 'shuttles' port. -Frenjo
					return 0

				var/cultists_escaped = 0

				var/area/shuttle/escape/centcom/C = /area/shuttle/escape/centcom
				for(var/turf/T in	get_area_turfs(C.type))
					for(var/mob/living/carbon/H in T)
						if(iscultist(H))
							cultists_escaped++

				if(cultists_escaped>=5)
					return 1

				return 0

		sacrifice //stolen from traitor target objective

			proc/find_target() //I don't know how to make it work with the rune otherwise, so I'll do it via a global var, sacrifice_target, defined in rune15.dm
				var/list/possible_targets = call(/datum/game_mode/cult/proc/get_unconvertables)()

				if(length(possible_targets))
					sacrifice_target = pick(possible_targets)

				if(sacrifice_target && sacrifice_target.current)
					explanation_text = "Sacrifice [sacrifice_target.current.real_name], the [sacrifice_target.assigned_role]. You will need the sacrifice rune (Hell join blood) and three acolytes to do so."
				else
					explanation_text = "Free Objective"

				return sacrifice_target

			check_completion() //again, calling on a global list defined in rune15.dm
				if(sacrifice_target.current in sacrificed)
					return 1
				else
					return 0

/*-------ENDOF CULTIST------*/
*/

//Vox heist objectives.

/datum/objective/heist

/datum/objective/heist/proc/choose_target()
	return

/datum/objective/heist/kidnap

/datum/objective/heist/kidnap/choose_target()
	var/list/roles = list("Chief Engineer", "Research Director", "Roboticist", "Chemist", "Station Engineer")
	var/list/possible_targets = list()
	var/list/priority_targets = list()

	for_no_type_check(var/datum/mind/possible_target, global.PCticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && possible_target.current.stat != DEAD && possible_target.assigned_role != "MODE")
			possible_targets.Add(possible_target)
			for(var/role in roles)
				if(possible_target.assigned_role == role)
					priority_targets.Add(possible_target)
					continue

	if(length(priority_targets))
		target = pick(priority_targets)
	else if(length(possible_targets))
		target = pick(possible_targets)

	if(target && target.current)
		explanation_text = "The Shoal has a need for [target.current.real_name], the [target.assigned_role]. Take them alive."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/heist/kidnap/check_completion()
	if(isnotnull(target?.current))
		if(target.current.stat == DEAD)
			return 0 // They're dead. Fail.
		//if (!target.current.restrained())
		//	return 0 // They're loose. Close but no cigar.

		var/area/shuttle/vox/station/A = locate()
		for(var/mob/living/carbon/human/M in A)
			if(target.current == M)
				return 1 //They're restrained on the shuttle. Success.
	else
		return 0

/datum/objective/heist/loot

/datum/objective/heist/loot/choose_target()
	var/loot = "an object"
	switch(rand(1, 8))
		if(1)
			target = /obj/structure/particle_accelerator
			target_amount = 6
			loot = "a complete particle accelerator"
		if(2)
			target = /obj/machinery/the_singularitygen
			target_amount = 1
			loot = "a gravitational generator"
		if(3)
			target = /obj/machinery/power/emitter
			target_amount = 4
			loot = "four emitters"
		if(4)
			target = /obj/machinery/nuclearbomb
			target_amount = 1
			loot = "a nuclear bomb"
		if(5)
			target = /obj/item/gun
			target_amount = 6
			loot = "six guns"
		if(6)
			target = /obj/item/gun/energy
			target_amount = 4
			loot = "four energy guns"
		if(7)
			target = /obj/item/gun/energy/laser
			target_amount = 2
			loot = "two laser guns"
		if(8)
			target = /obj/item/gun/energy/ion
			target_amount = 1
			loot = "an ion gun"

	explanation_text = "We are lacking in hardware. Steal [loot]."

/datum/objective/heist/loot/check_completion()
	var/total_amount = 0
	for(var/obj/O in locate(/area/shuttle/vox/station))
		if(istype(O, target))
			total_amount++
		for(var/obj/I in O.contents)
			if(istype(I, target))
				total_amount++
		if(total_amount >= target_amount)
			return 1

	var/datum/game_mode/heist/H = global.PCticker.mode
	for_no_type_check(var/datum/mind/raider, H.raiders)
		if(isnotnull(raider.current))
			for(var/obj/O in raider.current.get_contents())
				if(istype(O, target))
					total_amount++
				if(total_amount >= target_amount)
					return 1

	return 0


/datum/objective/heist/salvage

/datum/objective/heist/salvage/choose_target()
	switch(rand(1, 8))
		if(1)
			target = MATERIAL_METAL
			target_amount = 300
		if(2)
			target = /decl/material/glass
			target_amount = 200
		if(3)
			target = /decl/material/plasteel
			target_amount = 100
		if(4)
			target = /decl/material/plasma
			target_amount = 100
		if(5)
			target = /decl/material/silver
			target_amount = 50
		if(6)
			target = /decl/material/gold
			target_amount = 20
		if(7)
			target = /decl/material/uranium
			target_amount = 20
		if(8)
			target = /decl/material/diamond
			target_amount = 20

	explanation_text = "Ransack the station and escape with [target_amount] [target]."

/datum/objective/heist/salvage/check_completion()
	var/total_amount = 0

	for(var/obj/item/O in locate(/area/shuttle/vox/station))
		if(istype(O, /obj/item/stack/sheet))
			var/obj/item/stack/sheet/S = O
			if(S.material.type == target)
				total_amount += S.amount
		for(var/obj/I in O.contents)
			if(istype(I, /obj/item/stack/sheet))
				var/obj/item/stack/sheet/S = I
				if(S.material.type == target)
					total_amount += S.amount

	var/datum/game_mode/heist/H = global.PCticker.mode
	for_no_type_check(var/datum/mind/raider, H.raiders)
		if(raider.current)
			for(var/obj/item/O in raider.current.get_contents())
				if(istype(O, /obj/item/stack/sheet))
					var/obj/item/stack/sheet/S = O
					if(S.material.type == target)
						total_amount += S.amount

	if(total_amount >= target_amount)
		return 1
	return 0


/datum/objective/heist/inviolate_crew
	explanation_text = "Do not leave any Vox behind, alive or dead."

/datum/objective/heist/inviolate_crew/check_completion()
	var/datum/game_mode/heist/H = global.PCticker.mode
	if(H.is_raider_crew_safe())
		return 1
	return 0


#define MAX_VOX_KILLS 10 //Number of kills during the round before the Inviolate is broken.
						 //Would be nice to use vox-specific kills but is currently not feasible.
GLOBAL_GLOBL_INIT(vox_kills, 0) //Used to check the Inviolate.

/datum/objective/heist/inviolate_death
	explanation_text = "Follow the Inviolate. Minimise death and loss of resources."

/datum/objective/heist/inviolate_death/check_completion()
	if(GLOBL.vox_kills > MAX_VOX_KILLS)
		return 0
	return 1
#undef MAX_VOX_KILLS