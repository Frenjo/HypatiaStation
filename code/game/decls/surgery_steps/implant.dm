// Procedures in this file: Putting items in body cavity. Implant removal. Items removal.
//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/cavity
	priority = 1

/decl/surgery_step/cavity/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return affected.open == 2 && !(affected.status & ORGAN_BLEEDING) && (target_zone != "chest" || target.op_stage.ribcage == 2)

/decl/surgery_step/cavity/proc/get_max_wclass(datum/organ/external/affected)
	switch(affected.name)
		if("head")
			return 1
		if("chest")
			return 3
		if("groin")
			return 2
	return 0

/decl/surgery_step/cavity/proc/get_cavity(datum/organ/external/affected)
	switch (affected.name)
		if("head")
			return "cranial"
		if("chest")
			return "thoracic"
		if("groin")
			return "abdominal"
	return ""


/decl/surgery_step/cavity/make_space
	allowed_tools = list(
		/obj/item/surgicaldrill = 100,
		/obj/item/pen = 75,
		/obj/item/stack/rods = 50
	)

	min_duration = 60
	max_duration = 80

/decl/surgery_step/cavity/make_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && !affected.cavity && !affected.hidden

/decl/surgery_step/cavity/make_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] starts making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool]."),
		SPAN_INFO("You start making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].")
	)
	target.custom_pain("The pain in your chest is living hell!",1)
	affected.cavity = 1
	..()

/decl/surgery_step/cavity/make_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] makes some space inside [target]'s [get_cavity(affected)] cavity with \the [tool]."),
		SPAN_INFO_B("You make some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].")
	)

/decl/surgery_step/cavity/make_space/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside [target]'s [affected.display_name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, scraping tissue inside [target]'s [affected.display_name] with \the [tool]!")
	)
	affected.createwound(CUT, 20)


/decl/surgery_step/cavity/close_space
	priority = 2
	allowed_tools = list(
		/obj/item/cautery = 100,
		/obj/item/clothing/mask/cigarette = 75,
		/obj/item/lighter = 50,
		/obj/item/weldingtool = 25
	)

	min_duration = 60
	max_duration = 80

/decl/surgery_step/cavity/close_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.cavity

/decl/surgery_step/cavity/close_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] starts mending [target]'s [get_cavity(affected)] cavity wall with \the [tool]."),
		SPAN_INFO("You start mending [target]'s [get_cavity(affected)] cavity wall with \the [tool].")
	)
	target.custom_pain("The pain in your chest is living hell!",1)
	affected.cavity = 0
	..()

/decl/surgery_step/cavity/close_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] mends [target]'s [get_cavity(affected)] cavity walls with \the [tool]."),
		SPAN_INFO_B("You mend [target]'s [get_cavity(affected)] cavity walls with \the [tool].")
	)

/decl/surgery_step/cavity/close_space/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside [target]'s [affected.display_name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, scraping tissue inside [target]'s [affected.display_name] with \the [tool]!")
	)
	affected.createwound(CUT, 20)


/decl/surgery_step/cavity/place_item
	priority = 0
	allowed_tools = list(/obj/item = 100)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/cavity/place_item/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(isslime(target))
		return 0
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return !issilicon(user) && !affected.hidden && affected.cavity && tool.w_class <= get_max_wclass(affected)

/decl/surgery_step/cavity/place_item/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] starts putting \the [tool] inside [target]'s [get_cavity(affected)] cavity."),
		SPAN_INFO("You start putting \the [tool] inside [target]'s [get_cavity(affected)] cavity.")
	)
	target.custom_pain("The pain in your chest is living hell!",1)
	..()

/decl/surgery_step/cavity/place_item/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] puts \the [tool] inside [target]'s [get_cavity(affected)] cavity."),
		SPAN_INFO_B("You put \the [tool] inside [target]'s [get_cavity(affected)] cavity.")
	)
	if(tool.w_class > get_max_wclass(affected) / 2 && prob(50))
		to_chat(user, SPAN_WARNING("You tear some blood vessels trying to fit such a big object in this cavity."))
		var/datum/wound/internal_bleeding/I = new(15)
		affected.wounds += I
		affected.owner.custom_pain("You feel something rip in your [affected.display_name]!", 1)
	user.drop_item()
	affected.hidden = tool
	tool.forceMove(target)
	affected.cavity = 0

/decl/surgery_step/cavity/place_item/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside [target]'s [affected.display_name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, scraping tissue inside [target]'s [affected.display_name] with \the [tool]!")
	)
	affected.createwound(CUT, 20)

//////////////////////////////////////////////////////////////////
//					IMPLANT/ITEM REMOVAL SURGERY						//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/cavity/implant_removal
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/wirecutters = 75,
		/obj/item/kitchen/utensil/fork = 20
	)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/cavity/implant_removal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] starts poking around inside the incision on [target]'s [affected.display_name] with \the [tool]."),
		SPAN_INFO("You start poking around inside the incision on [target]'s [affected.display_name] with \the [tool].")
	)
	target.custom_pain("The pain in your chest is living hell!", 1)
	..()

/decl/surgery_step/cavity/implant_removal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/chest/affected = target.get_organ(target_zone)

	var/find_prob = 0
	if(length(affected.implants))
		var/obj/item/obj = affected.implants[1]
		if(istype(obj, /obj/item/implant))
			var/obj/item/implant/imp = obj
			if(imp.islegal())
				find_prob += 60
			else
				find_prob += 40
		else
			find_prob += 50

		if(prob(find_prob))
			user.visible_message(
				SPAN_INFO_B("[user] takes something out of incision on [target]'s [affected.display_name] with \the [tool]."),
				SPAN_INFO_B("You take [obj] out of incision on [target]'s [affected.display_name]s with \the [tool].")
			)
			affected.implants -= obj

			BITSET(target.hud_updateflag, IMPLOYAL_HUD)

			//Handle possessive brain borers.
			if(istype(obj, /mob/living/simple/borer))
				var/mob/living/simple/borer/worm = obj
				if(worm.controlling)
					target.release_control()
				worm.detatch()

			obj.forceMove(GET_TURF(target))
			if(istype(obj, /obj/item/implant))
				var/obj/item/implant/imp = obj
				imp.imp_in = null
				imp.implanted = 0
		else
			user.visible_message(
				SPAN_INFO_B("[user] removes \the [tool] from [target]'s [affected.display_name]."),
				SPAN_INFO_B("There's something inside [target]'s [affected.display_name], but you just missed it this time.")
			)
	else if(affected.hidden)
		user.visible_message(
			SPAN_INFO_B("[user] takes something out of incision on [target]'s [affected.display_name] with \the [tool]."),
			SPAN_INFO_B("You take something out of incision on [target]'s [affected.display_name]s with \the [tool].")
		)
		affected.hidden.forceMove(GET_TURF(target))
		if(!affected.hidden.blood_DNA)
			affected.hidden.blood_DNA = list()
		affected.hidden.blood_DNA[target.dna.unique_enzymes] = target.dna.b_type
		affected.hidden.update_icon()
		affected.hidden = null

	else
		user.visible_message(
			SPAN_INFO_B("[user] could not find anything inside [target]'s [affected.display_name], and pulls \the [tool] out."),
			SPAN_INFO_B("You could not find anything inside [target]'s [affected.display_name].")
		)

/decl/surgery_step/cavity/implant_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside [target]'s [affected.display_name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, scraping tissue inside [target]'s [affected.display_name] with \the [tool]!")
	)
	affected.createwound(CUT, 20)
	if(length(affected.implants))
		var/fail_prob = 10
		fail_prob += 100 - tool_quality(tool)
		if(prob(fail_prob))
			var/obj/item/implant/imp = affected.implants[1]
			user.visible_message(SPAN_WARNING("Something beeps inside [target]'s [affected.display_name]!"))
			playsound(imp.loc, 'sound/items/countdown.ogg', 75, 1, -3)
			spawn(25)
				imp.activate()