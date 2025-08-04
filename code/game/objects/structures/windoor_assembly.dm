/* Windoor (window door) assembly -Nodrak
 * Step 1: Create a windoor out of rglass
 * Step 2: Add r-glass to the assembly to make a secure windoor (Optional)
 * Step 3: Rotate or Flip the assembly to face and open the way you want
 * Step 4: Wrench the assembly in place
 * Step 5: Add cables to the assembly
 * Step 6: Set access for the door.
 * Step 7: Screwdriver the door to complete
 */

/obj/structure/windoor_assembly
	icon = 'icons/obj/doors/windoor.dmi'

	name = "windoor assembly"
	icon_state = "l_windoor_assembly01"
	anchored = FALSE
	density = FALSE
	dir = NORTH

	var/ini_dir
	var/obj/item/airlock_electronics/electronics = null

	//Vars to help with the icon's name
	var/facing = "l"	//Does the windoor open to the left or right?
	var/secure = ""		//Whether or not this creates a secure windoor
	var/state = "01"	//How far the door assembly has progressed in terms of sprites

/obj/structure/windoor_assembly/New(dir = NORTH)
	..()
	src.ini_dir = src.dir
	update_nearby_tiles(need_rebuild = 1)

/obj/structure/windoor_assembly/Destroy()
	density = FALSE
	update_nearby_tiles()
	QDEL_NULL(electronics)
	return ..()

/obj/structure/windoor_assembly/update_icon()
	icon_state = "[facing]_[secure]windoor_assembly[state]"

/obj/structure/windoor_assembly/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_GLASS))
		return TRUE
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group)
			return FALSE
		return !density
	else
		return TRUE

/obj/structure/windoor_assembly/CheckExit(atom/movable/mover, turf/target)
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_GLASS))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/structure/windoor_assembly/attackby(obj/item/W, mob/user)
	//I really should have spread this out across more states but thin little windoors are hard to sprite.
	switch(state)
		if("01")
			if(iswelder(W) && !anchored)
				var/obj/item/weldingtool/WT = W
				if(WT.remove_fuel(0, user))
					user.visible_message(
						"[user] dissassembles the windoor assembly.",
						"You start to dissassemble the windoor assembly."
					)
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)

					if(do_after(user, 40))
						if(!src || !WT.isOn())
							return
						to_chat(user, SPAN_INFO("You dissasembled the windoor assembly!"))
						new /obj/item/stack/sheet/glass/reinforced(GET_TURF(src), 5)
						if(secure)
							new /obj/item/stack/rods(GET_TURF(src), 4)
						qdel(src)
				else
					return

			//Wrenching an unsecure assembly anchors it in place. Step 4 complete
			if(iswrench(W) && !anchored)
				playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
				user.visible_message(
					"[user] secures the windoor assembly to the floor.",
					"You start to secure the windoor assembly to the floor."
				)

				if(do_after(user, 40))
					if(!src)
						return
					to_chat(user, SPAN_INFO("You've secured the windoor assembly!"))
					src.anchored = TRUE
					if(src.secure)
						src.name = "Secure Anchored Windoor Assembly"
					else
						src.name = "Anchored Windoor Assembly"

			//Unwrenching an unsecure assembly un-anchors it. Step 4 undone
			else if(iswrench(W) && anchored)
				playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
				user.visible_message(
					"[user] unsecures the windoor assembly to the floor.",
					"You start to unsecure the windoor assembly to the floor."
				)

				if(do_after(user, 40))
					if(!src)
						return
					to_chat(user, SPAN_INFO("You've unsecured the windoor assembly!"))
					src.anchored = FALSE
					if(src.secure)
						src.name = "Secure Windoor Assembly"
					else
						src.name = "Windoor Assembly"

			//Adding plasteel makes the assembly a secure windoor assembly. Step 2 (optional) complete.
			else if(istype(W, /obj/item/stack/rods) && !secure)
				var/obj/item/stack/rods/R = W
				if(R.amount < 4)
					to_chat(user, SPAN_WARNING("You need more rods to do this."))
					return
				to_chat(user, SPAN_INFO("You start to reinforce the windoor with rods."))

				if(do_after(user, 40))
					if(!src)
						return

					R.use(4)
					to_chat(user, SPAN_INFO("You reinforce the windoor."))
					src.secure = "secure_"
					if(src.anchored)
						src.name = "Secure Anchored Windoor Assembly"
					else
						src.name = "Secure Windoor Assembly"

			//Adding cable to the assembly. Step 5 complete.
			else if(iscable(W) && anchored)
				user.visible_message(
					"[user] wires the windoor assembly.",
					"You start to wire the windoor assembly."
				)

				if(do_after(user, 40))
					if(!src)
						return
					var/obj/item/stack/cable_coil/CC = W
					CC.use(1)
					to_chat(user, SPAN_INFO("You wire the windoor!"))
					src.state = "02"
					if(src.secure)
						src.name = "Secure Wired Windoor Assembly"
					else
						src.name = "Wired Windoor Assembly"
			else
				..()

		if("02")
			//Removing wire from the assembly. Step 5 undone.
			if(iswirecutter(W) && !src.electronics)
				playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
				user.visible_message(
					"[user] cuts the wires from the airlock assembly.",
					"You start to cut the wires from airlock assembly."
				)

				if(do_after(user, 40))
					if(!src)
						return

					to_chat(user, SPAN_INFO("You cut the windoor wires!"))
					new/obj/item/stack/cable_coil(GET_TURF(user), 1)
					src.state = "01"
					if(src.secure)
						src.name = "Secure Anchored Windoor Assembly"
					else
						src.name = "Anchored Windoor Assembly"

			//Adding airlock electronics for access. Step 6 complete.
			else if(istype(W, /obj/item/airlock_electronics) && W:icon_state != "door_electronics_smoked")
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
				user.visible_message(
					"[user] installs the electronics into the airlock assembly.",
					"You start to install electronics into the airlock assembly."
				)

				if(do_after(user, 40))
					if(!src) return

					user.drop_item()
					W.forceMove(src)
					to_chat(user, SPAN_INFO("You've installed the airlock electronics!"))
					src.name = "Near finished Windoor Assembly"
					src.electronics = W
				else
					W.forceMove(loc)

			//Screwdriver to remove airlock electronics. Step 6 undone.
			else if(isscrewdriver(W) && src.electronics)
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
				user.visible_message(
					"[user] removes the electronics from the airlock assembly.",
					"You start to uninstall electronics from the airlock assembly."
				)

				if(do_after(user, 40))
					if(!src || !src.electronics)
						return
					to_chat(user, SPAN_INFO("You've removed the airlock electronics!"))
					if(src.secure)
						src.name = "Secure Wired Windoor Assembly"
					else
						src.name = "Wired Windoor Assembly"
					var/obj/item/airlock_electronics/ae = electronics
					electronics = null
					ae.forceMove(loc)

			//Crowbar to complete the assembly, Step 7 complete.
			else if(iscrowbar(W))
				if(!src.electronics)
					to_chat(user, SPAN_WARNING("The assembly is missing electronics."))
					return
				CLOSE_BROWSER(usr, "window=windoor_access")
				playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
				user.visible_message(
					"[user] pries the windoor into the frame.",
					"You start prying the windoor into the frame."
				)

				if(do_after(user, 40))
					if(!src)
						return

					density = TRUE //Shouldn't matter but just incase
					to_chat(user, SPAN_INFO("You finish the windoor!"))

					if(secure)
						var/obj/machinery/door/window/brigdoor/windoor = new /obj/machinery/door/window/brigdoor(src.loc)
						if(src.facing == "l")
							windoor.icon_state = "leftsecureopen"
							windoor.base_state = "leftsecure"
						else
							windoor.icon_state = "rightsecureopen"
							windoor.base_state = "rightsecure"
						windoor.set_dir(src.dir)
						windoor.density = FALSE

						if(src.electronics.one_access)
							windoor.req_access = null
							windoor.req_one_access = src.electronics.conf_access
						else
							windoor.req_access = src.electronics.conf_access
						windoor.electronics = src.electronics
						electronics.forceMove(windoor)
					else
						var/obj/machinery/door/window/windoor = new /obj/machinery/door/window(src.loc)
						if(src.facing == "l")
							windoor.icon_state = "leftopen"
							windoor.base_state = "left"
						else
							windoor.icon_state = "rightopen"
							windoor.base_state = "right"
						windoor.set_dir(src.dir)
						windoor.density = FALSE

						if(src.electronics.one_access)
							windoor.req_access = null
							windoor.req_one_access = src.electronics.conf_access
						else
							windoor.req_access = src.electronics.conf_access
						windoor.electronics = src.electronics
						electronics.forceMove(windoor)

					qdel(src)

			else
				..()

	//Update to reflect changes(if applicable)
	update_icon()


//Rotates the windoor assembly clockwise
/obj/structure/windoor_assembly/verb/revrotate()
	set category = PANEL_OBJECT
	set name = "Rotate Windoor Assembly"
	set src in oview(1)

	if(src.anchored)
		to_chat(usr, SPAN_WARNING("It is fastened to the floor; therefore, you can't rotate it!"))
		return 0
	if(src.state != "01")
		update_nearby_tiles(need_rebuild = 1) //Compel updates before

	src.set_dir(turn(src.dir, 270))

	if(src.state != "01")
		update_nearby_tiles(need_rebuild = 1)

	src.ini_dir = src.dir
	update_icon()
	return

//Flips the windoor assembly, determines whather the door opens to the left or the right
/obj/structure/windoor_assembly/verb/flip()
	set category = PANEL_OBJECT
	set name = "Flip Windoor Assembly"
	set src in oview(1)

	if(src.facing == "l")
		to_chat(usr, "The windoor will now slide to the right.")
		src.facing = "r"
	else
		src.facing = "l"
		to_chat(usr, "The windoor will now slide to the left.")

	update_icon()
	return

/obj/structure/windoor_assembly/proc/update_nearby_tiles(need_rebuild)
	if(!global.PCair)
		return 0

	global.PCair.mark_for_update(loc)

	return 1