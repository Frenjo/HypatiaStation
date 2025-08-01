/obj/machinery/iv_drip
	name = "\improper IV drip"
	icon = 'icons/obj/machines/iv_drip.dmi'
	anchored = FALSE
	density = TRUE

	var/mob/living/carbon/human/attached = null
	var/mode = 1 // 1 is injecting, 0 is taking blood.
	var/obj/item/reagent_holder/beaker = null

/obj/machinery/iv_drip/update_icon()
	if(src.attached)
		icon_state = "hooked"
	else
		icon_state = ""

	cut_overlays()

	if(beaker)
		var/datum/reagents/reagents = beaker.reagents
		if(reagents.total_volume)
			var/mutable_appearance/filling_overlay = mutable_appearance('icons/obj/machines/iv_drip.dmi', "reagent")

			var/percent = round((reagents.total_volume / beaker.volume) * 100)
			switch(percent)
				if(0 to 9)
					filling_overlay.icon_state = "reagent0"
				if(10 to 24)
					filling_overlay.icon_state = "reagent10"
				if(25 to 49)
					filling_overlay.icon_state = "reagent25"
				if(50 to 74)
					filling_overlay.icon_state = "reagent50"
				if(75 to 79)
					filling_overlay.icon_state = "reagent75"
				if(80 to 90)
					filling_overlay.icon_state = "reagent80"
				if(91 to INFINITY)
					filling_overlay.icon_state = "reagent100"

			filling_overlay.icon = list("#0000", "#0000", "#0000", "#000f", mix_colour_from_reagents(reagents.reagent_list))
			add_overlay(filling_overlay)

/obj/machinery/iv_drip/MouseDrop(over_object, src_location, over_location)
	..()

	if(attached)
		visible_message("[src.attached] is detached from \the [src]")
		src.attached = null
		src.update_icon()
		return

	if(in_range(src, usr) && ishuman(over_object) && get_dist(over_object, src) <= 1)
		visible_message("[usr] attaches \the [src] to \the [over_object].")
		src.attached = over_object
		src.update_icon()


/obj/machinery/iv_drip/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/reagent_holder))
		if(isnotnull(src.beaker))
			user << "There is already a reagent container loaded!"
			return

		user.drop_item()
		W.forceMove(src)
		src.beaker = W
		user << "You attach \the [W] to \the [src]."
		src.update_icon()
		return
	else
		return ..()


/obj/machinery/iv_drip/process()
	set background = BACKGROUND_ENABLED

	if(src.attached)

		if(!(get_dist(src, src.attached) <= 1 && isturf(src.attached.loc)))
			visible_message("The needle is ripped out of [src.attached], doesn't that hurt?")
			src.attached:apply_damage(3, BRUTE, pick("r_arm", "l_arm"))
			src.attached = null
			src.update_icon()
			return

	if(src.attached && src.beaker)
		// Give blood
		if(mode)
			if(src.beaker.volume > 0)
				var/transfer_amount = REAGENTS_METABOLISM
				if(istype(src.beaker, /obj/item/reagent_holder/blood))
					// speed up transfer on blood packs
					transfer_amount = 4
				src.beaker.reagents.trans_to(src.attached, transfer_amount)
				update_icon()

		// Take blood
		else
			var/amount = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			amount = min(amount, 4)
			// If the beaker is full, ping
			if(amount == 0)
				if(prob(5)) visible_message("\The [src] pings.")
				return

			var/mob/living/carbon/human/T = attached

			if(!istype(T)) return
			if(!T.dna)
				return
			if(MUTATION_NO_CLONE in T.mutations)
				return

			if(isnotnull(T.species) && HAS_SPECIES_FLAGS(T.species, SPECIES_FLAG_NO_BLOOD))
				return

			// If the human is losing too much blood, beep.
			if(T.vessel.get_reagent_amount("blood") < BLOOD_VOLUME_SAFE) if(prob(5))
				visible_message("\The [src] beeps loudly.")

			var/datum/reagent/B = T.take_blood(beaker,amount)

			if (B)
				beaker.reagents.reagent_list |= B
				beaker.reagents.update_total()
				beaker.on_reagent_change()
				beaker.reagents.handle_reactions()
				update_icon()

/obj/machinery/iv_drip/attack_hand(mob/user)
	if(src.beaker)
		beaker.forceMove(GET_TURF(src))
		src.beaker = null
		update_icon()
	else
		return ..()


/obj/machinery/iv_drip/verb/toggle_mode()
	set category = PANEL_OBJECT
	set name = "Toggle Mode"
	set src in view(1)

	if(!isliving(usr))
		usr << "\red You can't do that."
		return

	if(usr.stat)
		return

	mode = !mode
	usr << "The IV drip is now [mode ? "injecting" : "taking blood"]."

/obj/machinery/iv_drip/get_examine_text(mob/user)
	. = ..()
	if(!in_range(src, user))
		return

	. += "It is [mode ? "injecting" : "taking blood"]."
	if(isnotnull(beaker))
		if(length(beaker.reagents?.reagent_list))
			. += SPAN_INFO("Attached is \a [beaker] with [beaker.reagents.total_volume] units of liquid.")
		else
			. += SPAN_INFO("Attached is an empty [beaker].")
	else
		. += SPAN_INFO("No beaker is attached.")
	. += SPAN_INFO("It is attached to [attached ? attached : "no one"].")