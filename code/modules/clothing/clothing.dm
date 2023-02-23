/obj/item/clothing
	name = "clothing"
	var/list/species_restricted = null //Only these species can wear this kit.

//BS12: Species-restricted clothing check.
/obj/item/clothing/mob_can_equip(M as mob, slot)
	if(species_restricted && ishuman(M))
		var/wearable = null
		var/exclusive = null
		var/mob/living/carbon/human/H = M

		if("exclude" in species_restricted)
			exclusive = 1

		if(H.species)
			if(exclusive)
				if(!(H.species.name in species_restricted))
					wearable = 1
			else
				if(H.species.name in species_restricted)
					wearable = 1

			if(!wearable && (slot != 15 && slot != 16)) //Pockets.
				to_chat(M, SPAN_WARNING("Your species cannot wear [src]."))
				return 0

	return ..()

//Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = 1.0
	throwforce = 2
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/attack_hand(mob/user as mob)
	if(!user)
		return

	if(src.loc != user || !ishuman(user))
		..()
		return

	var/mob/living/carbon/human/H = user
	if(H.l_ear != src && H.r_ear != src)
		..()
		return

	if(!canremove)
		return

	var/obj/item/clothing/ears/O
	if(slot_flags & SLOT_TWOEARS)
		O = (H.l_ear == src ? H.r_ear : H.l_ear)
		user.u_equip(O)
		if(!istype(src, /obj/item/clothing/ears/offear))
			qdel(O)
			O = src
	else
		O = src

	user.u_equip(src)

	if(O)
		user.put_in_hands(O)
		O.add_fingerprint(user)

	if(istype(src,/obj/item/clothing/ears/offear))
		qdel(src)

/obj/item/clothing/ears/offear
	name = "Other ear"
	w_class = 5.0
	icon = 'icons/mob/screen/screen1_Midnight.dmi'
	icon_state = "block"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/offear/New(obj/O)
	name = O.name
	desc = O.desc
	icon = O.icon
	icon_state = O.icon_state
	dir = O.dir

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

//Glasses
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = 2.0
	flags = GLASSESCOVERSEYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/invisa_view = 0

/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/

//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = 2.0
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.50
	var/wired = 0
	var/obj/item/weapon/cell/cell = 0
	var/clipped = 0
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	species_restricted = list("exclude", SPECIES_SOGHUN, SPECIES_TAJARAN)

/obj/item/clothing/gloves/examine()
	set src in usr
	..()
	return

/obj/item/clothing/gloves/emp_act(severity)
	if(cell)
		//why is this not part of the powercell code?
		cell.charge -= 1000 / severity
		if(cell.charge < 0)
			cell.charge = 0
		if(cell.reliability != 100 && prob(50 / severity))
			cell.reliability -= 10 / severity
	..()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(atom/A, proximity)
	return 0 // return 1 to cancel attack_hand()

//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	w_class = 2.0

//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)

//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	var/chained = 0
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET

	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	species_restricted = list("exclude", SPECIES_SOGHUN, SPECIES_TAJARAN)

//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C + 100
	allowed = list(/obj/item/weapon/tank/emergency_oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = 3

//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//		Meaning the the suit is defined directly after the corrisponding helmet. Just like below!
/obj/item/clothing/head/helmet/space
	name = "Space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	flags = HEADCOVERSEYES | BLOCKHAIR | HEADCOVERSMOUTH | STOPSPRESSUREDAMAGE
	item_state = "space"
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEMASK | HIDEEARS | HIDEEYES | HIDEFACE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude", SPECIES_DIONA, SPECIES_VOX)

/obj/item/clothing/suit/space
	name = "Space suit"
	desc = "A suit that protects against low pressure environments. Has a big 13 on the back."
	icon_state = "space"
	item_state = "s_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	flags = STOPSPRESSUREDAMAGE
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank/emergency_oxygen, /obj/item/device/suit_cooling_unit)
	slowdown = 3
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT | HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude", SPECIES_DIONA, SPECIES_VOX)

//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	name = "under"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	w_class = 3
	var/has_sensor = 1//For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/obj/item/clothing/tie/hastie = null
	var/displays_id = 1

/obj/item/clothing/under/attackby(obj/item/I, mob/user)
	if(hastie)
		hastie.attackby(I, user)
		return

	if(!hastie && istype(I, /obj/item/clothing/tie))
		user.drop_item()
		hastie = I
		hastie.on_attached(src, user)

		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()

		return

	..()

/obj/item/clothing/under/attack_hand(mob/user as mob)
	//only forward to the attached accessory if the clothing is equipped (not in a storage)
	if(hastie && src.loc == user)
		hastie.attack_hand(user)
		return
	..()

//This is to ensure people can take off suits when there is an attached accessory
/obj/item/clothing/under/MouseDrop(obj/over_object as obj)
	if(ishuman(usr) || ismonkey(usr))
		//makes sure that the clothing is equipped so that we can't drag it into our hand from miles away.
		if(src.loc != usr)
			return

		if(!usr.restrained() && !usr.stat)
			switch(over_object.name)
				if("r_hand")
					usr.u_equip(src)
					usr.put_in_r_hand(src)
				if("l_hand")
					usr.u_equip(src)
					usr.put_in_l_hand(src)
			src.add_fingerprint(usr)
			return
	return

/obj/item/clothing/under/examine()
	set src in view()
	..()
	switch(src.sensor_mode)
		if(0)
			to_chat(usr, "Its sensors appear to be disabled.")
		if(1)
			to_chat(usr, "Its binary life sensors appear to be enabled.")
		if(2)
			to_chat(usr, "Its vital tracker appears to be enabled.")
		if(3)
			to_chat(usr, "Its vital tracker and tracking beacon appear to be enabled.")
	if(hastie)
		to_chat(usr, "\A [hastie] is clipped to it.")

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
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
	if(!hastie)
		return

	hastie.on_removed(user)
	hastie = null

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_w_uniform()

/obj/item/clothing/under/verb/removetie()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr
	if(!isliving(usr))
		return
	if(usr.stat)
		return

	src.remove_accessory(usr)

/obj/item/clothing/under/rank/New()
	sensor_mode = pick(0, 1, 2, 3)
	..()