//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
//						FACE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/face
	priority = 2
	can_infect = 0
	
/datum/surgery_step/face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return 0
	return target_zone == "mouth"


/datum/surgery_step/generic/cut_face
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/kitchenknife = 75,
		/obj/item/shard = 50,
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/cut_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == "mouth" && target.op_stage.face == 0

/datum/surgery_step/generic/cut_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] starts to cut open [target]'s face and neck with \the [tool].",
		"You start to cut open [target]'s face and neck with \the [tool]."
	)
	..()

/datum/surgery_step/generic/cut_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] has cut open [target]'s face and neck with \the [tool]."),
		SPAN_INFO("You have cut open [target]'s face and neck with \the [tool].")
	)
	target.op_stage.face = 1

/datum/surgery_step/generic/cut_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, slicing [target]'s throat wth \the [tool]!"),
		SPAN_WARNING("Your hand slips, slicing [target]'s throat wth \the [tool]!")
	)
	affected.createwound(CUT, 60)
	target.losebreath += 10


/datum/surgery_step/face/mend_vocal
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/device/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 70
	max_duration = 90

/datum/surgery_step/face/mend_vocal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face == 1

/datum/surgery_step/face/mend_vocal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] starts mending [target]'s vocal cords with \the [tool].",
		"You start mending [target]'s vocal cords with \the [tool]."
	)
	..()

/datum/surgery_step/face/mend_vocal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] mends [target]'s vocal cords with \the [tool]."),
		SPAN_INFO("You mend [target]'s vocal cords with \the [tool].")
	)
	target.op_stage.face = 2

/datum/surgery_step/face/mend_vocal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, clamping [target]'s trachea shut for a moment with \the [tool]!"),
		SPAN_WARNING("Your hand slips, clamping [user]'s trachea shut for a moment with \the [tool]!")
	)
	target.losebreath += 10


/datum/surgery_step/face/fix_face
	allowed_tools = list(
		/obj/item/retractor = 100,
		/obj/item/crowbar = 55,
		/obj/item/kitchen/utensil/fork = 75
	)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/face/fix_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face == 2

/datum/surgery_step/face/fix_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] starts pulling the skin on [target]'s face back in place with \the [tool].",
		"You start pulling the skin on [target]'s face back in place with \the [tool]."
	)
	..()

/datum/surgery_step/face/fix_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] pulls the skin on [target]'s face back in place with \the [tool]."),
		SPAN_INFO("You pull the skin on [target]'s face back in place with \the [tool].")
	)
	target.op_stage.face = 3

/datum/surgery_step/face/fix_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, tearing skin on [target]'s face with \the [tool]!"),
		SPAN_WARNING("Your hand slips, tearing skin on [target]'s face with \the [tool]!")
	)
	target.apply_damage(10, BRUTE, affected, sharp = 1)


/datum/surgery_step/face/cauterize
	allowed_tools = list(
		/obj/item/cautery = 100,
		/obj/item/clothing/mask/cigarette = 75,
		/obj/item/lighter = 50,
		/obj/item/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/face/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face > 0

/datum/surgery_step/face/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] is beginning to cauterize the incision on [target]'s face and neck with \the [tool].",
		"You are beginning to cauterize the incision on [target]'s face and neck with \the [tool]."
	)
	..()

/datum/surgery_step/face/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] cauterizes the incision on [target]'s face and neck with \the [tool]."),
		SPAN_INFO("You cauterize the incision on [target]'s face and neck with \the [tool].")
	)
	affected.open = 0
	affected.status &= ~ORGAN_BLEEDING
	if(target.op_stage.face == 3)
		var/datum/organ/external/head/h = affected
		h.disfigured = 0
	target.op_stage.face = 0

/datum/surgery_step/face/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, leaving a small burn on [target]'s face with \the [tool]!"),
		SPAN_WARNING("Your hand slips, leaving a small burn on [target]'s face with \the [tool]!")
	)
	target.apply_damage(4, BURN, affected)