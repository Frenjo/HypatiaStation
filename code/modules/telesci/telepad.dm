///SCI TELEPAD///
/obj/machinery/telepad
	name = "telepad"
	desc = "A bluespace telepad used for teleporting objects to and from a location."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = TRUE
	use_power = 1
	idle_power_usage = 200
	active_power_usage = 5000

//CARGO TELEPAD//
/obj/machinery/telepad_cargo
	name = "cargo telepad"
	desc = "A telepad used by the Rapid Crate Sender."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = TRUE
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 500
	var/stage = 0

/obj/machinery/telepad_cargo/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		anchored = FALSE
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			anchored = FALSE
			to_chat(user, SPAN_CAUTION("The [src] can now be moved."))
		else if(!anchored)
			anchored = TRUE
			to_chat(user, SPAN_CAUTION("The [src] is now secured."))
	if(istype(W, /obj/item/weapon/screwdriver))
		if(stage == 0)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, SPAN_CAUTION("You unscrew the telepad's tracking beacon."))
			stage = 1
		else if(stage == 1)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, SPAN_CAUTION("You screw in the telepad's tracking beacon."))
			stage = 0
	if(istype(W, /obj/item/weapon/weldingtool) && stage == 1)
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		to_chat(user, SPAN_CAUTION("You disassemble the telepad."))
		new /obj/item/stack/sheet/metal(get_turf(src))
		new /obj/item/stack/sheet/glass(get_turf(src))
		qdel(src)

///TELEPAD CALLER///
/obj/item/device/telepad_beacon
	name = "telepad beacon"
	desc = "Use to warp in a cargo telepad."
	icon = 'icons/obj/devices/radio.dmi'
	icon_state = "beacon"
	item_state = "signaler"
	origin_tech = list(RESEARCH_TECH_BLUESPACE = 3)

/obj/item/device/telepad_beacon/attack_self(mob/user as mob)
	if(user)
		to_chat(user, SPAN_CAUTION("Locked In"))
		new /obj/machinery/telepad_cargo(user.loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return

///HANDHELD TELEPAD USER///
/obj/item/weapon/rcs
	name = "rapid-crate-sender (RCS)"
	desc = "Use this to send crates and closets to cargo telepads."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "rcs"
	flags = CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	var/rcharges = 10
	var/obj/machinery/pad = null
	var/last_charge = 30
	var/mode = 0
	var/rand_x = 0
	var/rand_y = 0
	var/emagged = 0
	var/teleporting = 0

/obj/item/weapon/rcs/New()
	..()
	GLOBL.processing_objects.Add(src)

/obj/item/weapon/rcs/examine()
	desc = "Use this to send crates and closets to cargo telepads. There are [rcharges] charges left."
	..()

/obj/item/weapon/rcs/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/weapon/rcs/process()
	if(rcharges > 10)
		rcharges = 10
	if(last_charge == 0)
		rcharges++
		last_charge = 30
	else
		last_charge--

/obj/item/weapon/rcs/attack_self(mob/user)
	if(emagged)
		if(mode == 0)
			mode = 1
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, SPAN_CAUTION("The telepad locator has become uncalibrated."))
		else
			mode = 0
			playsound(src, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, SPAN_CAUTION("You calibrate the telepad locator."))

/obj/item/weapon/rcs/attackby(obj/item/W, mob/user)
	if(istype(W,  /obj/item/weapon/card/emag) && emagged == 0)
		emagged = 1
		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		to_chat(user, SPAN_CAUTION("You emag the RCS. Click on it to toggle between modes."))
		return