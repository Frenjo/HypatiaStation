/obj/machinery/processor
	name = "food processor"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "processor"
	layer = 2.9
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 5,
		USE_POWER_ACTIVE = 50
	)

	var/broken = 0
	var/processing = 0

/datum/food_processor_process
	var/input
	var/output
	var/time = 40

/datum/food_processor_process/proc/process(loc, what)
	if(src.output && loc)
		new src.output(loc)
	if(what)
		qdel(what)

/* objs */
/datum/food_processor_process/meat
	input = /obj/item/reagent_holder/food/snacks/meat
	output = /obj/item/reagent_holder/food/snacks/meatball

/datum/food_processor_process/meat2
	input = /obj/item/syntiflesh
	output = /obj/item/reagent_holder/food/snacks/meatball
/*
/datum/food_processor_process/monkeymeat
	input = /obj/item/reagent_holder/food/snacks/meat/monkey
	output = /obj/item/reagent_holder/food/snacks/meatball

/datum/food_processor_process/humanmeat
	input = /obj/item/reagent_holder/food/snacks/meat/human
	output = /obj/item/reagent_holder/food/snacks/meatball
*/
/datum/food_processor_process/potato
	input = /obj/item/reagent_holder/food/snacks/grown/potato
	output = /obj/item/reagent_holder/food/snacks/rawsticks

/datum/food_processor_process/carrot
	input = /obj/item/reagent_holder/food/snacks/grown/carrot
	output = /obj/item/reagent_holder/food/snacks/carrotfries

/datum/food_processor_process/soybeans
	input = /obj/item/reagent_holder/food/snacks/grown/soybeans
	output = /obj/item/reagent_holder/food/snacks/soydope

/datum/food_processor_process/wheat
	input = /obj/item/reagent_holder/food/snacks/grown/wheat
	output = /obj/item/reagent_holder/food/snacks/flour

/datum/food_processor_process/spaghetti
	input = /obj/item/reagent_holder/food/snacks/flour
	output = /obj/item/reagent_holder/food/snacks/spagetti

/* mobs */
/datum/food_processor_process/mob/process(loc, what)
	..()

/datum/food_processor_process/mob/slime
		input = /mob/living/carbon/slime
		output = /obj/item/reagent_holder/glass/beaker/slime

/datum/food_processor_process/mob/monkey
	input = /mob/living/carbon/monkey
	output = null

/datum/food_processor_process/mob/monkey/process(loc, what)
	var/mob/living/carbon/monkey/O = what
	if(O.client) //grief-proof
		O.forceMove(loc)
		O.visible_message(
			"\blue Suddenly [O] jumps out from the processor!",
			"You jump out from the processor",
			"You hear chimp"
		)
		return
	var/obj/item/reagent_holder/glass/bucket/bucket_of_blood = new(loc)
	var/datum/reagent/blood/B = new()
	B.holder = bucket_of_blood
	B.volume = 70
	//set reagent data
	B.data["donor"] = O

	for(var/datum/disease/D in O.viruses)
		if(D.spread_type != SPECIAL)
			B.data["viruses"] += D.Copy()

	B.data["blood_DNA"] = copytext(O.dna.unique_enzymes, 1, 0)
	if(length(O.resistances))
		B.data["resistances"] = O.resistances.Copy()
	bucket_of_blood.reagents.reagent_list += B
	bucket_of_blood.reagents.update_total()
	bucket_of_blood.on_reagent_change()
	//bucket_of_blood.reagents.handle_reactions() //blood doesn't react
	..()

/obj/machinery/processor/proc/select_recipe(var/X)
	for(var/Type in SUBTYPESOF(/datum/food_processor_process) - /datum/food_processor_process/mob)
		var/datum/food_processor_process/P = new Type()
		if(!istype(X, P.input))
			continue
		return P
	return 0

/obj/machinery/processor/attackby(obj/item/O, mob/user)
	if(src.processing)
		user << "\red The processor is in the process of processing."
		return 1
	if(length(contents)) //TODO: several items at once? several different items?
		user << "\red Something is already in the processing chamber."
		return 1
	var/what = O
	if(istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		what = G.affecting

	var/datum/food_processor_process/P = select_recipe(what)
	if(!P)
		user << "\red That probably won't blend."
		return 1
	user.visible_message(
		"[user] put [what] into [src].",
		"You put the [what] into [src]."
	)
	user.drop_item()
	what:loc = src
	return

/obj/machinery/processor/attack_hand(mob/user)
	if(src.stat != 0) //NOPOWER etc
		return
	if(src.processing)
		user << "\red The processor is in the process of processing."
		return 1
	if(!length(contents))
		user << "\red The processor is empty."
		return 1
	for(var/O in src.contents)
		var/datum/food_processor_process/P = select_recipe(O)
		if(!P)
			log_admin("DEBUG: [O] in processor havent suitable recipe. How do you put it in?") //-rastaf0
			continue
		src.processing = 1
		user.visible_message(
			"\blue [user] turns on \a [src].",
			"You turn on \a [src].",
			"You hear a food processor."
		)
		playsound(src, 'sound/machines/blender.ogg', 50, 1)
		use_power(500)
		sleep(P.time)
		P.process(src.loc, O)
		src.processing = 0
	src.visible_message(
		"\blue \the [src] finished processing.",
		"You hear the food processor stopping/"
	)