var/global/image/contamination_overlay = image('icons/effects/contamination.dmi')

/pl_control
	var/PLASMA_DMG = 3
	var/PLASMA_DMG_NAME = "Plasma Damage Amount"
	var/PLASMA_DMG_DESC = "Self Descriptive"

	var/CLOTH_CONTAMINATION = 1
	var/CLOTH_CONTAMINATION_NAME = "Cloth Contamination"
	var/CLOTH_CONTAMINATION_DESC = "If this is on, plasma does damage by getting into cloth."

	var/PLASMAGUARD_ONLY = 0
	var/PLASMAGUARD_ONLY_NAME = "\"PlasmaGuard Only\""
	var/PLASMAGUARD_ONLY_DESC = "If this is on, only biosuits and spacesuits protect against contamination and ill effects."

	var/GENETIC_CORRUPTION = 0
	var/GENETIC_CORRUPTION_NAME = "Genetic Corruption Chance"
	var/GENETIC_CORRUPTION_DESC = "Chance of genetic corruption as well as toxic damage, X in 10,000."

	var/SKIN_BURNS = 0
	var/SKIN_BURNS_DESC = "Plasma has an effect similar to mustard gas on the un-suited."
	var/SKIN_BURNS_NAME = "Skin Burns"

	var/EYE_BURNS = 1
	var/EYE_BURNS_NAME = "Eye Burns"
	var/EYE_BURNS_DESC = "Plasma burns the eyes of anyone not wearing eye protection."

	var/CONTAMINATION_LOSS = 0.02
	var/CONTAMINATION_LOSS_NAME = "Contamination Loss"
	var/CONTAMINATION_LOSS_DESC = "How much toxin damage is dealt from contaminated clothing" //Per tick?  ASK ARYN

	var/PLASMA_HALLUCINATION = 0
	var/PLASMA_HALLUCINATION_NAME = "Plasma Hallucination"
	var/PLASMA_HALLUCINATION_DESC = "Does being in plasma cause you to hallucinate?"

	var/N2O_HALLUCINATION = 1
	var/N2O_HALLUCINATION_NAME = "N2O Hallucination"
	var/N2O_HALLUCINATION_DESC = "Does being in sleeping gas cause you to hallucinate?"

/obj
	var/contaminated = FALSE

/obj/item/proc/can_contaminate()
	//Clothing and backpacks can be contaminated.
	if(HAS_ITEM_FLAGS(src, ITEM_FLAG_PLASMAGUARD))
		return 0
	else if(istype(src, /obj/item/storage/backpack))
		return 0 //Cannot be washed :(
	else if(istype(src, /obj/item/clothing))
		return 1

/obj/item/proc/contaminate()
	//Do a contamination overlay? Temporary measure to keep contamination less deadly than it was.
	if(!contaminated)
		contaminated = TRUE
		add_overlay(contamination_overlay)

/obj/item/proc/decontaminate()
	contaminated = FALSE
	remove_overlay(contamination_overlay)

/mob/proc/contaminate()

/mob/living/carbon/human/contaminate()
	//See if anything can be contaminated.
	if(!pl_suit_protected())
		suit_contamination()

	if(!pl_head_protected())
		if(prob(1))
			suit_contamination() //Plasma can sometimes get through such an open suit.

//Cannot wash backpacks currently.
//	if(istype(back,/obj/item/storage/backpack))
//		back.contaminate()

/mob/proc/pl_effects()

/mob/living/carbon/human/pl_effects()
	//Handles all the bad things plasma can do.

	//Contamination
	if(global.vsc.plc.CLOTH_CONTAMINATION)
		contaminate()

	//Anything else requires them to not be dead.
	if(stat != DEAD)
		return

	//Burn skin if exposed.
	if(global.vsc.plc.SKIN_BURNS)
		if(!pl_head_protected() || !pl_suit_protected())
			burn_skin(0.75)
			if(prob(20))
				to_chat(src, SPAN_WARNING("Your skin burns!"))
			updatehealth()

	//Burn eyes if exposed.
	if(global.vsc.plc.EYE_BURNS)
		if(isnull(head))
			if(isnull(wear_mask))
				burn_eyes()
			else
				if(!HAS_ITEM_FLAGS(wear_mask, ITEM_FLAG_COVERS_EYES))
					burn_eyes()
		else
			if(!HAS_ITEM_FLAGS(head, ITEM_FLAG_COVERS_EYES))
				if(isnull(wear_mask))
					burn_eyes()
				else
					if(!HAS_ITEM_FLAGS(wear_mask, ITEM_FLAG_COVERS_EYES))
						burn_eyes()

	//Genetic Corruption
	if(global.vsc.plc.GENETIC_CORRUPTION)
		if(rand(1, 10000) < global.vsc.plc.GENETIC_CORRUPTION)
			randmutb(src)
			to_chat(src, SPAN_WARNING("High levels of toxins cause you to spontaneously mutate."))
			domutcheck(src, null)

/mob/living/carbon/human/proc/burn_eyes()
	//The proc that handles eye burning.
	if(prob(20))
		to_chat(src, SPAN_WARNING("Your eyes burn!"))
	var/datum/organ/internal/eyes/E = internal_organs["eyes"]
	E.damage += 2.5
	eye_blurry = min(eye_blurry + 1.5, 50)
	if(prob(max(0, E.damage - 15) + 1) && !eye_blind)
		to_chat(src, SPAN_WARNING("You are blinded!"))
		eye_blind += 20

/mob/living/carbon/human/proc/pl_head_protected()
	//Checks if the head is adequately sealed.
	if(isnotnull(head))
		if(global.vsc.plc.PLASMAGUARD_ONLY)
			if(HAS_ITEM_FLAGS(head, ITEM_FLAG_PLASMAGUARD))
				return TRUE
		else if(HAS_ITEM_FLAGS(head, ITEM_FLAG_COVERS_EYES))
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/pl_suit_protected()
	//Checks if the suit is adequately sealed.
	if(isnotnull(wear_suit))
		if(global.vsc.plc.PLASMAGUARD_ONLY)
			if(HAS_ITEM_FLAGS(wear_suit, ITEM_FLAG_PLASMAGUARD))
				return TRUE
		else
			if(HAS_INV_FLAGS(wear_suit, INV_FLAG_HIDE_JUMPSUIT))
				return TRUE
		//should check INV_FLAG_HIDE_TAIL as well, but for the moment tails are not a part that can be damaged separately
	return FALSE

/mob/living/carbon/human/proc/suit_contamination()
	//Runs over the things that can be contaminated and does so.
	wear_uniform?.contaminate()
	shoes?.contaminate()
	gloves?.contaminate()

/turf/Entered(obj/item/I)
	. = ..()
	//Items that are in plasma, but not on a mob, can still be contaminated.
	if(istype(I) && global.vsc.plc.CLOTH_CONTAMINATION && I.can_contaminate())
		var/datum/gas_mixture/env = return_air(1)
		if(isnull(env))
			return

		var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
		for(var/g in env.gas)
			if(gas_data.flags[g] & XGM_GAS_CONTAMINANT && env.gas[g] > gas_data.overlay_limit[g] + 1)
				I.contaminate()
				break