/proc/create_new_xenomorph(alien_caste, target)
	target = get_turf(target)
	if(isnull(target) || isnull(alien_caste))
		return

	var/mob/living/carbon/human/new_alien = new /mob/living/carbon/human(target)
	new_alien.set_species("Xenomorph [alien_caste]")
	return new_alien

/mob/living/carbon/human/xdrone/New(new_loc)
	h_style = "Bald"
	. = ..(new_loc, SPECIES_XENOMORPH_DRONE)

/mob/living/carbon/human/xsentinel/New(new_loc)
	h_style = "Bald"
	. = ..(new_loc, SPECIES_XENOMORPH_SENTINEL)

/mob/living/carbon/human/xhunter/New(new_loc)
	h_style = "Bald"
	. = ..(new_loc, SPECIES_XENOMORPH_HUNTER)

/mob/living/carbon/human/xqueen/New(new_loc)
	h_style = "Bald"
	. = ..(new_loc, SPECIES_XENOMORPH_QUEEN)

/mob/living/carbon/human/Stat()
	. = ..()

// I feel like we should generalize/condense down all the various icon-rendering antag procs.
/*
----------------------------------------
Proc: AddInfectionImages()
Des: Gives the client of the alien an image on each infected mob.
----------------------------------------
*/
/mob/living/carbon/human/proc/AddInfectionImages()
	if(isnotnull(client))
		for(var/mob/living/C in GLOBL.mob_list)
			if(C.status_flags & XENO_HOST)
				var/obj/item/alien_embryo/A = locate() in C
				client.images.Add(image('icons/mob/alien.dmi', loc = C, icon_state = "infected[A.stage]"))

/*
----------------------------------------
Proc: RemoveInfectionImages()
Des: Removes all infected images from the alien.
----------------------------------------
*/
/mob/living/carbon/human/proc/RemoveInfectionImages()
	if(isnotnull(client))
		for_no_type_check(var/image/I, client.images)
			if(dd_hasprefix_case(I.icon_state, "infected"))
				qdel(I)

/* TODO: Convert this over.
/mob/living/carbon/human/alien/show_inv(mob/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Left Hand:</B> <A href='byond:://?src=\ref[src];item=l_hand'>[(l_hand ? text("[]", l_hand) : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='byond:://?src=\ref[src];item=r_hand'>[(r_hand ? text("[]", r_hand) : "Nothing")]</A>
	<BR><B>Head:</B> <A href='byond:://?src=\ref[src];item=head'>[(head ? text("[]", head) : "Nothing")]</A>
	<BR><B>(Exo)Suit:</B> <A href='byond:://?src=\ref[src];item=suit'>[(wear_suit ? text("[]", wear_suit) : "Nothing")]</A>
	<BR><A href='byond:://?src=\ref[src];item=pockets'>Empty Pouches</A>
	<BR><A href='byond:://?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[name];size=340x480"))
	onclose(user, "mob[name]")
	return
	*/

/* TODO: Convert this over.
/mob/living/carbon/human/alien/queen/large
	icon = 'icons/mob/alienqueen.dmi'
	icon_state = "queen_s"
	pixel_x = -16
/mob/living/carbon/human/alien/queen/large/update_icons()
	lying_prev = lying	//so we don't update overlays for lying/standing unless our stance changes again
	update_hud()		//TODO: remove the need for this to be here
	overlays.Cut()
	if(lying)
		if(resting)					icon_state = "queen_sleep"
		else						icon_state = "queen_l"
		for(var/image/I in overlays_lying)
			overlays += I
	else
		icon_state = "queen_s"
		for(var/image/I in overlays_standing)
			overlays += I*/