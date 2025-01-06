// Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/glue_bone
	allowed_tools = list(
		/obj/item/bonegel = 100,
		/obj/item/screwdriver = 75
	)
	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/decl/surgery_step/glue_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return affected.open == 2 && affected.stage == 0

/decl/surgery_step/glue_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.stage == 0)
		user.visible_message(
			SPAN_INFO("[user] starts applying medication to the damaged bones in [target]'s [affected.display_name] with \the [tool]."),
			SPAN_INFO("You start applying medication to the damaged bones in [target]'s [affected.display_name] with \the [tool].")
		)
	target.custom_pain("Something in your [affected.display_name] is causing you a lot of pain!",1)
	..()

/decl/surgery_step/glue_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] applies some [tool] to [target]'s bone in [affected.display_name]"),
		SPAN_INFO_B("You apply some [tool] to [target]'s bone in [affected.display_name].")
	)
	affected.stage = 1

/decl/surgery_step/glue_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.display_name]!"),
		SPAN_WARNING("Your hand slips, smearing [tool] in the incision in [target]'s [affected.display_name]!")
	)


/decl/surgery_step/set_bone
	allowed_tools = list(
		/obj/item/bonesetter = 100,
		/obj/item/wrench = 75
	)

	min_duration = 60
	max_duration = 70

/decl/surgery_step/set_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return affected.name != "head" && affected.open == 2 && affected.stage == 1

/decl/surgery_step/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] begins to set the bone in [target]'s [affected.display_name] in place with \the [tool]."),
		SPAN_INFO("You begin to set the bone in [target]'s [affected.display_name] in place with \the [tool].")
	)
	target.custom_pain("The pain in your [affected.display_name] is going to make you pass out!",1)
	..()

/decl/surgery_step/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	var/msg = SPAN_INFO_B("[user] sets the bone in [target]'s [affected.display_name]")
	var/self_msg = SPAN_INFO_B("You set the bone in [target]'s [affected.display_name]")
	var/ending = null
	if(affected.status & ORGAN_BROKEN)
		ending = SPAN_INFO_B(" in place with \the [tool].")
		affected.stage = 2
	else
		ending = SPAN_DANGER(" in the WRONG place ") + SPAN_INFO_B("with \the [tool].")
		affected.fracture()
	user.visible_message(
		msg + ending,
		self_msg + ending
	)

/decl/surgery_step/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging the bone in [target]'s [affected.display_name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging the bone in [target]'s [affected.display_name] with \the [tool]!")
	)
	affected.createwound(BRUISE, 5)


/decl/surgery_step/mend_skull
	allowed_tools = list(
		/obj/item/bonesetter = 100,
		/obj/item/wrench = 75
	)

	min_duration = 60
	max_duration = 70

/decl/surgery_step/mend_skull/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return affected.name == "head" && affected.open == 2 && affected.stage == 1

/decl/surgery_step/mend_skull/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] begins to piece together [target]'s skull with \the [tool]."),
		SPAN_INFO("You begin to piece together [target]'s skull with \the [tool].")
	)
	..()

/decl/surgery_step/mend_skull/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] sets [target]'s skull with \the [tool]."),
		SPAN_INFO_B("You set [target]'s skull with \the [tool].")
	)
	affected.stage = 2

/decl/surgery_step/mend_skull/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging [target]'s face with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging [target]'s face with \the [tool]!")
	)
	var/datum/organ/external/head/h = affected
	h.createwound(BRUISE, 10)
	h.disfigured = 1


/decl/surgery_step/finish_bone
	allowed_tools = list(
		/obj/item/bonegel = 100,
		/obj/item/screwdriver = 75
	)
	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/decl/surgery_step/finish_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		return affected.open == 2 && affected.stage == 2

/decl/surgery_step/finish_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		user.visible_message(
			SPAN_INFO("[user] starts to finish mending the damaged bones in [target]'s [affected.display_name] with \the [tool]."),
			SPAN_INFO("You start to finish mending the damaged bones in [target]'s [affected.display_name] with \the [tool].")
		)
		..()

/decl/surgery_step/finish_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] mends the damaged bones in [target]'s [affected.display_name] with \the [tool]."),
		SPAN_INFO_B("You mends the damaged bones in [target]'s [affected.display_name] with \the [tool].")
	)
	affected.status &= ~ORGAN_BROKEN
	affected.status &= ~ORGAN_SPLINTED
	affected.stage = 0
	affected.perma_injury = 0

/decl/surgery_step/finish_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.display_name]!"),
		SPAN_WARNING("Your hand slips, smearing [tool] in the incision in [target]'s [affected.display_name]!")
	)