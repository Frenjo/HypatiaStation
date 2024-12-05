// Procedures in this file: Slime Core extraction.
//////////////////////////////////////////////////////////////////
//				SLIME CORE EXTRACTION							//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/slime

/decl/surgery_step/slime/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return isslime(target) && target.stat == DEAD


/decl/surgery_step/slime/cut_flesh
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/kitchenknife = 75,
		/obj/item/shard = 50,
	)

	min_duration = 30
	max_duration = 50

/decl/surgery_step/slime/cut_flesh/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && target.brain_op_stage == 0

/decl/surgery_step/slime/cut_flesh/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] starts cutting through [target]'s flesh with \the [tool].",
		"You start cutting through [target]'s flesh with \the [tool]."
	)

/decl/surgery_step/slime/cut_flesh/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] cuts through [target]'s flesh with \the [tool]."),
		SPAN_INFO("You cut through [target]'s flesh with \the [tool], exposing the cores.")
	)
	target.brain_op_stage = 1

/decl/surgery_step/slime/cut_flesh/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, tearing [target]'s flesh with \the [tool]!"),
		SPAN_WARNING("Your hand slips, tearing [target]'s flesh with \the [tool]!")
	)


/decl/surgery_step/slime/cut_innards
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/kitchenknife = 75,
		/obj/item/shard = 50,
	)

	min_duration = 30
	max_duration = 50

/decl/surgery_step/slime/cut_innards/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && target.brain_op_stage == 1

/decl/surgery_step/slime/cut_innards/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] starts cutting [target]'s silky innards apart with \the [tool].",
		"You start cutting [target]'s silky innards apart with \the [tool]."
	)

/decl/surgery_step/slime/cut_innards/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] cuts [target]'s innards apart with \the [tool], exposing the cores."),
		SPAN_INFO("You cut [target]'s innards apart with \the [tool], exposing the cores.")
	)
	target.brain_op_stage = 2

/decl/surgery_step/slime/cut_innards/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, tearing [target]'s innards with \the [tool]!"),
		SPAN_WARNING("Your hand slips, tearing [target]'s innards with \the [tool]!")
	)


/decl/surgery_step/slime/saw_core
	allowed_tools = list(
		/obj/item/circular_saw = 100,
		/obj/item/hatchet = 75
	)

	min_duration = 50
	max_duration = 70

/decl/surgery_step/slime/saw_core/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && target.brain_op_stage == 2 && target.cores > 0

/decl/surgery_step/slime/saw_core/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(
		"[user] starts cutting out one of [target]'s cores with \the [tool].",
		"You start cutting out one of [target]'s cores with \the [tool]."
	)

/decl/surgery_step/slime/saw_core/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	target.cores--
	user.visible_message(
		SPAN_INFO("[user] cuts out one of [target]'s cores with \the [tool]."),
		SPAN_INFO("You cut out one of [target]'s cores with \the [tool]. [target.cores] cores left.")
	)

	if(target.cores >= 0)
		new target.coretype(target.loc)
	if(target.cores <= 0)
		var/origstate = initial(target.icon_state)
		target.icon_state = "[origstate] dead-nocore"


/decl/surgery_step/slime/saw_core/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, causing \him to miss the core!"),
		SPAN_WARNING("Your hand slips, causing you to miss the core!")
	)