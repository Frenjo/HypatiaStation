/obj/machinery/proc/state(var/msg)
	for(var/mob/O in hearers(src, null))
		O.show_message(SPAN_NOTICE("\icon[src] [msg]"), 2)

///////////////ANTIBODY SCANNER///////////////

/obj/item/antibody_scanner
	name = "antibody scanner"
	desc = "Used to scan living beings for antibodies in their blood."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "health"
	w_class = 2.0
	item_state = "electronic"
	obj_flags = OBJ_FLAG_CONDUCT

/obj/item/antibody_scanner/attack(mob/living/carbon/M, mob/user)
	if(!istype(M))
		to_chat(user, SPAN_NOTICE("Incompatible object, scan aborted."))
		return
	var/mob/living/carbon/C = M
	if(!C.antibodies)
		to_chat(user, SPAN_NOTICE("Unable to detect antibodies."))
		return
	var/code = antigens2string(M.antibodies)
	to_chat(user, SPAN_NOTICE("[src] The antibody scanner displays a cryptic set of data: [code]"))

///////////////VIRUS DISH///////////////

/obj/item/virusdish
	name = "virus containment/growth dish"
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"
	var/datum/disease2/disease/virus2 = null
	var/growth = 0
	var/info = 0
	var/analysed = 0

	reagents = list()

/obj/item/virusdish/random
	name = "virus sample"

/obj/item/virusdish/random/New()
	..()
	src.virus2 = new /datum/disease2/disease
	src.virus2.makerandom()
	growth = rand(5, 50)

/obj/item/virusdish/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/hand_labeler) || istype(I, /obj/item/reagent_holder/syringe))
		return TRUE

	if(prob(50))
		to_chat(user, SPAN_WARNING("\The [src] shatters!"))
		if(virus2.infectionchance > 0)
			for(var/mob/living/carbon/target in view(1, GET_TURF(src)))
				if(!airborne_can_reach(GET_TURF(src), GET_TURF(target)))
					continue
				if(get_infection_chance(target))
					infect_virus2(target, virus2)
		qdel(src)
		return TRUE

	return ..()

/obj/item/virusdish/examine()
	usr << "This is a virus containment dish"
	if(src.info)
		usr << "It has the following information about its contents"
		usr << src.info

///////////////GNA DISK///////////////

/obj/item/diseasedisk
	name = "blank GNA disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0"
	var/datum/disease2/effectholder/effect = null
	var/stage = 1

/obj/item/diseasedisk/premade/New()
	effect = new /datum/disease2/effectholder()
	effect.effect = new /datum/disease2/effect/invisible()
	effect.stage = stage
	. = ..()
	name = "blank GNA disk (stage: [5-stage])"