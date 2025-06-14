////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/reagent_holder/syringe
	name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/items/syringe.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	matter_amounts = /datum/design/autolathe/syringe::materials
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null //list(5,10,15)
	volume = 15
	sharp = 1

	var/mode = SYRINGE_DRAW

/obj/item/reagent_holder/syringe/on_reagent_change()
	update_icon()

/obj/item/reagent_holder/syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_holder/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_holder/syringe/attack_self(mob/user)
	switch(mode)
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

/obj/item/reagent_holder/syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_holder/syringe/attack_paw()
	return attack_hand()

/obj/item/reagent_holder/syringe/attackby(obj/item/I, mob/user)
	return

/obj/item/reagent_holder/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(!target.reagents)
		return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, SPAN_WARNING("This syringe is broken!"))
		return

	if(user.a_intent == "hurt" && ismob(target))
		if((MUTATION_CLUMSY in user.mutations) && prob(50))
			target = user
		syringestab(target, user)
		return

	switch(mode)
		if(SYRINGE_DRAW)
			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_WARNING("The syringe is full."))
				return

			if(ismob(target))//Blood!
				if(isslime(target))
					to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
					return
				if(src.reagents.has_reagent("blood"))
					to_chat(user, SPAN_WARNING("There is already a blood sample in this syringe."))
					return
				if(iscarbon(target))//maybe just add a blood reagent to all mobs. Then you can suck them dry...With hundreds of syringes. Jolly good idea.
					var/amount = src.reagents.maximum_volume - src.reagents.total_volume
					var/mob/living/carbon/T = target
					if(!T.dna)
						to_chat(user, "You are unable to locate any blood. (To be specific, your target seems to be missing their DNA datum.)")
						return
					if(MUTATION_NO_CLONE in T.mutations) //target done been et, no more blood in him
						to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
						return

					var/datum/reagent/B
					if(ishuman(T))
						var/mob/living/carbon/human/H = T
						if(isnotnull(H.species) && HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_NO_BLOOD))
							H.reagents.trans_to(src, amount)
						else
							B = T.take_blood(src, amount)
					else
						B = T.take_blood(src, amount)

					if(B)
						src.reagents.reagent_list += B
						src.reagents.update_total()
						src.on_reagent_change()
						src.reagents.handle_reactions()
					to_chat(user, SPAN_INFO("You take a blood sample from [target]."))
					for(var/mob/O in viewers(4, user))
						O.show_message(SPAN_WARNING("[user] takes a blood sample from [target]."), 1)

			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, SPAN_WARNING("[target] is empty."))
					return

				if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers) && !istype(target, /obj/item/slime_extract))
					to_chat(user, SPAN_WARNING("You cannot directly remove reagents from this object."))
					return

				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this) // transfer from, transfer to - who cares?

				to_chat(user, SPAN_INFO("You fill the syringe with [trans] units of the solution."))
			if(reagents.total_volume >= reagents.maximum_volume)
				mode = !mode
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, SPAN_WARNING("The syringe is empty."))
				return
			if(istype(target, /obj/item/implantcase/chem))
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_holder/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/cigarette) && !istype(target, /obj/item/storage/fancy/cigarettes))
				to_chat(user, SPAN_WARNING("You cannot directly fill this object."))
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, SPAN_WARNING("[target] is full."))
				return

			if(ismob(target) && target != user)
				var/time = 30 //Injecting through a hardsuit takes longer due to needing to find a port.
				if(ishuman(target))
					var/mob/living/carbon/human/H = target
					if(isnotnull(H.wear_suit) && istype(H.wear_suit, /obj/item/clothing/suit/space))
						time = 60

				for(var/mob/O in viewers(world.view, user))
					if(time == 30)
						O.show_message(SPAN_DANGER("[user] is trying to inject [target]!"), 1)
					else
						O.show_message(SPAN_DANGER("[user] begins hunting for an injection port on [target]'s suit!"), 1)

				if(!do_mob(user, target, time))
					return

				for(var/mob/O in viewers(world.view, user))
					O.show_message(SPAN_WARNING("[user] injects [target] with the syringe!"), 1)

				if(isliving(target))
					var/mob/living/M = target
					var/list/injected = list()
					for(var/datum/reagent/R in src.reagents.reagent_list)
						injected += R.name
					var/contained = english_list(injected)
					M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been injected with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>"
					user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [src.name] to inject [M.name] ([M.key]). Reagents: [contained]</font>"
					msg_admin_attack("[user.name] ([user.ckey]) injected [M.name] ([M.key]) with [src.name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

				src.reagents.reaction(target, INGEST)
			if(ismob(target) && target == user)
				src.reagents.reaction(target, INGEST)
			spawn(5)
				var/datum/reagent/blood/B
				for(var/datum/reagent/blood/d in src.reagents.reagent_list)
					B = d
					break
				var/trans
				if(B && iscarbon(target))
					var/mob/living/carbon/C = target
					C.inject_blood(src, 5)
				else
					trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
				to_chat(user, SPAN_INFO("You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units."))
				if(reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
					mode = SYRINGE_DRAW
					update_icon()
	return

/obj/item/reagent_holder/syringe/update_icon()
	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		cut_overlays()
		return
	var/rounded_vol = round(reagents.total_volume, 5)
	cut_overlays()
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if(SYRINGE_DRAW)
				injoverlay = "draw"
			if(SYRINGE_INJECT)
				injoverlay = "inject"
		add_overlay(injoverlay)
	icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "syringe10")

		filling.icon_state = "syringe[rounded_vol]"

		filling.icon += mix_colour_from_reagents(reagents.reagent_list)
		add_overlay(filling)

/obj/item/reagent_holder/syringe/proc/syringestab(mob/living/carbon/target, mob/living/carbon/user)
	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [target.name] ([target.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) attacked [target.name] ([target.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if(ishuman(target))
		var/target_zone = check_zone(user.zone_sel.selecting, target)
		var/datum/organ/external/affecting = target:get_organ(target_zone)

		if(!affecting)
			return
		if(affecting.status & ORGAN_DESTROYED)
			to_chat(user, "What [affecting.display_name]?")
			return
		var/hit_area = affecting.display_name

		var/mob/living/carbon/human/H = target
		if((user != target) && H.check_shields(7, "the [src.name]"))
			return

		if(target != user && target.getarmor(target_zone, "melee") > 5 && prob(50))
			for(var/mob/O in viewers(world.view, user))
				O.show_message(SPAN_DANGER("[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!"), 1)
			user.u_equip(src)
			qdel(src)
			return

		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_DANGER("[user] stabs [target] in \the [hit_area] with [src.name]!"), 1)

		if(affecting.take_damage(3))
			target:UpdateDamageIcon()
	else
		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_DANGER("[user] stabs [target] with [src.name]!"), 1)
		target.take_organ_damage(3)// 7 is the same as crowbar punch

	src.reagents.reaction(target, INGEST)
	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	src.reagents.trans_to(target, syringestab_amount_transferred)
	src.desc += " It is broken."
	src.mode = SYRINGE_BROKEN
	src.add_blood(target)
	src.add_fingerprint(usr)
	src.update_icon()


/obj/item/reagent_holder/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	icon = 'icons/obj/items/syringe.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = null //list(5,10,15)
	volume = 50

	var/mode = SYRINGE_DRAW

/obj/item/reagent_holder/ld50_syringe/on_reagent_change()
	update_icon()

/obj/item/reagent_holder/ld50_syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_holder/ld50_syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_holder/ld50_syringe/attack_self(mob/user)
	mode = !mode
	update_icon()

/obj/item/reagent_holder/ld50_syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_holder/ld50_syringe/attack_paw()
	return attack_hand()

/obj/item/reagent_holder/ld50_syringe/attackby(obj/item/I, mob/user)
	return

/obj/item/reagent_holder/ld50_syringe/afterattack(obj/target, mob/user, flag)
	if(!target.reagents)
		return

	switch(mode)
		if(SYRINGE_DRAW)
			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_WARNING("The syringe is full."))
				return

			if(ismob(target))
				if(iscarbon(target)) //I Do not want it to suck 50 units out of people
					to_chat(user, "This needle isn't designed for drawing blood.")
					return
			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, SPAN_WARNING("[target] is empty."))
					return

				if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers))
					to_chat(user, SPAN_WARNING("You cannot directly remove reagents from this object."))
					return

				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this) // transfer from, transfer to - who cares?

				to_chat(user, SPAN_INFO("You fill the syringe with [trans] units of the solution."))
			if(reagents.total_volume >= reagents.maximum_volume)
				mode = !mode
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, SPAN_WARNING("The syringe is empty."))
				return
			if(istype(target, /obj/item/implantcase/chem))
				return
			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_holder/food))
				to_chat(user, SPAN_WARNING("You cannot directly fill this object."))
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, SPAN_WARNING("[target] is full."))
				return

			if(ismob(target) && target != user)
				for(var/mob/O in viewers(world.view, user))
					O.show_message(SPAN_DANGER("[user] is trying to inject [target] with a giant syringe!"), 1)
				if(!do_mob(user, target, 300))
					return
				for(var/mob/O in viewers(world.view, user))
					O.show_message(SPAN_WARNING("[user] injects [target] with a giant syringe!"), 1)
				src.reagents.reaction(target, INGEST)
			if(ismob(target) && target == user)
				src.reagents.reaction(target, INGEST)
			spawn(5)
				var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
				to_chat(user, SPAN_INFO("You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units."))
				if(reagents.total_volume >= reagents.maximum_volume && mode == SYRINGE_INJECT)
					mode = SYRINGE_DRAW
					update_icon()
	return

/obj/item/reagent_holder/ld50_syringe/update_icon()
	var/rounded_vol = round(reagents.total_volume,50)
	if(ismob(loc))
		var/mode_t
		switch(mode)
			if(SYRINGE_DRAW)
				mode_t = "d"
			if(SYRINGE_INJECT)
				mode_t = "i"
		icon_state = "[mode_t][rounded_vol]"
	else
		icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"

////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_holder/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."

/obj/item/reagent_holder/syringe/inaprovaline/New()
	..()
	reagents.add_reagent("inaprovaline", 15)
	mode = SYRINGE_INJECT
	update_icon()


/obj/item/reagent_holder/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."

/obj/item/reagent_holder/syringe/antitoxin/New()
	..()
	reagents.add_reagent("anti_toxin", 15)
	mode = SYRINGE_INJECT
	update_icon()


/obj/item/reagent_holder/syringe/antiviral
	name = "Syringe (spaceacillin)"
	desc = "Contains antiviral agents."

/obj/item/reagent_holder/syringe/antiviral/New()
	..()
	reagents.add_reagent("spaceacillin", 15)
	mode = SYRINGE_INJECT
	update_icon()


/obj/item/reagent_holder/ld50_syringe/choral

/obj/item/reagent_holder/ld50_syringe/choral/New()
	..()
	reagents.add_reagent("chloralhydrate", 50)
	mode = SYRINGE_INJECT
	update_icon()


// Added to go with the radiation first aid kit. -Frenjo
/obj/item/reagent_holder/syringe/hyronalin
	name = "Syringe (hyronalin)"
	desc = "Contains hyronalin - used to treat radiation."

/obj/item/reagent_holder/syringe/hyronalin/New()
	..()
	reagents.add_reagent("hyronalin", 15)
	mode = SYRINGE_INJECT
	update_icon()

//Robot syringes
//Not special in any way, code wise. They don't have added variables or procs.
/obj/item/reagent_holder/syringe/robot/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."

/obj/item/reagent_holder/syringe/robot/antitoxin/New()
	..()
	reagents.add_reagent("anti_toxin", 15)
	mode = SYRINGE_INJECT
	update_icon()


/obj/item/reagent_holder/syringe/robot/inoprovaline
	name = "Syringe (inoprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."

/obj/item/reagent_holder/syringe/robot/inoprovaline/New()
	..()
	reagents.add_reagent("inaprovaline", 15)
	mode = SYRINGE_INJECT
	update_icon()


/obj/item/reagent_holder/syringe/robot/mixed
	name = "Syringe (mixed)"
	desc = "Contains inaprovaline & anti-toxins."

/obj/item/reagent_holder/syringe/robot/mixed/New()
	..()
	reagents.add_reagent("inaprovaline", 7)
	reagents.add_reagent("anti_toxin", 8)
	mode = SYRINGE_INJECT
	update_icon()

#undef SYRINGE_DRAW
#undef SYRINGE_INJECT
#undef SYRINGE_BROKEN