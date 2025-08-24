/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Reinforced glass sheets
 *		Plasma Glass Sheets
 *		Reinforced Plasma Glass Sheets (AKA Holy fuck strong windows)
 *		Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
/obj/item/stack/sheet/glass
	name = "glass"
	desc = "HOLY SHEET! That is a lot of glass."
	singular_name = "glass sheet"
	icon_state = "glass"
	matter_amounts = alist(/decl/material/glass = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 1)
	material = /decl/material/glass

	var/created_window = /obj/structure/window/basic

/obj/item/stack/sheet/glass/cyborg
	matter_amounts = null

/obj/item/stack/sheet/glass/attack_self(mob/user)
	construct_window(user)

/obj/item/stack/sheet/glass/attack_tool(obj/item/tool, mob/user)
	if(iscable(tool))
		var/obj/item/stack/cable_coil/cable = tool
		if(!cable.use(5))
			to_chat(user, SPAN_WARNING("There is not enough wire in this coil, you need 5 lengths!"))
			return TRUE
		if(!use(1))
			to_chat(user, SPAN_WARNING("There is not enough glass in the stack."))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("[user] attaches some wire to \the [src]."),
			SPAN_NOTICE("You attach some wire to \the [src].")
		)
		new /obj/item/stack/light_w(GET_TURF(src))
		return TRUE

	return ..()

/obj/item/stack/sheet/glass/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/rods = I
		var/obj/item/stack/sheet/glass/reinforced/new_glass = new /obj/item/stack/sheet/glass/reinforced(GET_TURF(src))
		new_glass.add_fingerprint(user)
		new_glass.add_to_stacks(user)
		rods.use(1)
		var/obj/item/stack/sheet/glass/glass = src
		qdel(src)
		var/replace = (user.get_inactive_hand() == glass)
		glass.use(1)
		if(isnull(glass) && isnull(new_glass) && replace)
			user.put_in_hands(new_glass)
		return TRUE

	return ..()

/obj/item/stack/sheet/glass/proc/construct_window(mob/user)
	if(!user || !src)
		return 0
	if(!isturf(user.loc))
		return 0
	if(!user.IsAdvancedToolUser())
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return 0

	var/title = "Sheet-Glass"
	title += " ([src.amount] sheet\s left)"
	switch(alert(title, "Would you like full tile glass or one direction?", "One Direction", "Full Window", "Cancel", null))
		if("One Direction")
			if(!src)
				return 1
			if(src.loc != user)
				return 1

			var/list/directions = list(GLOBL.cardinal)
			var/i = 0
			for(var/obj/structure/window/win in user.loc)
				i++
				if(i >= 4)
					to_chat(user, SPAN_WARNING("There are too many windows in this location."))
					return 1
				directions -= win.dir
				if(!(win.ini_dir in GLOBL.cardinal))
					to_chat(user, SPAN_WARNING("Can't let you do that."))
					return 1

			//Determine the direction. It will first check in the direction the person making the window is facing, if it finds an already made window it will try looking at the next cardinal direction, etc.
			var/dir_to_set = 2
			for(var/direction in list(user.dir, turn(user.dir, 90), turn(user.dir, 180), turn(user.dir, 270)))
				var/found = 0
				for(var/obj/structure/window/WT in user.loc)
					if(WT.dir == direction)
						found = 1
				if(!found)
					dir_to_set = direction
					break
			var/obj/structure/window/W
			W = new created_window(user.loc, 0)
			W.set_dir(dir_to_set)
			W.ini_dir = W.dir
			W.anchored = FALSE
			src.use(1)

		if("Full Window")
			if(!src)
				return 1
			if(src.loc != user)
				return 1
			if(src.amount < 2)
				to_chat(user, SPAN_WARNING("You need more glass to do that."))
				return 1
			if(locate(/obj/structure/window) in user.loc)
				to_chat(user, SPAN_WARNING("There is a window in the way."))
				return 1

			var/obj/structure/window/W
			W = new created_window(user.loc, 0)
			W.set_dir(SOUTHWEST)
			W.ini_dir = SOUTHWEST
			W.anchored = FALSE
			src.use(2)
	return 0

/*
 * Reinforced glass sheets
 */
/obj/item/stack/sheet/glass/reinforced
	name = "reinforced glass"
	desc = "Glass which seems to have rods or something stuck in it."
	singular_name = "reinforced glass sheet"
	icon_state = "rglass"
	matter_amounts = alist(/decl/material/steel = 0.5 MATERIAL_SHEETS, /decl/material/glass = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 2)

	material = /decl/material/reinforced_glass

/obj/item/stack/sheet/glass/reinforced/cyborg
	matter_amounts = null

/obj/item/stack/sheet/glass/reinforced/attack_tool(obj/item/tool, mob/user)
	if(iscable(tool))
		return TRUE
	return ..()

/obj/item/stack/sheet/glass/reinforced/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/rods))
		return TRUE
	return ..()

/obj/item/stack/sheet/glass/reinforced/construct_window(mob/user)
	if(!user || !src)
		return 0
	if(!isturf(user.loc))
		return 0
	if(!user.IsAdvancedToolUser())
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return 0

	var/title = "Sheet Reinf. Glass"
	title += " ([src.amount] sheet\s left)"
	switch(input(title, "Would you like full tile glass, a one direction glass pane or a windoor?") in list("One Direction", "Full Window", "Windoor", "Cancel"))
		if("One Direction")
			if(!src)
				return 1
			if(src.loc != user)
				return 1

			var/list/directions = list(GLOBL.cardinal)
			var/i = 0
			for(var/obj/structure/window/win in user.loc)
				i++
				if(i >= 4)
					to_chat(user, SPAN_WARNING("There are too many windows in this location."))
					return 1
				directions -= win.dir
				if(!(win.ini_dir in GLOBL.cardinal))
					to_chat(user, SPAN_WARNING("Can't let you do that."))
					return 1

			//Determine the direction. It will first check in the direction the person making the window is facing, if it finds an already made window it will try looking at the next cardinal direction, etc.
			var/dir_to_set = 2
			for(var/direction in list(user.dir, turn(user.dir, 90), turn(user.dir, 180), turn(user.dir, 270)))
				var/found = 0
				for(var/obj/structure/window/WT in user.loc)
					if(WT.dir == direction)
						found = 1
				if(!found)
					dir_to_set = direction
					break

			var/obj/structure/window/W
			W = new /obj/structure/window/reinforced(user.loc, 1)
			W.state = 0
			W.set_dir(dir_to_set)
			W.ini_dir = W.dir
			W.anchored = FALSE
			src.use(1)

		if("Full Window")
			if(!src)
				return 1
			if(src.loc != user)
				return 1
			if(src.amount < 2)
				to_chat(user, SPAN_WARNING("You need more glass to do that."))
				return 1
			if(locate(/obj/structure/window) in user.loc)
				to_chat(user, SPAN_WARNING("There is a window in the way."))
				return 1
			var/obj/structure/window/W
			W = new /obj/structure/window/reinforced(user.loc, 1)
			W.state = 0
			W.set_dir(SOUTHWEST)
			W.ini_dir = SOUTHWEST
			W.anchored = FALSE
			src.use(2)

		if("Windoor")
			if(!src || src.loc != user)
				return 1

			if(isturf(user.loc) && locate(/obj/structure/windoor_assembly, user.loc))
				to_chat(user, SPAN_WARNING("There is already a windoor assembly in that location."))
				return 1

			if(isturf(user.loc) && locate(/obj/machinery/door/window, user.loc))
				to_chat(user, SPAN_WARNING("There is already a windoor in that location."))
				return 1

			if(src.amount < 5)
				to_chat(user, SPAN_WARNING("You need more glass to do that."))
				return 1

			var/obj/structure/windoor_assembly/WD
			WD = new /obj/structure/windoor_assembly(user.loc)
			WD.state = "01"
			WD.anchored = FALSE
			src.use(5)
			switch(user.dir)
				if(SOUTH)
					WD.set_dir(SOUTH)
					WD.ini_dir = SOUTH
				if(EAST)
					WD.set_dir(EAST)
					WD.ini_dir = EAST
				if(WEST)
					WD.set_dir(WEST)
					WD.ini_dir = WEST
				else	//If the user is facing northeast. northwest, southeast, southwest or north, default to north
					WD.set_dir(NORTH)
					WD.ini_dir = NORTH
		else
			return 1
	return 0

/*
 * Glass shards - TODO: Move this into code/game/object/item/weapons
 */
/obj/item/shard/Bump()
	spawn(0)
		if(prob(20))
			src.force = 15
		else
			src.force = 4
		..()
		return
	return

/obj/item/shard/New()
	. = ..()
	icon_state = pick("large", "medium", "small")
	switch(icon_state)
		if("small")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
		if("medium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
		if("large")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)

/obj/item/shard/attack_tool(obj/item/tool, mob/user)
	if(iswelder(tool))
		var/obj/item/welding_torch/welder = tool
		if(!welder.remove_fuel(0, user))
			return TRUE
		var/turf/T = GET_TURF(src)
		var/obj/item/stack/sheet/glass/new_glass = new /obj/item/stack/sheet/glass(T)
		for(var/obj/item/stack/sheet/glass/glass in T)
			if(glass == new_glass)
				continue
			if(glass.amount >= glass.max_amount)
				continue
			glass.attackby(new_glass, user)
			to_chat(usr, SPAN_INFO("You add the newly-formed glass to the stack. It now contains [new_glass.amount] sheets."))
		qdel(src)
		return TRUE

	return ..()

/obj/item/shard/Crossed(atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		to_chat(M, SPAN_DANGER("You step in the broken glass!"))
		playsound(src, 'sound/effects/glass/glass_step.ogg', 50, 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_SYNTHETIC))
				return

			if(isnull(H.shoes) && (isnull(H.wear_suit) || !(H.wear_suit.body_parts_covered & FEET)))
				var/datum/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot"))
				if(affecting.status & ORGAN_ROBOT)
					return

				H.Weaken(3)
				if(affecting.take_damage(5, 0))
					H.UpdateDamageIcon()
				H.updatehealth()
	..()


/*
 * Plasma Glass sheets
 */
/obj/item/stack/sheet/glass/plasma
	name = "plasma glass"
	desc = "A very strong and very resistant sheet of a plasma-glass alloy."
	singular_name = "plasma glass sheet"
	icon_state = "plasmaglass"
	matter_amounts = alist(/decl/material/glass = 1 MATERIAL_SHEET, /decl/material/plasma = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 3, /decl/tech/plasma = 2)
	material = /decl/material/plasma_glass

	created_window = /obj/structure/window/plasmabasic

/obj/item/stack/sheet/glass/plasma/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/rods = I
		var/obj/item/stack/sheet/glass/plasma/reinforced/new_glass = new (user.loc)
		new_glass.add_fingerprint(user)
		new_glass.add_to_stacks(user)
		rods.use(1)
		var/obj/item/stack/sheet/glass/glass = src
		qdel(src)
		var/replace = (user.get_inactive_hand() == glass)
		glass.use(1)
		if(isnull(glass) && isnull(new_glass) && replace)
			user.put_in_hands(new_glass)
		return TRUE
	return ..()

/*
 * Reinforced plasma glass sheets
 */
/obj/item/stack/sheet/glass/plasma/reinforced
	name = "reinforced plasma glass"
	desc = "Plasma glass which seems to have rods or something stuck in it."
	singular_name = "reinforced plasma glass sheet"
	icon_state = "plasmarglass"
	matter_amounts = alist(
		/decl/material/steel = 1 MATERIAL_SHEET, /decl/material/glass = 1 MATERIAL_SHEET,
		/decl/material/plasma = 1 MATERIAL_SHEET
	)
	origin_tech = alist(/decl/tech/materials = 4, /decl/tech/plasma = 2)
	material = /decl/material/reinforced_plasma_glass

	created_window = /obj/structure/window/plasmareinforced

/obj/item/stack/sheet/glass/plasma/reinforced/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/rods))
		return TRUE
	return ..()