//Procedures in this file: Robotic limbs attachment
//////////////////////////////////////////////////////////////////
//						LIMB SURGERY							//
//////////////////////////////////////////////////////////////////

/decl/surgery_step/limb
	can_infect = 0

/decl/surgery_step/limb/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return 0
	if(!(affected.status & ORGAN_DESTROYED))
		return 0
	if(affected.parent)
		if(affected.parent.status & ORGAN_DESTROYED)
			return 0
	return affected.name != "head"


/decl/surgery_step/limb/cut
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/kitchenknife = 75,
		/obj/item/shard = 50,
	)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/limb/cut/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && !(affected.status & ORGAN_CUT_AWAY)

/decl/surgery_step/limb/cut/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts cutting away flesh where [target]'s [affected.display_name] used to be with \the [tool].",
		"You start cutting away flesh where [target]'s [affected.display_name] used to be with \the [tool]."
	)
	..()

/decl/surgery_step/limb/cut/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] cuts away flesh where [target]'s [affected.display_name] used to be with \the [tool]."),
		SPAN_INFO("You cut away flesh where [target]'s [affected.display_name] used to be with \the [tool].")
	)
	affected.status |= ORGAN_CUT_AWAY

/decl/surgery_step/limb/cut/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message(
			SPAN_WARNING("[user]'s hand slips, cutting [target]'s [affected.display_name] open!"),
			SPAN_WARNING("Your hand slips, cutting [target]'s [affected.display_name] open!")
		)
		affected.createwound(CUT, 10)


/decl/surgery_step/limb/mend
	allowed_tools = list(
		/obj/item/retractor = 100,
		/obj/item/crowbar = 75,
		/obj/item/kitchen/utensil/fork = 50
	)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/limb/mend/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.status & ORGAN_CUT_AWAY && affected.open < 3 && !(affected.status & ORGAN_ATTACHABLE)

/decl/surgery_step/limb/mend/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] is beginning to reposition flesh and nerve endings where where [target]'s [affected.display_name] used to be with [tool].",
		"You start repositioning flesh and nerve endings where [target]'s [affected.display_name] used to be with [tool]."
	)
	..()

/decl/surgery_step/limb/mend/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] has finished repositioning flesh and nerve endings where [target]'s [affected.display_name] used to be with [tool]."),
		SPAN_INFO("You have finished repositioning flesh and nerve endings where [target]'s [affected.display_name] used to be with [tool].")
	)
	affected.open = 3

/decl/surgery_step/limb/mend/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message(
			SPAN_WARNING("[user]'s hand slips, tearing flesh on [target]'s [affected.display_name]!"),
			SPAN_WARNING("Your hand slips, tearing flesh on [target]'s [affected.display_name]!")
		)
		target.apply_damage(10, BRUTE, affected, sharp = 1)


/decl/surgery_step/limb/prepare
	allowed_tools = list(
		/obj/item/cautery = 100,
		/obj/item/clothing/mask/cigarette = 75,
		/obj/item/lighter = 50,
		/obj/item/weldingtool = 25
	)

	min_duration = 60
	max_duration = 70

/decl/surgery_step/limb/prepare/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open == 3

/decl/surgery_step/limb/prepare/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts adjusting the area around [target]'s [affected.display_name] with \the [tool].",
		"You start adjusting the area around [target]'s [affected.display_name] with \the [tool]."
	)
	..()

/decl/surgery_step/limb/prepare/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] has finished adjusting the area around [target]'s [affected.display_name] with \the [tool]."),
		SPAN_INFO("You have finished adjusting the area around [target]'s [affected.display_name] with \the [tool].")
	)
	affected.status |= ORGAN_ATTACHABLE
	affected.amputated = 1
	affected.setAmputatedTree()
	affected.open = 0

/decl/surgery_step/limb/prepare/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message(
			SPAN_WARNING("[user]'s hand slips, searing [target]'s [affected.display_name]!"),
			SPAN_WARNING("Your hand slips, searing [target]'s [affected.display_name]!")
		)
		target.apply_damage(10, BRUTE, affected, sharp = 1)


/decl/surgery_step/limb/attach
	allowed_tools = list(/obj/item/robot_parts = 100)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/limb/attach/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/robot_parts/p = tool
	if(p.part)
		if(!(target_zone in p.part))
			return 0
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.status & ORGAN_ATTACHABLE

/decl/surgery_step/limb/attach/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts attaching \the [tool] where [target]'s [affected.display_name] used to be.",
		"You start attaching \the [tool] where [target]'s [affected.display_name] used to be."
	)

/decl/surgery_step/limb/attach/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/robot_parts/L = tool
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] has attached \the [tool] where [target]'s [affected.display_name] used to be."),
		SPAN_INFO("You have attached \the [tool] where [target]'s [affected.display_name] used to be.")
	)
	affected.germ_level = 0
	affected.robotize()
	if(L.sabotaged)
		affected.sabotaged = 1
	else
		affected.sabotaged = 0
	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()
	qdel(tool)

/decl/surgery_step/limb/attach/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging connectors on [target]'s [affected.display_name]!"),
		SPAN_WARNING("Your hand slips, damaging connectors on [target]'s [affected.display_name]!")
	)
	target.apply_damage(10, BRUTE, affected)