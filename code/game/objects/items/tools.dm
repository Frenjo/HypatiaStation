//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/* Tools!
 * Note: Multitools are /obj/item
 *
 * Contains:
 *		Wrench
 *		Screwdriver
 *		Wirecutters
 *		Welding Tool
 *		Crowbar
 */

/*
 * Wrench
 */
/obj/item/wrench
	name = "wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrench"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	matter_amounts = list(/decl/material/steel = 150)
	origin_tech = list(/datum/tech/materials = 1, /datum/tech/engineering = 1)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")

/*
 * Screwdriver
 */
/obj/item/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	icon = 'icons/obj/items.dmi'
	icon_state = "screwdriver"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	matter_amounts = list(/decl/material/steel = 75)
	attack_verb = list("stabbed")

/obj/item/screwdriver/suicide_act(mob/user)
	user.visible_message(pick( \
		SPAN_DANGER("[user] is stabbing the [src.name] into \his temple! It looks like \he's trying to commit suicide."), \
		SPAN_DANGER("[user] is stabbing the [src.name] into \his heart! It looks like \he's trying to commit suicide.") \
		)
	)
	return(BRUTELOSS)

/obj/item/screwdriver/New()
	switch(pick("red", "blue", "purple", "brown", "green", "cyan", "yellow"))
		if("red")
			icon_state = "screwdriver2"
			item_state = "screwdriver"
		if("blue")
			icon_state = "screwdriver"
			item_state = "screwdriver_blue"
		if("purple")
			icon_state = "screwdriver3"
			item_state = "screwdriver_purple"
		if("brown")
			icon_state = "screwdriver4"
			item_state = "screwdriver_brown"
		if("green")
			icon_state = "screwdriver5"
			item_state = "screwdriver_green"
		if("cyan")
			icon_state = "screwdriver6"
			item_state = "screwdriver_cyan"
		if("yellow")
			icon_state = "screwdriver7"
			item_state = "screwdriver_yellow"

	if(prob(75))
		src.pixel_y = rand(0, 16)
	..()

/obj/item/screwdriver/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M))
		return ..()
	if(user.zone_sel.selecting != "eyes" && user.zone_sel.selecting != "head")
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M, user)

/*
 * Wirecutters
 */
/obj/item/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon = 'icons/obj/items.dmi'
	icon_state = "cutters"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	force = 6.0
	throw_speed = 2
	throw_range = 9
	w_class = 2.0
	matter_amounts = list(/decl/material/steel = 80)
	origin_tech = list(/datum/tech/materials = 1, /datum/tech/engineering = 1)
	attack_verb = list("pinched", "nipped")
	sharp = 1
	edge = 1

/obj/item/wirecutters/New()
	if(prob(50))
		icon_state = "cutters-y"
		item_state = "cutters_yellow"
	..()

/obj/item/wirecutters/attack(mob/living/carbon/C, mob/user)
	if(C.handcuffed && (istype(C.handcuffed, /obj/item/handcuffs/cable)))
		user.visible_message(
			"\The [user] cuts \the [C]'s restraints with \the [src]!",
			"You cut \the [C]'s restraints with \the [src]!",
			"You hear cable being cut."
		)
		C.handcuffed = null
		C.update_inv_handcuffed()
		return
	else
		..()

/*
 * Welding Tool
 */
#define WELDING_TOOL_OFF 0
#define WELDING_TOOL_ON 1
#define WELDING_TOOL_WELDING 2
/obj/item/weldingtool
	name = "welding tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT

	//Amount of OUCH when it's thrown
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0

	//Cost to make in the autolathe
	matter_amounts = list(/decl/material/steel = 70, /decl/material/glass = 30)

	//R&D tech level
	origin_tech = list(/datum/tech/engineering = 1)

	//Welding tool specific stuff
	var/welding = WELDING_TOOL_OFF	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1					//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20				//The max amount of fuel the welder can hold

/obj/item/weldingtool/New()
//	var/random_fuel = min(rand(10,20),max_fuel)
	create_reagents(max_fuel)
	reagents.add_reagent("fuel", max_fuel)
	. = ..()

/obj/item/weldingtool/Destroy()
	if(welding)
		GLOBL.processing_objects -= src
	return ..()

/obj/item/weldingtool/examine()
	set src in usr
	to_chat(usr, "\icon[src] \The [src] contains [get_fuel()]/[max_fuel] units of fuel!")
	return

/obj/item/weldingtool/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		if(welding)
			FEEDBACK_TURN_OFF_FIRST(user)
			return TRUE
		status = !status
		if(status)
			to_chat(user, SPAN_NOTICE("You resecure the welder."))
		else
			to_chat(user, SPAN_NOTICE("The welder can now be attached and modified."))
		add_fingerprint(user)
		return TRUE

	return ..()

/obj/item/weldingtool/attackby(obj/item/W, mob/user)
	if(!status && istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = W
		R.use(1)
		var/obj/item/flamethrower/F = new/obj/item/flamethrower(user.loc)
		src.loc = F
		F.weldtool = src
		if(user.client)
			user.client.screen -= src
		if(user.r_hand == src)
			user.u_equip(src)
		else
			user.u_equip(src)
		src.master = F
		src.reset_plane_and_layer()
		user.u_equip(src)
		if(user.client)
			user.client.screen -= src
		src.loc = F
		src.add_fingerprint(user)
		return
	..()
	return

/obj/item/weldingtool/process()
	switch(welding)
		//If off
		if(WELDING_TOOL_OFF)
			if(src.icon_state != "welder") //Check that the sprite is correct, if it isnt, it means toggle() was not called
				src.force = 3
				src.damtype = "brute"
				src.icon_state = "welder"
				src.welding = 0
			GLOBL.processing_objects.Remove(src)
			return
		//Welders left on now use up fuel, but lets not have them run out quite that fast
		if(WELDING_TOOL_ON)
			if(src.icon_state != "welder1") //Check that the sprite is correct, if it isnt, it means toggle() was not called
				src.force = 15
				src.damtype = "fire"
				src.icon_state = "welder1"
			if(prob(5))
				remove_fuel(1)

		//If you're actually actively welding, use fuel faster.
		//Is this actually used or set anywhere? - Nodrak
		if(WELDING_TOOL_WELDING)
			if(prob(75))
				remove_fuel(1)

	//I'm not sure what this does. I assume it has to do with starting fires...
	//...but it doesnt check to see if the welder is on or not.
	var/turf/location = src.loc
	if(ismob(location))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = get_turf(M)
	if(isturf(location))
		location.hotspot_expose(700, 5)

/obj/item/weldingtool/afterattack(obj/O, mob/user, proximity)
	if(!proximity)
		return
	if(istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src, O) <= 1 && !src.welding)
		O.reagents.trans_to(src, max_fuel)
		to_chat(user, SPAN_INFO("Welder refueled."))
		playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if(istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src, O) <= 1 && src.welding)
		message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
		log_game("[key_name(user)] triggered a fueltank explosion.")
		to_chat(user, SPAN_WARNING("That was stupid of you."))
		var/obj/structure/reagent_dispensers/fueltank/tank = O
		tank.explode()
		return
	if(src.welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		if(isturf(location))
			location.hotspot_expose(700, 50, 1)
	return

/obj/item/weldingtool/attack_self(mob/user)
	toggle()
	return

//Returns the amount of fuel in the welder
/obj/item/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weldingtool/proc/remove_fuel(amount = 1, mob/M = null)
	if(!welding || !check_fuel())
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		check_fuel()
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			FEEDBACK_NOT_ENOUGH_WELDING_FUEL(M)
		return 0

//Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return src.welding

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weldingtool/proc/setWelding(temp_welding)
	//If we're turning it on
	if(temp_welding > 0)
		if(remove_fuel(1))
			to_chat(usr, SPAN_INFO("The [src] switches on."))
			src.force = 15
			src.damtype = "fire"
			src.icon_state = "welder1"
			GLOBL.processing_objects.Add(src)
		else
			to_chat(usr, SPAN_INFO("Need more fuel!"))
			src.welding = WELDING_TOOL_OFF
			return
	//Otherwise
	else
		to_chat(usr, SPAN_INFO("The [src] switches off."))
		src.force = 3
		src.damtype = "brute"
		src.icon_state = "welder"
		src.welding = WELDING_TOOL_OFF

//Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/weldingtool/proc/check_fuel()
	if(get_fuel() <= 0 && welding)
		toggle(1)
		return 0
	return 1

//Toggles the welder off and on
/obj/item/weldingtool/proc/toggle(message = 0)
	if(!status)
		return
	src.welding = !src.welding
	if(src.welding)
		if(remove_fuel(1))
			to_chat(usr, SPAN_INFO("You switch the [src] on."))
			src.force = 15
			src.damtype = "fire"
			src.icon_state = "welder1"
			GLOBL.processing_objects.Add(src)
		else
			to_chat(usr, SPAN_INFO("Need more fuel!"))
			src.welding = WELDING_TOOL_OFF
			return
	else
		if(!message)
			to_chat(usr, SPAN_INFO("You switch the [src] off."))
		else
			to_chat(usr, SPAN_INFO("The [src] shuts off!"))
		src.force = 3
		src.damtype = "brute"
		src.icon_state = "welder"
		src.welding = WELDING_TOOL_OFF

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weldingtool/proc/eyecheck(mob/user)
	if(!iscarbon(user))
		return 1
	var/safety = user:eyecheck()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/organ/internal/eyes/E = H.internal_organs["eyes"]
		switch(safety)
			if(1)
				to_chat(H, SPAN_WARNING("Your eyes sting a little."))
				E.damage += rand(1, 2)
				if(E.damage > 12)
					H.eye_blurry += rand(3, 6)
			if(0)
				to_chat(H, SPAN_WARNING("Your eyes burn."))
				E.damage += rand(2, 4)
				if(E.damage > 10)
					E.damage += rand(4, 10)
			if(-1)
				to_chat(H, SPAN_WARNING("Your thermals intensify the welder's glow. Your eyes itch and burn severely."))
				H.eye_blurry += rand(12, 20)
				E.damage += rand(12, 16)
		if(safety < 2)
			if(E.damage > 10)
				to_chat(H, SPAN_WARNING("Your eyes are really starting to hurt. This can't be good for you!"))
			if(E.damage >= E.min_broken_damage)
				to_chat(H, SPAN_WARNING("You go blind!"))
				H.sdisabilities |= BLIND
			else if(E.damage >= E.min_bruised_damage)
				to_chat(H, SPAN_WARNING("You go blind!"))
				H.eye_blind = 5
				H.eye_blurry = 5
				H.disabilities |= NEARSIGHTED
				spawn(100)
					H.disabilities &= ~NEARSIGHTED
	return

/obj/item/weldingtool/attack(mob/M, mob/user)
	if(hasorgans(M))
		var/datum/organ/external/S = M:organs_by_name[user.zone_sel.selecting]
		if(!S)
			return
		if(!(S.status & ORGAN_ROBOT) || user.a_intent != "help")
			return ..()
		if(S.brute_dam)
			S.heal_damage(15, 0, 0, 1)
			if(user != M)
				user.visible_message(
					SPAN_WARNING("\The [user] patches some dents on \the [M]'s [S.display_name] with \the [src]."),
					SPAN_WARNING("You patch some dents on \the [M]'s [S.display_name]."),
					"You hear a welder."
				)
			else
				user.visible_message(
					SPAN_WARNING("\The [user] patches some dents on their [S.display_name] with \the [src]."),
					SPAN_WARNING("You patch some dents on your [S.display_name]."),
					"You hear a welder."
				)
		else
			to_chat(user, "Nothing to fix!")
	else
		return ..()
#undef WELDING_TOOL_OFF
#undef WELDING_TOOL_ON
#undef WELDING_TOOL_WELDING

/obj/item/weldingtool/largetank
	name = "industrial welding tool"
	max_fuel = 40
	matter_amounts = list(/decl/material/steel = 70, /decl/material/glass = 60)
	origin_tech = list(/datum/tech/engineering = 2)

/obj/item/weldingtool/hugetank
	name = "upgraded welding tool"
	max_fuel = 80
	w_class = 3.0
	matter_amounts = list(/decl/material/steel = 70, /decl/material/glass = 120)
	origin_tech = list(/datum/tech/engineering = 3)

/obj/item/weldingtool/experimental
	name = "experimental welding tool"
	max_fuel = 40
	w_class = 3.0
	matter_amounts = list(/decl/material/steel = 70, /decl/material/glass = 120)
	origin_tech = list(/datum/tech/engineering = 4, /datum/tech/plasma = 3)

	var/last_gen = 0

/obj/item/weldingtool/experimental/proc/fuel_gen()//Proc to make the experimental welder generate fuel, optimized as fuck -Sieve
	var/gen_amount = (world.time - last_gen) / 25
	reagents += gen_amount
	if(reagents > max_fuel)
		reagents = max_fuel

/*
 * Crowbar
 */
/obj/item/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	force = 5.0
	throwforce = 7.0
	item_state = "crowbar"
	w_class = 2.0
	matter_amounts = list(/decl/material/steel = 50)
	origin_tech = list(/datum/tech/engineering = 1)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/crowbar/red
	icon = 'icons/obj/items.dmi'
	icon_state = "red_crowbar"
	item_state = "crowbar_red"