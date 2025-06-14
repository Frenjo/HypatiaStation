//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos

/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00"
	density = FALSE
	anchored = TRUE
	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/toilet/New()
	. = ..()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/toilet/attack_hand(mob/living/user)
	if(swirlie)
		usr.visible_message(
			SPAN_DANGER("[user] slams the toilet seat onto \the [swirlie]'s head!"),
			SPAN_NOTICE("You slam the toilet seat onto \the [swirlie]'s head!"),
			"You hear reverberating porcelain."
		)
		swirlie.adjustBruteLoss(8)
		return

	if(cistern && !open)
		if(!length(contents))
			to_chat(user, SPAN_NOTICE("The cistern is empty."))
			return
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.forceMove(GET_TURF(src))
			to_chat(user, SPAN_NOTICE("You find \an [I] in the cistern."))
			w_items -= I.w_class
			return

	open = !open
	update_icon()

/obj/structure/toilet/update_icon()
	icon_state = "toilet[open][cistern]"

/obj/structure/toilet/attack_grab(obj/item/grab/grab, mob/user, mob/grabbed)
	if(!isliving(grabbed))
		return FALSE

	var/mob/living/living_grabbed = grabbed
	if(grab.state > 1)
		if(living_grabbed.loc != GET_TURF(src))
			to_chat(user, SPAN_NOTICE("\The [living_grabbed] needs to be on \the [src]."))
			return
		if(open && !swirlie)
			user.visible_message(
				SPAN_DANGER("[user] starts to give \the [living_grabbed] a swirlie!"),
				SPAN_NOTICE("You start to give \the [living_grabbed] a swirlie!")
			)
			swirlie = living_grabbed
			if(do_after(user, 3 SECONDS, TRUE))
				user.visible_message(
					SPAN_DANGER("[user] gives \the [living_grabbed] a swirlie!"),
					SPAN_NOTICE("You give \the [living_grabbed] a swirlie!"),
					"You hear a toilet flushing."
				)
				if(isnull(living_grabbed.internal))
					living_grabbed.adjustOxyLoss(5)
			swirlie = null
		else
			user.visible_message(
				SPAN_DANGER("[user] slams [living_grabbed] into \the [src]!"),
				SPAN_DANGER("You slam [living_grabbed] into \the [src]!")
			)
			living_grabbed.adjustBruteLoss(8)
	else
		to_chat(user, SPAN_NOTICE("You need a tighter grip."))
	return TRUE

/obj/structure/toilet/attack_tool(obj/item/tool, mob/user)
	if(iscrowbar(tool))
		to_chat(user, SPAN_NOTICE("You start to [cistern ? "replace the lid on" : "lift the lid off"] the cistern."))
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
		if(do_after(user, 3 SECONDS))
			user.visible_message(
				SPAN_NOTICE("[user] [cistern ? "replaces the lid on" : "lifts the lid off"] the cistern!"),
				SPAN_NOTICE("You [cistern ? "replace the lid on" : "lift the lid off"] the cistern!"),
				"You hear grinding porcelain."
			)
			cistern = !cistern
			update_icon()
		return TRUE
	return ..()

/obj/structure/toilet/attackby(obj/item/I, mob/living/user)
	if(cistern)
		if(I.w_class > 3)
			to_chat(user, SPAN_NOTICE("\The [I] does not fit."))
			return
		if(w_items + I.w_class > 5)
			to_chat(user, SPAN_NOTICE("The cistern is full."))
			return
		user.drop_item()
		I.forceMove(src)
		w_items += I.w_class
		to_chat(user, "You carefully place \the [I] into the cistern.")
		return


/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE

/obj/structure/urinal/attack_grab(obj/item/grab/grab, mob/user, mob/grabbed)
	if(!isliving(grabbed))
		return FALSE

	var/mob/living/living_grabbed = grabbed
	if(grab.state > 1)
		if(living_grabbed.loc != GET_TURF(src))
			to_chat(user, SPAN_NOTICE("\The [living_grabbed] needs to be on \the [src]."))
			return
		user.visible_message(
			SPAN_DANGER("[user] slams \the [living_grabbed] into \the [src]!"),
			SPAN_NOTICE("You slam \the [living_grabbed] into \the [src]!")
		)
		living_grabbed.adjustBruteLoss(8)
	else
		to_chat(user, SPAN_NOTICE("You need a tighter grip."))
	return TRUE

/obj/machinery/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2550s by the NanoTrasen Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = FALSE
	anchored = TRUE

	power_state = USE_POWER_OFF

	var/on = 0
	var/obj/effect/mist/mymist = null
	var/ismist = 0				//needs a var so we can make it linger~
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/mobpresent = 0		//true if there is a mob on the shower's loc, this is to ease process()

//add heat controls? when emagged, you can freeze to death in it?

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = MOB_LAYER + 1
	anchored = TRUE
	mouse_opacity = FALSE

/obj/machinery/shower/attack_hand(mob/M)
	on = !on
	update_icon()
	if(on)
		if(M.loc == loc)
			wash(M)
			check_heat(M)
		for_no_type_check(var/atom/movable/mover, GET_TURF(src))
			mover.clean_blood()

/obj/machinery/shower/attackby(obj/item/I, mob/user)
	if(I.type == /obj/item/gas_analyser)
		to_chat(user, SPAN_NOTICE("The water temperature seems to be [watertemp]."))
	if(iswrench(I))
		to_chat(user, SPAN_NOTICE("You begin to adjust the temperature valve with \the [I]."))
		if(do_after(user, 50))
			switch(watertemp)
				if("normal")
					watertemp = "freezing"
				if("freezing")
					watertemp = "boiling"
				if("boiling")
					watertemp = "normal"
			user.visible_message(
				SPAN_NOTICE("[user] adjusts the shower with \the [I]."),
				SPAN_NOTICE("You adjust the shower with \the [I].")
			)
			add_fingerprint(user)

/obj/machinery/shower/update_icon()	//this is terribly unreadable, but basically it makes the shower mist up
	cut_overlays()					//once it's been on for a while, in addition to handling the water overlay.
	if(mymist)
		qdel(mymist)

	if(on)
		add_overlay(image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir))
		if(watertemp == "freezing")
			return
		if(!ismist)
			spawn(50)
				if(src && on)
					ismist = 1
					mymist = new /obj/effect/mist(loc)
		else
			ismist = 1
			mymist = new /obj/effect/mist(loc)
	else if(ismist)
		ismist = 1
		mymist = new /obj/effect/mist(loc)
		spawn(250)
			if(src && !on)
				qdel(mymist)
				ismist = 0

/obj/machinery/shower/Crossed(atom/movable/O)
	..()
	wash(O)
	if(ismob(O))
		mobpresent += 1
		check_heat(O)

/obj/machinery/shower/Uncrossed(atom/movable/O)
	if(ismob(O))
		mobpresent -= 1
	..()

//Yes, showers are super powerful as far as washing goes.
/obj/machinery/shower/proc/wash(atom/movable/O)
	if(!on)
		return

	if(isliving(O))
		var/mob/living/L = O
		L.ExtinguishMob()
		L.fire_stacks = -20 //Douse ourselves with water to avoid fire more easily

	if(iscarbon(O))
		var/mob/living/carbon/M = O
		M.r_hand?.clean_blood()
		M.l_hand?.clean_blood()
		if(M.back?.clean_blood())
			M.update_inv_back(0)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/washgloves = TRUE
			var/washshoes = TRUE
			var/washmask = TRUE
			var/washears = TRUE
			var/washglasses = TRUE

			if(isnotnull(H.wear_suit))
				washgloves = !HAS_INV_FLAGS(H.wear_suit, INV_FLAG_HIDE_GLOVES)
				washshoes = !HAS_INV_FLAGS(H.wear_suit, INV_FLAG_HIDE_SHOES)

			if(isnotnull(H.head))
				washmask = !HAS_INV_FLAGS(H.head, INV_FLAG_HIDE_MASK)
				washglasses = !HAS_INV_FLAGS(H.head, INV_FLAG_HIDE_EYES)
				washears = !HAS_INV_FLAGS(H.head, INV_FLAG_HIDE_EARS)

			if(isnotnull(H.wear_mask))
				if(washears)
					washears = !HAS_INV_FLAGS(H.wear_mask, INV_FLAG_HIDE_EARS)
				if(washglasses)
					washglasses = !HAS_INV_FLAGS(H.wear_mask, INV_FLAG_HIDE_EYES)

			if(H.head?.clean_blood())
				H.update_inv_head(0)
			if(H.wear_suit?.clean_blood())
				H.update_inv_wear_suit(0)
			else if(H.wear_uniform?.clean_blood())
				H.update_inv_wear_uniform(0)
			if(washgloves)
				if(H.gloves?.clean_blood())
					H.update_inv_gloves(0)
			if(washshoes)
				if(H.shoes?.clean_blood())
					H.update_inv_shoes(0)
			if(washmask)
				if(H.wear_mask?.clean_blood())
					H.update_inv_wear_mask(0)
			if(washglasses)
				if(H.glasses?.clean_blood())
					H.update_inv_glasses(0)
			if(washears)
				if(H.l_ear?.clean_blood())
					H.update_inv_ears(0)
			if(washears)
				if(H.r_ear?.clean_blood())
					H.update_inv_ears(0)
			if(H.belt?.clean_blood())
				H.update_inv_belt(0)
			H.clean_blood(washshoes)
		else
			if(M.wear_mask?.clean_blood())	//if the mob is not human, it cleans the mask without asking for bitflags
				M.update_inv_wear_mask(0)
			M.clean_blood()
	else
		O.clean_blood()

	if(isturf(loc))
		var/turf/tile = loc
		loc.clean_blood()
		for(var/obj/effect/E in tile)
			if(isrune(E) || istype(E, /obj/effect/decal/cleanable) || istype(E, /obj/effect/overlay))
				qdel(E)

/obj/machinery/shower/process()
	if(!on || !mobpresent)
		return
	for(var/mob/living/carbon/C in loc)
		check_heat(C)

/obj/machinery/shower/proc/check_heat(mob/M)
	if(!on || watertemp == "normal")
		return
	if(iscarbon(M))
		var/mob/living/carbon/C = M

		if(watertemp == "freezing")
			C.bodytemperature = max(80, C.bodytemperature - 80)
			to_chat(C, SPAN_WARNING("The water is freezing!"))
			return
		if(watertemp == "boiling")
			C.bodytemperature = min(500, C.bodytemperature + 35)
			C.adjustFireLoss(5)
			to_chat(C, SPAN_DANGER("The water is searing!"))
			return


/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"


/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = TRUE
	var/busy = 0 	//Something's being washed at the moment

/obj/structure/sink/attack_hand(mob/user)
	if(hasorgans(user))
		var/datum/organ/external/temp = user:organs_by_name["r_hand"]
		if(user.hand)
			temp = user:organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to move your [temp.display_name], but cannot!"))
			return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return

	to_chat(user, SPAN_INFO("You start washing your hands."))

	busy = 1
	sleep(40)
	busy = 0

	if(!Adjacent(user))
		return		//Person has moved away from the sink

	user.clean_blood()
	if(ishuman(user))
		user:update_inv_gloves()
	for(var/mob/V in viewers(src, null))
		V.show_message(SPAN_INFO("[user] washes their hands using \the [src]."))


/obj/structure/sink/attackby(obj/item/O, mob/user)
	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return

	if(istype(O, /obj/item/reagent_holder))
		var/obj/item/reagent_holder/RG = O
		RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message(
			SPAN_INFO("[user] fills \the [RG] using \the [src]."),
			SPAN_INFO("You fill \the [RG] using \the [src].")
		)
		return

	else if(istype(O, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = O
		/*if (B.charges > 0 && B.status == 1)
			flick("baton_active", src)
			user.Stun(10)
			user.stuttering = 10
			user.Weaken(10)
			if(isrobot(user))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= 20
			else
				B.charges--
			user.visible_message( \
				"[user] was stunned by his wet [O].", \
				"\red You have wet \the [O], it shocks you!")
			return
		*/
		if(B.bcell)
			if(B.bcell.charge > 0 && B.status == 1)
				flick("baton_active", src)
				user.Stun(10)
				user.stuttering = 10
				user.Weaken(10)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.deductcharge(B.hitcost)
				user.visible_message(
					SPAN_DANGER("[user] was stunned by \his wet [O]!"),
					SPAN("userdanger", "[user] was stunned by \his wet [O]!")
				)
				return

	var/turf/location = user.loc
	if(!isturf(location))
		return

	var/obj/item/I = O
	if(!I || !isitem(I))
		return

	to_chat(user, SPAN_INFO("You start washing \the [I]."))

	busy = 1
	sleep(40)
	busy = 0

	if(user.loc != location)
		return				//User has moved
	if(!I)
		return								//Item's been destroyed while washing
	if(user.get_active_hand() != I)
		return		//Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message(
		SPAN_INFO("[user] washes \a [I] using \the [src]."),
		SPAN_INFO("You wash \a [I] using \the [src].")
	)

/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"

/obj/structure/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"

/obj/structure/sink/puddle/attack_hand(mob/M)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

/obj/structure/sink/puddle/attackby(obj/item/O, mob/user)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"