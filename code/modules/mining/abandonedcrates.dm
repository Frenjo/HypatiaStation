/obj/structure/closet/crate/secure/loot
	name = "abandoned crate"
	desc = "What could be inside?"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	locked = TRUE

	var/code = null
	var/lastattempt = null
	var/attempts = 3
	var/min = 1
	var/max = 10

/obj/structure/closet/crate/secure/loot/New()
	code = rand(min, max)
	var/loot = rand(1, 30)
	switch(loot)
		if(1)
			starts_with = list(
				/obj/item/reagent_holder/food/drinks/bottle/rum,
				/obj/item/reagent_holder/food/snacks/grown/ambrosiadeus,
				/obj/item/reagent_holder/food/drinks/bottle/whiskey,
				/obj/item/lighter/zippo
			)
		if(2)
			starts_with = list(
				/obj/item/pickaxe/drill,
				/obj/item/taperecorder,
				/obj/item/clothing/suit/space,
				/obj/item/clothing/head/helmet/space
			)
		if(3)
			return
		if(4)
			starts_with = list(/obj/item/reagent_holder/glass/beaker/bluespace)
		if(5 to 6)
			for(var/i = 0, i < 10, i++)
				starts_with += /obj/item/ore/diamond
		if(7)
			return
		if(8)
			return
		if(9)
			for(var/i = 0, i < 3, i++)
				starts_with += /obj/machinery/hydroponics
		if(10)
			for(var/i = 0, i < 3, i++)
				starts_with += /obj/item/reagent_holder/glass/beaker/noreact
		if(11 to 12)
			for(var/i = 0, i < 9, i++)
				starts_with += /obj/item/bluespace_crystal
		if(13)
			starts_with = list(/obj/item/melee/classic_baton)
		if(14)
			return
		if(15)
			starts_with = list(/obj/item/clothing/under/chameleon)
			for(var/i = 0, i < 7, i++)
				starts_with += /obj/item/clothing/tie/horrible
		if(16)
			starts_with = list(
				/obj/item/clothing/under/shorts,
				/obj/item/clothing/under/shorts/red,
				/obj/item/clothing/under/shorts/blue
			)
		//Dummy crates start here.
		if(17 to 29)
			return
		//Dummy crates end here.
		if(30)
			starts_with = list(/obj/item/melee/baton)

	. = ..()

/obj/structure/closet/crate/secure/loot/togglelock(mob/user)
	if(locked)
		to_chat(user, SPAN_NOTICE("The crate is locked with a Deca-code lock."))
		var/input = input(usr, "Enter digit from [min] to [max].", "Deca-Code Lock", "") as num
		if(in_range(src, user))
			input = clamp(input, 0, 10)
			if(input == code)
				to_chat(user, SPAN_NOTICE("The crate unlocks!"))
				locked = FALSE
				overlays.Cut()
				overlays += greenlight
			else if(isnull(input) || input > max || input < min)
				to_chat(user, SPAN_NOTICE("You leave the crate alone."))
			else
				to_chat(user, SPAN_WARNING("A red light flashes."))
				lastattempt = input
				attempts--
				if(attempts == 0)
					to_chat(user, SPAN_DANGER("The crate's anti-tamper system activates!"))
					var/turf/T = get_turf(loc)
					explosion(T, 0, 0, 0, 1)
					qdel(src)
					return
		else
			to_chat(user, SPAN_NOTICE("You attempt to interact with the device using a hand gesture, but it appears this crate is from before the DECANECT came out."))
			return
	else
		return ..()

/obj/structure/closet/crate/secure/loot/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(!locked)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE
	to_chat(user, SPAN_NOTICE("The crate unlocks!"))
	locked = FALSE
	return TRUE

/obj/structure/closet/crate/secure/loot/attackby(obj/item/W, mob/user)
	if(locked)
		if(istype(W, /obj/item/multitool))
			to_chat(user, SPAN_NOTICE("DECA-CODE LOCK REPORT:"))
			if(attempts == 1)
				to_chat(user, SPAN_WARNING("* Anti-Tamper Bomb will activate on next failed access attempt."))
			else
				to_chat(user, SPAN_NOTICE("* Anti-Tamper Bomb will activate after [attempts] failed access attempts."))
			if(lastattempt == null)
				to_chat(user, SPAN_NOTICE(" has been made to open the crate thus far."))
				return
			// hot and cold
			if(code > lastattempt)
				to_chat(user, SPAN_NOTICE("* Last access attempt lower than expected code."))
			else
				to_chat(user, SPAN_NOTICE("* Last access attempt higher than expected code."))
		else ..()
	else ..()