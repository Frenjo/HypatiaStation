// It is a gizmo that flashes a small area

/obj/machinery/flasher
	name = "mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	anchored = TRUE

	var/id = null
	var/range = 2 //this is roughly the size of brig cell
	var/disable = FALSE
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 10 //How weakened targets are when flashed.
	var/base_state = "mflash"

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon_state = "pflash1"
	strength = 8
	anchored = FALSE
	base_state = "pflash"
	density = TRUE

/*
/obj/machinery/flasher/New()
	sleep(4)					//<--- What the fuck are you doing? D=
	src.sd_SetLuminosity(2)
*/
/obj/machinery/flasher/power_change()
	if(powered())
		stat &= ~NOPOWER
		icon_state = "[base_state]1"
//		src.sd_SetLuminosity(2)
	else
		stat |= ~NOPOWER
		icon_state = "[base_state]1-p"
//		src.sd_SetLuminosity(0)

// Don't want to render prison breaks impossible.
/obj/machinery/flasher/attack_tool(obj/item/tool, mob/user)
	if(iswirecutter(tool))
		add_fingerprint(user)
		disable = !disable
		user.visible_message(
			SPAN_NOTICE("[user] has [disable ? "disconnected" : "connected"] \the [src]'s flashbulb!"),
			SPAN_NOTICE("You [disable ? "disconnect" : "connect"] \the [src]'s flashbulb!")
		)
		return TRUE

	return ..()

//Let the AI trigger them directly.
/obj/machinery/flasher/attack_ai()
	if(src.anchored)
		return src.flash()
	else
		return

/obj/machinery/flasher/proc/flash()
	if(!powered())
		return

	if(src.disable || (src.last_flash && world.time < src.last_flash + 150))
		return

	playsound(src, 'sound/weapons/flash.ogg', 100, 1)
	flick("[base_state]_flash", src)
	src.last_flash = world.time
	use_power(1000)

	for(var/mob/O in viewers(src, null))
		if(get_dist(src, O) > src.range)
			continue

		if(ishuman(O))
			var/mob/living/carbon/human/H = O
			if(!H.eyecheck() <= 0)
				continue

		if(isalien(O))//So aliens don't get flashed (they have no external eyes)/N
			continue

		O.Weaken(strength)
		if(ishuman(O))
			var/mob/living/carbon/human/H = O
			var/datum/organ/internal/eyes/E = H.internal_organs["eyes"]
			if(E.damage > E.min_bruised_damage && prob(E.damage + 50))
				flick("e_flash", O:flash)
				E.damage += rand(1, 5)
		else
			if(!O.blinded)
				flick("flash", O:flash)


/obj/machinery/flasher/emp_act(severity)
	if(stat & (BROKEN | NOPOWER))
		..(severity)
		return
	if(prob(75 / severity))
		flash()
	..(severity)

/obj/machinery/flasher/portable/HasProximity(atom/movable/AM)
	if(src.disable || (src.last_flash && world.time < src.last_flash + 150))
		return

	if(iscarbon(AM))
		var/mob/living/carbon/M = AM
		if(!IS_WALKING(M) && src.anchored)
			src.flash()

/obj/machinery/flasher/portable/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		add_fingerprint(user)
		anchored = !anchored
		if(!anchored)
			to_chat(user, SPAN_NOTICE("\The [src] can now be moved."))
			cut_overlays()
		else
			to_chat(user, SPAN_NOTICE("\The [src] is now secured."))
			add_overlay("[base_state]-s")
		return TRUE

	return ..()

/obj/machinery/flasher_button
	name = "flasher button"
	desc = "A remote control switch for a mounted flasher."
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 4
	)

	var/id = null
	var/active = FALSE

/obj/machinery/flasher_button/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/flasher_button/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/flasher_button/attackby(obj/item/W, mob/user)
	return src.attack_hand(user)

/obj/machinery/flasher_button/attack_hand(mob/user)
	if(stat & (NOPOWER | BROKEN))
		return
	if(active)
		return

	use_power(5)

	active = TRUE
	icon_state = "launcheract"

	FOR_MACHINES_TYPED(flashy, /obj/machinery/flasher)
		if(flashy.id == src.id)
			spawn()
				flashy.flash()

	sleep(50)

	icon_state = "launcherbtt"
	active = FALSE
	return