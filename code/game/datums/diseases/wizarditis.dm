/datum/disease/wizarditis
	name = "Wizarditis"
	max_stages = 4
	spread = "Airborne"
	cure = "The Manly Dorf"
	cure_id = "manlydorf"
	cure_chance = 100
	agent = "Rincewindus Vulgaris"
	affected_species = list(SPECIES_HUMAN)
	curable = 1
	permeability_mod = 0.75
	desc = "Some speculate, that this virus is the cause of Wizard Federation existance. Subjects affected show the signs of mental retardation, yelling obscure sentences or total gibberish. On late stages subjects sometime express the feelings of inner power, and, cite, 'the ability to control the forces of cosmos themselves!' A gulp of strong, manly spirits usually reverts them to normal, humanlike, condition."
	severity = "Major"

/*
BIRUZ BENNAR
SCYAR NILA - teleport
NEC CANTIO - dis techno
EI NATH - shocking grasp
AULIE OXIN FIERA - knock
TARCOL MINTI ZHERI - forcewall
STI KALY - blind
*/

/datum/disease/wizarditis/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(1) && prob(50))
				affected_mob.say(pick("You shall not pass!", "Expeliarmus!", "By Merlins beard!", "Feel the power of the Dark Side!"))
			if(prob(1) && prob(50))
				to_chat(affected_mob, SPAN_WARNING("You feel [pick("that you don't have enough mana", "that the winds of magic are gone", "an urge to summon familiar")]."))

		if(3)
			if(prob(1) && prob(50))
				affected_mob.say(pick("NEC CANTIO!", "AULIE OXIN FIERA!", "STI KALY!", "TARCOL MINTI ZHERI!"))
			if(prob(1) && prob(50))
				to_chat(affected_mob, SPAN_WARNING("You feel [pick("the magic bubbling in your veins", "that this location gives you a +1 to INT", "an urge to summon familiar")]."))

		if(4)
			if(prob(1))
				affected_mob.say(pick("NEC CANTIO!", "AULIE OXIN FIERA!", "STI KALY!", "EI NATH!"))
				return
			if(prob(1) && prob(50))
				to_chat(affected_mob, SPAN_WARNING("You feel [pick("the tidal wave of raw power building inside", "that this location gives you a +2 to INT and +1 to WIS", "an urge to teleport")]."))
				spawn_wizard_clothes(50)
			if(prob(1) && prob(1))
				teleport()
	return

/datum/disease/wizarditis/proc/spawn_wizard_clothes(chance = 0)
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		if(prob(chance))
			if(!istype(H.head, /obj/item/clothing/head/wizard))
				if(isnotnull(H.head))
					H.drop_from_inventory(H.head)
				H.equip_to_slot_if_possible(new /obj/item/clothing/head/wizard(H), SLOT_ID_HEAD, FALSE, TRUE)
			return
		if(prob(chance))
			if(!istype(H.wear_suit, /obj/item/clothing/suit/wizrobe))
				if(isnotnull(H.wear_suit))
					H.drop_from_inventory(H.wear_suit)
				H.equip_to_slot_if_possible(new /obj/item/clothing/suit/wizrobe(H), SLOT_ID_WEAR_SUIT, FALSE, TRUE)
			return
		if(prob(chance))
			if(!istype(H.shoes, /obj/item/clothing/shoes/sandal))
				if(isnotnull(H.shoes))
					H.drop_from_inventory(H.shoes)
				H.equip_to_slot_if_possible(new /obj/item/clothing/shoes/sandal(H), SLOT_ID_SHOES, FALSE, TRUE)
			return
	else
		var/mob/living/carbon/H = affected_mob
		if(prob(chance))
			if(!istype(H.r_hand, /obj/item/staff))
				H.drop_r_hand()
				H.put_in_r_hand(new /obj/item/staff(H))
			return
	return

/datum/disease/wizarditis/proc/teleport()
	var/list/theareas = list()
	for(var/area/AR in orange(80, affected_mob))
		if(theareas.Find(AR) || istype(AR, /area/space))
			continue
		theareas += AR

	if(!theareas)
		return

	var/area/thearea = pick(theareas)

	var/list/L = list()
	for_no_type_check(var/turf/T, get_area_turfs(thearea.type))
		if(T.z != affected_mob.z)
			continue
		if(istype(T, /area/space))
			continue
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	if(!L)
		return

	affected_mob.say("SCYAR NILA [uppertext(thearea.name)]!")
	affected_mob.forceMove(pick(L))

	return