//Procedures in this file: Eye mending surgery
//////////////////////////////////////////////////////////////////
//						EYE SURGERY							//
//////////////////////////////////////////////////////////////////

/decl/surgery_step/eye
	priority = 2
	can_infect = 1

/decl/surgery_step/eye/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return 0
	return target_zone == "eyes"


/decl/surgery_step/eye/cut_open
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/kitchenknife = 75,
		/obj/item/shard = 50,
	)

	min_duration = 90
	max_duration = 110

/decl/surgery_step/eye/cut_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..()

/decl/surgery_step/eye/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] starts to separate the corneas on [target]'s eyes with \the [tool].",
		"You start to separate the corneas on [target]'s eyes with \the [tool]."
	)
	..()

/decl/surgery_step/eye/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] has separated the corneas on [target]'s eyes with \the [tool]."),
		SPAN_INFO("You have separated the corneas on [target]'s eyes with \the [tool].")
	)
	target.op_stage.eyes = 1
	target.blinded += 1.5

/decl/surgery_step/eye/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/internal/eyes/eyes = target.internal_organs["eyes"]
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, slicing [target]'s eyes wth \the [tool]!"),
		SPAN_WARNING("Your hand slips, slicing [target]'s eyes wth \the [tool]!")
	)
	affected.createwound(CUT, 10)
	eyes.take_damage(5, 0)


/decl/surgery_step/eye/lift_eyes
	allowed_tools = list(
		/obj/item/retractor = 100,
		/obj/item/kitchen/utensil/fork = 50
	)

	min_duration = 30
	max_duration = 40

/decl/surgery_step/eye/lift_eyes/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.eyes == 1

/decl/surgery_step/eye/lift_eyes/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] starts lifting corneas from [target]'s eyes with \the [tool].",
		"You start lifting corneas from [target]'s eyes with \the [tool]."
	)
	..()

/decl/surgery_step/eye/lift_eyes/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] has lifted the corneas from [target]'s eyes from with \the [tool]."),
		SPAN_INFO("You has lifted the corneas from [target]'s eyes from with \the [tool].")
	)
	target.op_stage.eyes = 2

/decl/surgery_step/eye/lift_eyes/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/internal/eyes/eyes = target.internal_organs["eyes"]
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging [target]'s eyes with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging [target]'s eyes with \the [tool]!")
	)
	target.apply_damage(10, BRUTE, affected)
	eyes.take_damage(5, 0)


/decl/surgery_step/eye/mend_eyes
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/eye/mend_eyes/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.eyes == 2

/decl/surgery_step/eye/mend_eyes/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] starts mending the nerves and lenses in [target]'s eyes with \the [tool].",
		"You start mending the nerves and lenses in [target]'s eyes with the [tool]."
	)
	..()

/decl/surgery_step/eye/mend_eyes/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] mends the nerves and lenses in [target]'s with \the [tool]."),
		SPAN_INFO("You mend the nerves and lenses in [target]'s with \the [tool].")
	)
	target.op_stage.eyes = 3

/decl/surgery_step/eye/mend_eyes/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/internal/eyes/eyes = target.internal_organs["eyes"]
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, stabbing \the [tool] into [target]'s eye!"),
		SPAN_WARNING("Your hand slips, stabbing \the [tool] into [target]'s eye!")
	)
	target.apply_damage(10, BRUTE, affected, sharp = 1)
	eyes.take_damage(5, 0)


/decl/surgery_step/eye/cauterize
	allowed_tools = list(
		/obj/item/cautery = 100,
		/obj/item/clothing/mask/cigarette = 75,
		/obj/item/lighter = 50,
		/obj/item/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/decl/surgery_step/eye/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..()

/decl/surgery_step/eye/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] is beginning to cauterize the incision around [target]'s eyes with \the [tool].",
		"You are beginning to cauterize the incision around [target]'s eyes with \the [tool]."
	)

/decl/surgery_step/eye/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/internal/eyes/eyes = target.internal_organs["eyes"]
	user.visible_message(
		SPAN_INFO("[user] cauterizes the incision around [target]'s eyes with \the [tool]."),
		SPAN_INFO("You cauterize the incision around [target]'s eyes with \the [tool].")
	)
	if(target.op_stage.eyes == 3)
		target.disabilities &= ~NEARSIGHTED
		target.sdisabilities &= ~BLIND
		eyes.damage = 0
	target.op_stage.eyes = 0

/decl/surgery_step/eye/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/internal/eyes/eyes = target.internal_organs["eyes"]
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, searing [target]'s eyes with \the [tool]!"),
		SPAN_WARNING("Your hand slips, searing [target]'s eyes with \the [tool]!")
	)
	target.apply_damage(5, BURN, affected)
	eyes.take_damage(5, 0)