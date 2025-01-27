/*
 * Monkey
 */
/decl/gene/monkey
	name = "Monkey"

/decl/gene/monkey/New()
	. = ..()
	block = GLOBL.dna_data.monkey_block

/decl/gene/monkey/can_activate(mob/M, flags)
	return ishuman(M) || ismonkey(M)

/decl/gene/monkey/activate(mob/living/M, connected, flags)
	if(!ishuman(M))
		//testing("Cannot monkey-ify [M], type is [M.type].")
		return
	var/mob/living/carbon/human/H = M
	H.monkeyizing = 1
	var/list/implants = list() //Try to preserve implants.
	for(var/obj/item/implant/W in H)
		implants.Add(W)
		W.loc = null

	if(!connected)
		for(var/obj/item/W in (H.contents-implants))
			if(W == H.wear_uniform) // will be teared
				continue
			H.drop_from_inventory(W)
		M.monkeyizing = 1
		M.canmove = FALSE
		M.icon = null
		M.invisibility = INVISIBILITY_MAXIMUM
		var/atom/movable/overlay/animation = new /atom/movable/overlay(M.loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("h2monkey", animation)
		sleep(48)
		qdel(animation)

	var/mob/living/carbon/monkey/O = null
	if(isnotnull(H.species.primitive))
		O = new H.species.primitive(src)
	else
		H.gib() //Trying to change the species of a creature with no primitive var set is messy.
		return

	if(isnotnull(M))
		if(isnotnull(M.dna))
			O.dna = M.dna.Clone()
			M.dna = null
		if(M.suiciding)
			O.suiciding = M.suiciding
			M.suiciding = null

	for(var/datum/disease/D in M.viruses)
		O.viruses += D
		D.affected_mob = O
		M.viruses -= D

	for(var/obj/T in (M.contents-implants))
		qdel(T)

	O.forceMove(M.loc)

	M.mind?.transfer_to(O) //transfer our mind to the cute little monkey

	if(connected) //inside dna thing
		var/obj/machinery/dna_scannernew/C = connected
		O.forceMove(C)
		C.occupant = O
		connected = null
	O.real_name = "monkey ([copytext(md5(M.real_name), 2, 6)])"
	O.take_overall_damage(M.getBruteLoss() + 40, M.getFireLoss())
	O.adjustToxLoss(M.getToxLoss() + 20)
	O.adjustOxyLoss(M.getOxyLoss())
	O.stat = M.stat
	O.a_intent = "hurt"
	for(var/obj/item/implant/I in implants)
		I.forceMove(O)
		I.implanted = O
//		O.update_icon = 1	//queue a full icon update at next life() call
	qdel(M)

/decl/gene/monkey/deactivate(mob/living/M, connected, flags)
	if(!ismonkey(M))
		//testing("Cannot humanize [M], type is [M.type].")
		return
	var/mob/living/carbon/monkey/Mo = M
	Mo.monkeyizing = 1
	var/list/implants = list() //Still preserving implants
	for(var/obj/item/implant/W in Mo)
		implants.Add(W)
		W.loc = null
	if(!connected)
		for(var/obj/item/W in (Mo.contents - implants))
			Mo.drop_from_inventory(W)
		M.monkeyizing = 1
		M.canmove = FALSE
		M.icon = null
		M.invisibility = INVISIBILITY_MAXIMUM
		var/atom/movable/overlay/animation = new(M.loc)
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = src
		flick("monkey2h", animation)
		sleep(48)
		qdel(animation)

	var/mob/living/carbon/human/O
	if(Mo.greaterform)
		O = new /mob/living/carbon/human(src, Mo.greaterform)
	else
		O = new /mob/living/carbon/human(src)

	if(M.dna.GetUIState(DNA_UI_GENDER))
		O.gender = FEMALE
	else
		O.gender = MALE

	if(isnotnull(M))
		if(isnotnull(M.dna))
			O.dna = M.dna.Clone()
			M.dna = null
		if(M.suiciding)
			O.suiciding = M.suiciding
			M.suiciding = null

	for(var/datum/disease/D in M.viruses)
		O.viruses += D
		D.affected_mob = O
		M.viruses -= D

	//for(var/obj/T in M)
	//	del(T)

	O.forceMove(M.loc)

	M.mind?.transfer_to(O) //transfer our mind to the human

	if(connected) //inside dna thing
		var/obj/machinery/dna_scannernew/C = connected
		O.forceMove(C)
		C.occupant = O
		connected = null

	var/i
	while(!i)
		var/randomname
		if(O.gender == MALE)
			randomname = capitalize(pick(GLOBL.first_names_male) + " " + capitalize(pick(GLOBL.last_names)))
		else
			randomname = capitalize(pick(GLOBL.first_names_female) + " " + capitalize(pick(GLOBL.last_names)))
		if(findname(randomname))
			continue
		else
			O.real_name = randomname
			i++
	O.UpdateAppearance()
	O.take_overall_damage(M.getBruteLoss(), M.getFireLoss())
	O.adjustToxLoss(M.getToxLoss())
	O.adjustOxyLoss(M.getOxyLoss())
	O.stat = M.stat
	for(var/obj/item/implant/I in implants)
		I.forceMove(O)
		I.implanted = O
//		O.update_icon = 1	//queue a full icon update at next life() call
	qdel(M)