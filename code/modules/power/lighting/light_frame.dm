/obj/machinery/light_frame
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = TRUE
	layer = 5

	var/stage = LIGHT_STAGE_ONE
	var/fixture_type = /obj/machinery/light
	var/sheets_refunded = 2
	var/obj/machinery/light/newlight = null

/obj/machinery/light_frame/New(atom/newloc, obj/machinery/light/fixture = null)
	. = ..(newloc)
	if(isnotnull(fixture))
		fixture_type = fixture.type
		fixture.transfer_fingerprints_to(src)
		set_dir(fixture.dir)
		stage = LIGHT_STAGE_TWO
	update_icon()

/obj/machinery/light_frame/update_icon()
	switch(stage)
		if(LIGHT_STAGE_ONE)
			icon_state = "tube-construct-stage1"
		if(LIGHT_STAGE_TWO)
			icon_state = "tube-construct-stage2"
		if(LIGHT_STAGE_THREE)
			icon_state = "tube-empty"

/obj/machinery/light_frame/examine()
	. = ..()
	if(!(usr in view(2)))
		return
	switch(stage)
		if(LIGHT_STAGE_ONE)
			to_chat(usr, "It's an empty frame.")
		if(LIGHT_STAGE_TWO)
			to_chat(usr, "It's wired.")
		if(LIGHT_STAGE_THREE)
			to_chat(usr, "The casing is closed.")

/obj/machinery/light_frame/attackby(obj/item/W, mob/user)
	add_fingerprint(user)
	if(iswrench(W))
		if(stage == LIGHT_STAGE_ONE)
			playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
			to_chat(usr, "You begin deconstructing [src].")
			if(!do_after(usr, 30))
				return
			new /obj/item/stack/sheet/steel(get_turf(loc), sheets_refunded)
			user.visible_message(
				"[user.name] deconstructs [src].",
				"You deconstruct [src].",
				"You hear a noise."
			)
			playsound(src, 'sound/items/Deconstruct.ogg', 75, 1)
			qdel(src)
		if(stage == LIGHT_STAGE_TWO)
			to_chat(usr, "You have to remove the wires first.")
			return

		if(stage == LIGHT_STAGE_THREE)
			to_chat(usr, "You have to unscrew the case first.")
			return

	if(iswirecutter(W))
		if(stage != LIGHT_STAGE_TWO)
			return
		stage = LIGHT_STAGE_ONE
		update_icon()
		new /obj/item/stack/cable_coil(get_turf(loc), 1, "red")
		user.visible_message(
			"[user.name] removes the wiring from [src].",
			"You remove the wiring from [src].",
			"You hear a noise."
		)
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		return

	if(iscable(W))
		if(stage != LIGHT_STAGE_ONE)
			return
		var/obj/item/stack/cable_coil/coil = W
		coil.use(1)
		update_icon()
		stage = LIGHT_STAGE_TWO
		user.visible_message(
			"[user.name] adds wires to [src].",
			"You add wires to [src]."
		)
		return

	if(isscrewdriver(W))
		if(stage == LIGHT_STAGE_TWO)
			update_icon()
			stage = LIGHT_STAGE_THREE
			user.visible_message(
				"[user.name] closes [src]'s casing.",
				"You close [src]'s casing.",
				"You hear a noise."
			)
			playsound(src, 'sound/items/Screwdriver.ogg', 75, 1)

			var/obj/machinery/light/newlight = new fixture_type(loc, src)
			newlight.set_dir(dir)
			transfer_fingerprints_to(newlight)
			qdel(src)
			return
	return ..()

/obj/machinery/light_frame/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = TRUE
	layer = 5
	stage = LIGHT_STAGE_ONE
	fixture_type = /obj/machinery/light/small
	sheets_refunded = 1

/obj/machinery/light_frame/small/update_icon()
	switch(stage)
		if(LIGHT_STAGE_ONE)
			icon_state = "bulb-construct-stage1"
		if(LIGHT_STAGE_TWO)
			icon_state = "bulb-construct-stage2"
		if(LIGHT_STAGE_THREE)
			icon_state = "bulb-empty"