// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type
/obj/item/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = 1
	matter_amounts = list(MATERIAL_METAL = 60)

	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	var/rigged = TRUE	// true if rigged to explode
	var/broken_chance = 2

	var/brightness_range = 2 //how much light it gives off
	var/brightness_power = 1
	var/brightness_color = "#FFFFFF"
	var/list/lighting_modes = list()

/obj/item/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	matter_amounts = /datum/design/autolathe/light_tube::materials

	brightness_range = 6
	brightness_power = 2
	brightness_color = "#FFFFFF"
	lighting_modes = list(
		LIGHT_MODE_EMERGENCY = list(l_range = 3, l_power = 1, l_color = "#d13e43"),
	)

/obj/item/light/tube/large
	w_class = 2
	name = "large light tube"
	broken_chance = 5

	brightness_range = 8
	brightness_power = 2

/obj/item/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	matter_amounts = /datum/design/autolathe/light_bulb::materials

	brightness_range = 4
	brightness_power = 2
	brightness_color = "#a0a080"
	lighting_modes = list(
		LIGHT_MODE_EMERGENCY = list(l_range = 4, l_power = 1, l_color = "#d13e43"),
	)

/obj/item/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "fbulb"
	base_state = "fbulb"
	item_state = "egg4"
	matter_amounts = list(MATERIAL_METAL = 60, /decl/material/glass = 100)

	brightness_range = 4
	brightness_power = 2

/obj/item/light/bulb/red
	color = "#d13e43"
	brightness_color = "#d13e43"

/obj/item/light/throw_impact(atom/hit_atom)
	. = ..()
	shatter()

// update the icon state and description of the light
/obj/item/light/update_icon()
	switch(status)
		if(LIGHT_OK)
			icon_state = base_state
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			desc = "A broken [name]."

/obj/item/light/New(atom/newloc, obj/machinery/light/fixture = null)
	. = ..()
	if(isnotnull(fixture))
		status = fixture.status
		rigged = fixture.rigged
		switchcount = fixture.switchcount
		fixture.transfer_fingerprints_to(src)

		//shouldn't be necessary to copy these unless someone varedits stuff, but just in case
		brightness_range = fixture.brightness_range
		brightness_power = fixture.brightness_power
		brightness_color = fixture.brightness_color
		lighting_modes = fixture.lighting_modes.Copy()
	update_icon()

// attack bulb/tube with object
// if a syringe, can inject plasma to make it explode
/obj/item/light/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_holder/syringe))
		var/obj/item/reagent_holder/syringe/S = I

		to_chat(user, "You inject the solution into the [src].")

		if(S.reagents.has_reagent("plasma", 5))
			log_admin("LOG: [user.name] ([user.ckey]) injected a light with plasma, rigging it to explode.")
			message_admins("LOG: [user.name] ([user.ckey]) injected a light with plasma, rigging it to explode.")
			rigged = TRUE

		S.reagents.clear_reagents()
	else
		return ..()

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm
/obj/item/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != "hurt")
		return

	shatter()

/obj/item/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		visible_message(
			SPAN_WARNING("[name] shatters."),
			"You hear a small glass object shatter."
		)
		status = LIGHT_BROKEN
		force = 5
		sharp = 1
		playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
		update_icon()