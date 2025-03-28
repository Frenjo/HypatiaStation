// Procedures in this file: Appendectomy
//////////////////////////////////////////////////////////////////
//						APPENDECTOMY							//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/appendectomy
	priority = 2
	can_infect = 1
	blood_level = 1

/decl/surgery_step/appendectomy/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(target_zone != "groin")
		return 0
	var/datum/organ/external/groin = target.get_organ("groin")
	if(!groin)
		return 0
	if(groin.open < 2)
		return 0
	return 1


/decl/surgery_step/appendectomy/cut_appendix
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/kitchenknife = 75,
		/obj/item/shard = 50,
	)

	min_duration = 70
	max_duration = 90

/decl/surgery_step/appendectomy/cut_appendix/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.appendix == 0

/decl/surgery_step/appendectomy/cut_appendix/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] starts to separate [target]'s appendix from the abdominal wall with \the [tool]."),
		SPAN_INFO("You start to separate [target]'s appendix from the abdominal wall with \the [tool].")
	)
	target.custom_pain("The pain in your abdomen is living hell!", 1)
	..()

/decl/surgery_step/appendectomy/cut_appendix/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO_B("[user] separates [target]'s appendix with \the [tool]."),
		SPAN_INFO_B("You separate [target]'s appendix with \the [tool].")
	)
	target.op_stage.appendix = 1

/decl/surgery_step/appendectomy/cut_appendix/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/groin = target.get_organ("groin")
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, slicing an artery inside [target]'s abdomen with \the [tool]!"),
		SPAN_WARNING("Your hand slips, slicing an artery inside [target]'s abdomen with \the [tool]!")
	)
	groin.createwound(CUT, 50, 1)


/decl/surgery_step/appendectomy/remove_appendix
	allowed_tools = list(
		/obj/item/hemostat = 100,
		/obj/item/wirecutters = 75,
		/obj/item/kitchen/utensil/fork = 20
	)

	min_duration = 60
	max_duration = 80

/decl/surgery_step/appendectomy/remove_appendix/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.appendix == 1

/decl/surgery_step/appendectomy/remove_appendix/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO("[user] starts removing [target]'s appendix with \the [tool]."),
		SPAN_INFO("You start removing [target]'s appendix with \the [tool].")
	)
	target.custom_pain("Someone's ripping out your bowels!",1)
	..()

/decl/surgery_step/appendectomy/remove_appendix/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_INFO_B("[user] removes [target]'s appendix with \the [tool]."),
		SPAN_INFO_B("You removes [target]'s appendix with \the [tool].")
	)
	var/app = 0
	for(var/datum/disease/appendicitis/appendicitis in target.viruses)
		app = 1
		appendicitis.cure()
		target.resistances += appendicitis
	if(app)
		new /obj/item/reagent_holder/food/snacks/appendix/inflamed(GET_TURF(target))
	else
		new /obj/item/reagent_holder/food/snacks/appendix(GET_TURF(target))
	target.op_stage.appendix = 2

/decl/surgery_step/appendectomy/remove_appendix/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/datum/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, nicking internal organs in [target]'s abdomen with \the [tool]!"),
		SPAN_WARNING("Your hand slips, nicking internal organs in [target]'s abdomen with \the [tool]!")
	)
	affected.createwound(BRUISE, 20)