/*
 * Under Clothing
 */
/obj/item/clothing/under
	icon = 'icons/obj/items/clothing/uniforms.dmi'
	name = "under"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	w_class = 3

	var/has_sensor = 1 // For the crew computer, 2 = unable to change mode.
	var/sensor_mode = 0
	/*
	 * 1 = Report living/dead.
	 * 2 = Report detailed damages.
	 * 3 = Report location.
	 */
	var/obj/item/clothing/tie/hastie = null
	var/displays_id = 1

/obj/item/clothing/under/attackby(obj/item/I, mob/user)
	if(isnotnull(hastie))
		hastie.attackby(I, user)
		return

	if(isnull(hastie) && istype(I, /obj/item/clothing/tie))
		user.drop_item()
		hastie = I
		hastie.on_attached(src, user)

		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()
		return

	..()

/obj/item/clothing/under/attack_hand(mob/user as mob)
	// Only forward to the attached accessory if the clothing is equipped (not in a storage).
	if(isnotnull(hastie) && loc == user)
		hastie.attack_hand(user)
		return
	..()

// This is to ensure people can take off suits when there is an attached accessory
/obj/item/clothing/under/MouseDrop(obj/over_object as obj)
	if(ishuman(usr) || ismonkey(usr))
		// Makes sure that the clothing is equipped so that we can't drag it into our hand from miles away.
		if(loc != usr)
			return

		if(!usr.restrained() && !usr.stat)
			switch(over_object.name)
				if("r_hand")
					usr.u_equip(src)
					usr.put_in_r_hand(src)
				if("l_hand")
					usr.u_equip(src)
					usr.put_in_l_hand(src)
			add_fingerprint(usr)
			return

/obj/item/clothing/under/examine()
	set src in view()
	..()
	switch(sensor_mode)
		if(0)
			to_chat(usr, "Its sensors appear to be disabled.")
		if(1)
			to_chat(usr, "Its binary life sensors appear to be enabled.")
		if(2)
			to_chat(usr, "Its vital tracker appears to be enabled.")
		if(3)
			to_chat(usr, "Its vital tracker and tracking beacon appear to be enabled.")
	if(isnotnull(hastie))
		to_chat(usr, "\A [hastie] is clipped to it.")

/obj/item/clothing/under/verb/toggle()
	set category = PANEL_OBJECT
	set name = "Toggle Suit Sensors"
	set src in usr

	var/mob/M = usr
	if(istype(M, /mob/dead))
		return
	if(usr.stat)
		return
	if(has_sensor >= 2)
		to_chat(usr, "The controls are locked.")
		return 0
	if(has_sensor <= 0)
		to_chat(usr, "This suit does not have any sensors.")
		return 0

	var/list/modes = list("Off", "Binary sensors", "Vitals tracker", "Tracking beacon")
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	sensor_mode = modes.Find(switchMode) - 1

	switch(sensor_mode)
		if(0)
			to_chat(usr, "You disable your suit's remote sensing equipment.")
		if(1)
			to_chat(usr, "Your suit will now report whether you are live or dead.")
		if(2)
			to_chat(usr, "Your suit will now report your vital lifesigns.")
		if(3)
			to_chat(usr, "Your suit will now report your vital lifesigns as well as your coordinate position.")

/obj/item/clothing/under/proc/remove_accessory(mob/user as mob)
	if(isnull(hastie))
		return

	hastie.on_removed(user)
	hastie = null

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_w_uniform()

/obj/item/clothing/under/verb/removetie()
	set category = PANEL_OBJECT
	set name = "Remove Accessory"
	set src in usr

	if(!isliving(usr))
		return
	if(usr.stat)
		return

	remove_accessory(usr)

/obj/item/clothing/under/rank/New()
	sensor_mode = pick(0, 1, 2, 3)
	. = ..()