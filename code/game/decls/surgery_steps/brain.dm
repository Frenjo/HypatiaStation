// Procedures in this file: Brain extraction. Brain fixing.
//////////////////////////////////////////////////////////////////
//						BRAIN SURGERY							//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/brain
	priority = 2
	blood_level = 1

/decl/surgery_step/brain/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return target_zone == "head" && hasorgans(target)


/decl/surgery_step/brain/saw_skull
	allowed_tools = list(
		/obj/item/circular_saw = 100,
		/obj/item/hatchet = 75
	)

	min_duration = 50
	max_duration = 70

/decl/surgery_step/brain/saw_skull/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == "head" && target.brain_op_stage == 1

/decl/surgery_step/brain/saw_skull/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] begins to cut through [target]'s skull with \the [tool]."),
		SPAN_INFO("You begin to cut through [target]'s skull with \the [tool].")
	)
	..()

/decl/surgery_step/brain/saw_skull/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO_B("[user] cuts [target]'s skull open with \the [tool]."),
		SPAN_INFO_B("You cuts [target]'s skull open with \the [tool].")
	)
	target.brain_op_stage = 2

/decl/surgery_step/brain/saw_skull/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, cracking [target]'s skull with \the [tool]!"),
		SPAN_WARNING("Your hand slips, cracking [target]'s skull with \the [tool]!")
	)
	target.apply_damage(max(10, tool.force), BRUTE, "head")


/decl/surgery_step/brain/cut_brain
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/kitchenknife = 75,
		/obj/item/shard = 50,
	)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/brain/cut_brain/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.brain_op_stage == 2

/decl/surgery_step/brain/cut_brain/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] starts separating connections to [target]'s brain with \the [tool]."),
		SPAN_INFO("You start separating connections to [target]'s brain with \the [tool].")
	)
	..()

/decl/surgery_step/brain/cut_brain/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO_B("[user] separates connections to [target]'s brain with \the [tool]."),
		SPAN_INFO_B("You separate connections to [target]'s brain with \the [tool].")
	)
	target.brain_op_stage = 3

/decl/surgery_step/brain/cut_brain/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, cutting a vein in [target]'s brain with \the [tool]!"),
		SPAN_WARNING("Your hand slips, cutting a vein in [target]'s brain with \the [tool]!")
	)
	target.apply_damage(50, BRUTE, "head", 1, sharp = 1)


/decl/surgery_step/brain/saw_spine
	allowed_tools = list(
		/obj/item/circular_saw = 100,
		/obj/item/hatchet = 75
	)

	min_duration = 50
	max_duration = 70

/decl/surgery_step/brain/saw_spine/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.brain_op_stage == 3

/decl/surgery_step/brain/saw_spine/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] starts separating [target]'s brain from \his spine with \the [tool]."),
		SPAN_INFO("You start separating [target]'s brain from spine with \the [tool].")
	)
	..()

/decl/surgery_step/brain/saw_spine/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO_B("[user] separates [target]'s brain from \his spine with \the [tool]."),
		SPAN_INFO_B("You separate [target]'s brain from spine with \the [tool].")
	)

	var/mob/living/simple/borer/borer = target.has_brain_worms()

	if(borer)
		borer.detatch() //Should remove borer if the brain is removed - RR

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Debrained [target.name] ([target.ckey]) with [tool.name] (INTENT: [uppertext(user.a_intent)])</font>"
	target.attack_log += "\[[time_stamp()]\]<font color='orange'> Debrained by [user.name] ([user.ckey]) with [tool.name] (INTENT: [uppertext(user.a_intent)])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) debrained [target.name] ([target.ckey]) with [tool.name] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	var/mob/living/carbon/human/H
	if(ishuman(target))
		H = target

	var/obj/item/brain/B
	if(isnotnull(H?.species) && HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_SYNTHETIC))
		var/obj/item/mmi/posibrain/P = new(target.loc)
		P.transfer_identity(target)
	else
		B = new(target.loc)
		B.transfer_identity(target)

	target.internal_organs -= B

	target:brain_op_stage = 4.0
	target.death()//You want them to die after the brain was transferred, so not to trigger client death() twice.

/decl/surgery_step/brain/saw_spine/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, cutting a vein in [target]'s brain with \the [tool]!"),
		SPAN_WARNING("Your hand slips, cutting a vein in [target]'s brain with \the [tool]!")
	)
	target.apply_damage(30, BRUTE, "head", 1, sharp = 1)
	if(ishuman(user))
		user:bloody_body(target)
		user:bloody_hands(target, 0)


//////////////////////////////////////////////////////////////////
//				BRAIN DAMAGE FIXING								//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/brain/bone_chips
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/wirecutters = 75,
		/obj/item/kitchen/utensil/fork = 20
	)

	min_duration = 80
	max_duration = 100

/decl/surgery_step/brain/bone_chips/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.brain_op_stage == 2

/decl/surgery_step/brain/bone_chips/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] starts taking bone chips out of [target]'s brain with \the [tool]."),
		SPAN_INFO("You start taking bone chips out of [target]'s brain with \the [tool].")
	)
	..()

/decl/surgery_step/brain/bone_chips/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO_B("[user] takes out all the bone chips in [target]'s brain with \the [tool]."),
		SPAN_INFO_B("You take out all the bone chips in [target]'s brain with \the [tool].")
	)
	target.brain_op_stage = 3

/decl/surgery_step/brain/bone_chips/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, jabbing \the [tool] in [target]'s brain!"),
		SPAN_WARNING("Your hand slips, jabbing \the [tool] in [target]'s brain!")
	)
	target.apply_damage(30, BRUTE, "head", 1, sharp = 1)


/decl/surgery_step/brain/hematoma
	allowed_tools = list(
		/obj/item/FixOVein = 100,
		/obj/item/stack/cable_coil = 75
	)

	min_duration = 90
	max_duration = 110

/decl/surgery_step/brain/hematoma/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.brain_op_stage == 3

/decl/surgery_step/brain/hematoma/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] starts mending hematoma in [target]'s brain with \the [tool]."),
		SPAN_INFO("You start mending hematoma in [target]'s brain with \the [tool].")
	)
	..()

/decl/surgery_step/brain/hematoma/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO_B("[user] mends hematoma in [target]'s brain with \the [tool]."),
		SPAN_INFO_B("You mend hematoma in [target]'s brain with \the [tool].")
	)
	var/datum/organ/internal/brain/sponge = target.internal_organs["brain"]
	if(sponge)
		sponge.damage = 0

/decl/surgery_step/brain/hematoma/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, bruising [target]'s brain with \the [tool]!"),
		SPAN_WARNING("Your hand slips, bruising [target]'s brain with \the [tool]!")
	)
	target.apply_damage(20, BRUTE, "head", 1, sharp = 1)