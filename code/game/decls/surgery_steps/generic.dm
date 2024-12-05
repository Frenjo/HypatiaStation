// Procedures in this file: Generic surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic
	can_infect = 1

/decl/surgery_step/generic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(isslime(target))
		return 0
	if(target_zone == "eyes")	//there are specific steps for eye surgery
		return 0
	if(!hasorgans(target))
		return 0
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected == null)
		return 0
	if(affected.status & ORGAN_DESTROYED)
		return 0
	if(target_zone == "head" && isnotnull(target.species) && HAS_SPECIES_FLAGS(target.species, SPECIES_FLAG_IS_SYNTHETIC))
		return 1
	if(affected.status & ORGAN_ROBOT)
		return 0
	return 1


/decl/surgery_step/generic/cut_with_laser
	allowed_tools = list(
		/obj/item/scalpel/laser3 = 95,
		/obj/item/scalpel/laser2 = 85,
		/obj/item/scalpel/laser1 = 75,
		/obj/item/melee/energy/sword = 5
	)

	min_duration = 90
	max_duration = 110

/decl/surgery_step/generic/cut_with_laser/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open == 0 && target_zone != "mouth"

/decl/surgery_step/generic/cut_with_laser/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts the bloodless incision on [target]'s [affected.display_name] with \the [tool].",
		"You start the bloodless incision on [target]'s [affected.display_name] with \the [tool]."
	)
	target.custom_pain("You feel a horrible, searing pain in your [affected.display_name]!", 1)
	..()

/decl/surgery_step/generic/cut_with_laser/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] has made a bloodless incision on [target]'s [affected.display_name] with \the [tool]."),
		SPAN_INFO("You have made a bloodless incision on [target]'s [affected.display_name] with \the [tool].")
	)
	//Could be cleaner ...
	affected.open = 1
	affected.status |= ORGAN_BLEEDING
	affected.createwound(CUT, 1)
	affected.clamp_bleeding()
	spread_germs_to_organ(affected, user)
	if(target_zone == "head")
		target.brain_op_stage = 1

/decl/surgery_step/generic/cut_with_laser/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.display_name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.display_name] with \the [tool]!")
	)
	affected.createwound(CUT, 7.5)
	affected.createwound(BURN, 12.5)


/decl/surgery_step/generic/incision_manager
	allowed_tools = list(
		/obj/item/scalpel/manager = 100
	)

	min_duration = 80
	max_duration = 120

/decl/surgery_step/generic/incision_manager/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open == 0 && target_zone != "mouth"

/decl/surgery_step/generic/incision_manager/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts to construct a prepared incision on and within [target]'s [affected.display_name] with \the [tool].",
		"You start to construct a prepared incision on and within [target]'s [affected.display_name] with \the [tool]."
	)
	target.custom_pain("You feel a horrible, searing pain in your [affected.display_name] as it is pushed apart!", 1)
	..()

/decl/surgery_step/generic/incision_manager/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] has constructed a prepared incision on and within [target]'s [affected.display_name] with \the [tool]."),
		SPAN_INFO("You have constructed a prepared incision on and within [target]'s [affected.display_name] with \the [tool].")
	)
	affected.open = 1
	affected.status |= ORGAN_BLEEDING
	affected.createwound(CUT, 1)
	affected.clamp_bleeding()
	affected.open = 2
	if(target_zone == "head")
		target.brain_op_stage = 1

/decl/surgery_step/generic/incision_manager/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.display_name] with \the [tool]!"),
		SPAN_WARNING("Your hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.display_name] with \the [tool]!")
	)
	affected.createwound(CUT, 20)
	affected.createwound(BURN, 15)


/decl/surgery_step/generic/cut_open
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/kitchenknife = 75,
		/obj/item/shard = 50,
	)

	min_duration = 90
	max_duration = 110

/decl/surgery_step/generic/cut_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(isslime(target))
		return 0
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open == 0 && target_zone != "mouth"

/decl/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts the incision on [target]'s [affected.display_name] with \the [tool].",
		"You start the incision on [target]'s [affected.display_name] with \the [tool]."
	)
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.display_name]!",1)
	..()

/decl/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] has made an incision on [target]'s [affected.display_name] with \the [tool]."),
		SPAN_INFO("You have made an incision on [target]'s [affected.display_name] with \the [tool].")
	)
	affected.open = 1
	affected.status |= ORGAN_BLEEDING
	affected.createwound(CUT, 1)
	if(target_zone == "head")
		target.brain_op_stage = 1

/decl/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, slicing open [target]'s [affected.display_name] in the wrong place with \the [tool]!"),
		SPAN_WARNING("Your hand slips, slicing open [target]'s [affected.display_name] in the wrong place with \the [tool]!")
	)
	affected.createwound(CUT, 10)


/decl/surgery_step/generic/clamp_bleeders
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/stack/cable_coil = 75,
		/obj/item/assembly/mousetrap = 20
	)

	min_duration = 40
	max_duration = 60

/decl/surgery_step/generic/clamp_bleeders/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open && (affected.status & ORGAN_BLEEDING)

/decl/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts clamping bleeders in [target]'s [affected.display_name] with \the [tool].",
		"You start clamping bleeders in [target]'s [affected.display_name] with \the [tool]."
	)
	target.custom_pain("The pain in your [affected.display_name] is maddening!",1)
	..()

/decl/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] clamps bleeders in [target]'s [affected.display_name] with \the [tool]."),
		SPAN_INFO("You clamp bleeders in [target]'s [affected.display_name] with \the [tool].")
	)
	affected.clamp_bleeding()
	spread_germs_to_organ(affected, user)

/decl/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, tearing blood vessals and causing massive bleeding in [target]'s [affected.display_name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.display_name] with \the [tool]!")
	)
	affected.createwound(CUT, 10)


/decl/surgery_step/generic/retract_skin
	allowed_tools = list(
		/obj/item/retractor = 100,
		/obj/item/crowbar = 75,
		/obj/item/kitchen/utensil/fork = 50
	)

	min_duration = 30
	max_duration = 40

/decl/surgery_step/generic/retract_skin/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open == 1 && !(affected.status & ORGAN_BLEEDING)

/decl/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	var/msg = "[user] starts to pry open the incision on [target]'s [affected.display_name] with \the [tool]."
	var/self_msg = "You start to pry open the incision on [target]'s [affected.display_name] with \the [tool]."
	if(target_zone == "chest")
		msg = "[user] starts to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
		self_msg = "You start to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
	if(target_zone == "groin")
		msg = "[user] starts to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
		self_msg = "You start to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
	user.visible_message(msg, self_msg)
	target.custom_pain("It feels like the skin on your [affected.display_name] is on fire!",1)
	..()

/decl/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	var/msg = "[user] keeps the incision open on [target]'s [affected.display_name] with \the [tool]."
	var/self_msg = "You keep the incision open on [target]'s [affected.display_name] with \the [tool]."
	if(target_zone == "chest")
		msg = "[user] keeps the ribcage open on [target]'s torso with \the [tool]."
		self_msg = "You keep the ribcage open on [target]'s torso with \the [tool]."
	if(target_zone == "groin")
		msg = "[user] keeps the incision open on [target]'s lower abdomen with \the [tool]."
		self_msg = "You keep the incision open on [target]'s lower abdomen with \the [tool]."
	user.visible_message(SPAN_INFO(msg), SPAN_INFO(self_msg))
	affected.open = 2

/decl/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	var/msg = "[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.display_name] with \the [tool]!"
	var/self_msg = "Your hand slips, tearing the edges of the incision on [target]'s [affected.display_name] with \the [tool]!"
	if(target_zone == "chest")
		msg = "[user]'s hand slips, damaging several organs in [target]'s torso with \the [tool]!"
		self_msg = "Your hand slips, damaging several organs in [target]'s torso with \the [tool]!"
	if(target_zone == "groin")
		msg = "[user]'s hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]"
		self_msg = "Your hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!"
	user.visible_message(SPAN_WARNING(msg), SPAN_WARNING(self_msg))
	target.apply_damage(12, BRUTE, affected, sharp = 1)


/decl/surgery_step/generic/cauterize
	allowed_tools = list(
		/obj/item/cautery = 100,
		/obj/item/clothing/mask/cigarette = 75,
		/obj/item/lighter = 50,
		/obj/item/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/decl/surgery_step/generic/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open && target_zone != "mouth"

/decl/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] is beginning to cauterize the incision on [target]'s [affected.display_name] with \the [tool].",
		"You are beginning to cauterize the incision on [target]'s [affected.display_name] with \the [tool]."
	)
	target.custom_pain("Your [affected.display_name] is being burned!",1)
	..()

/decl/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] cauterizes the incision on [target]'s [affected.display_name] with \the [tool]."),
		SPAN_INFO("You cauterize the incision on [target]'s [affected.display_name] with \the [tool].")
	)
	affected.open = 0
	affected.germ_level = 0
	affected.status &= ~ORGAN_BLEEDING

/decl/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, leaving a small burn on [target]'s [affected.display_name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, leaving a small burn on [target]'s [affected.display_name] with \the [tool]!")
	)
	target.apply_damage(3, BURN, affected)


/decl/surgery_step/generic/cut_limb
	allowed_tools = list(
		/obj/item/circular_saw = 100,
		/obj/item/hatchet = 75
	)

	min_duration = 110
	max_duration = 160

/decl/surgery_step/generic/cut_limb/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(target_zone == "eyes")	//there are specific steps for eye surgery
		return 0
	if(!hasorgans(target))
		return 0
	var/datum/organ/external/affected = target.get_organ(target_zone)
	if(affected == null)
		return 0
	if(affected.status & ORGAN_DESTROYED)
		return 0
	return target_zone != "chest" && target_zone != "groin" && target_zone != "head"

/decl/surgery_step/generic/cut_limb/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] is beginning to cut off [target]'s [affected.display_name] with \the [tool].",
		"You are beginning to cut off [target]'s [affected.display_name] with \the [tool]."
	)
	target.custom_pain("Your [affected.display_name] is being ripped apart!", 1)
	..()

/decl/surgery_step/generic/cut_limb/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_INFO("[user] cuts off [target]'s [affected.display_name] with \the [tool]."),
		SPAN_INFO("You cut off [target]'s [affected.display_name] with \the [tool].")
	)
	affected.droplimb(1, 0)

/decl/surgery_step/generic/cut_limb/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, sawwing through the bone in [target]'s [affected.display_name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, sawwing through the bone in [target]'s [affected.display_name] with \the [tool]!")
	)
	affected.createwound(CUT, 30)
	affected.fracture()