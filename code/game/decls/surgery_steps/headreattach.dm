//This is an uguu head restoration surgery TOTALLY not yoinked from chinsky's limb reattacher
/decl/surgery_step/head
	can_infect = 0

/decl/surgery_step/head/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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
	return affected.name == "head"


/decl/surgery_step/head/peel
	allowed_tools = list(
		/obj/item/retractor = 100,
		/obj/item/crowbar = 75,
		/obj/item/kitchen/utensil/fork = 50,
	)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/head/peel/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && !(affected.status & ORGAN_CUT_AWAY)

/decl/surgery_step/head/peel/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] starts peeling back tattered flesh where [target]'s head used to be with \the [tool]."),
		SPAN_INFO("You start peeling back tattered flesh where [target]'s head used to be with \the [tool].")
	)
	..()

/decl/surgery_step/head/peel/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] peels back tattered flesh where [target]'s head used to be with \the [tool]."),
		SPAN_INFO_B("You peel back tattered flesh where [target]'s head used to be with \the [tool].")
	)
	affected.status |= ORGAN_CUT_AWAY

/decl/surgery_step/head/peel/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message(
			SPAN_WARNING("[user]'s hand slips, ripping [target]'s [affected.display_name] open!"),
			SPAN_WARNING("Your hand slips, ripping [target]'s [affected.display_name] open!")
		)
		affected.createwound(CUT, 10)


/decl/surgery_step/head/shape
	allowed_tools = list(
		/obj/item/FixOVein = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/assembly/mousetrap = 10
	) //ok chinsky

	min_duration = 80
	max_duration = 100

/decl/surgery_step/head/shape/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.status & ORGAN_CUT_AWAY && affected.open < 3 && !(affected.status & ORGAN_ATTACHABLE)

/decl/surgery_step/head/shape/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] is beginning to reshape [target]'s esophagal and vocal region with \the [tool]."),
		SPAN_INFO("You start to reshape [target]'s [affected.display_name] esophagal and vocal region with \the [tool].")
	)
	..()

/decl/surgery_step/head/shape/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] finishes repositioning flesh and tissue to something anatomically recognizable where [target]'s head used to be with \the [tool]."),
		SPAN_INFO_B("You finish repositioning flesh and tissue to something anatomically recognizable where [target]'s head used to be with \the [tool].")
	)
	affected.open = 3

/decl/surgery_step/head/shape/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message(
			SPAN_WARNING("[user]'s hand slips, further rending flesh on [target]'s neck!"),
			SPAN_WARNING("Your hand slips, further rending flesh on [target]'s neck!")
		)
		target.apply_damage(10, BRUTE, affected)


/decl/surgery_step/head/suture
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/stack/cable_coil = 60,
		/obj/item/FixOVein = 80
	)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/head/suture/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open == 3

/decl/surgery_step/head/suture/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] begins stapling and suturing flesh into place in [target]'s esophagal and vocal region with \the [tool]."),
		SPAN_INFO("You begin to staple and suture flesh into place in [target]'s esophagal and vocal region with \the [tool].")
	)
	..()

/decl/surgery_step/head/suture/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] finishes stapling [target]'s neck into place with \the [tool]."),
		SPAN_INFO_B("You finish stapling [target]'s neck into place with \the [tool].")
	)
	affected.open = 4

/decl/surgery_step/head/suture/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message(
			SPAN_WARNING("[user]'s hand slips, ripping apart flesh on [target]'s neck!"),
			SPAN_WARNING("Your hand slips, ripping apart flesh on [target]'s neck!")
		)
		target.apply_damage(10, BRUTE, affected, sharp = 1)


/decl/surgery_step/head/prepare
	allowed_tools = list(
		/obj/item/cautery = 100,
		/obj/item/clothing/mask/cigarette = 75,
		/obj/item/lighter = 50,
		/obj/item/weldingtool = 25
	)

	min_duration = 60
	max_duration = 70

/decl/surgery_step/head/prepare/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open == 4

/decl/surgery_step/head/prepare/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] starts adjusting area around [target]'s neck with \the [tool]."),
		SPAN_INFO("You start adjusting area around [target]'s neck with \the [tool].")
	)
	..()

/decl/surgery_step/head/prepare/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] finishes adjusting the area around [target]'s neck with \the [tool]."),
		SPAN_INFO_B("You finish adjusting the area around [target]'s neck with \the [tool].")
	)
	affected.status |= ORGAN_ATTACHABLE
	affected.amputated = 1
	affected.setAmputatedTree()
	affected.open = 0

/decl/surgery_step/head/prepare/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected.parent)
		affected = affected.parent
		user.visible_message(
			SPAN_WARNING("[user]'s hand slips, searing [target]'s neck!"),
			SPAN_WARNING("Your hand slips, searing [target]'s [affected.display_name]!")
		)
		target.apply_damage(10, BURN, affected)


/decl/surgery_step/head/attach
	allowed_tools = list(/obj/item/organ/head = 100)
	can_infect = 0

	min_duration = 80
	max_duration = 100

/decl/surgery_step/head/attach/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/head = target.get_organ(target_zone)
	return ..() && head.status & ORGAN_ATTACHABLE

/decl/surgery_step/head/attach/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] starts attaching [tool] to [target]'s reshaped neck."),
		SPAN_INFO("You start attaching [tool] to [target]'s reshaped neck.")
	)

/decl/surgery_step/head/attach/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO_B("[user] attaches [target]'s head to the body."),
		SPAN_INFO_B("You attach [target]'s head to the body.")
	)
	affected.status = 0
	affected.amputated = 0
	affected.destspawn = 0
	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()
	var/obj/item/organ/head/B = tool
	if(B.brainmob.mind)
		B.brainmob.mind.transfer_to(target)
	qdel(B)

/decl/surgery_step/head/attach/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging connectors on [target]'s neck!"),
		SPAN_WARNING("Your hand slips, damaging connectors on [target]'s neck!")
	)
	target.apply_damage(10, BRUTE, affected)