/obj/item/camera_assembly
	name = "camera assembly"
	desc = "The basic construction for NanoTrasen-Always-Watching-You cameras."
	icon = 'icons/obj/machines/monitors.dmi'
	icon_state = "cameracase"
	w_class = 2
	anchored = FALSE

	matter_amounts = list(MATERIAL_METAL = 700, /decl/material/glass = 300)

	//	Motion, EMP-Proof, X-Ray
	var/list/obj/item/possible_upgrades = list(
		/obj/item/assembly/prox_sensor,
		/obj/item/stack/sheet/plasma,
		/obj/item/reagent_holder/food/snacks/grown/carrot
	)
	var/list/upgrades = list()
	var/state = 0
	var/busy = 0
	/*
				0 = Nothing done to it
				1 = Wrenched in place
				2 = Welded in place
				3 = Wires attached to it (you can now attach/dettach upgrades)
				4 = Screwdriver panel closed and is fully built (you cannot attach upgrades)
	*/

/obj/item/camera_assembly/attack_tool(obj/item/tool, mob/user)
	switch(state)
		if(0)
			// State 0
			if(iswrench(tool) && isturf(loc))
				to_chat(user, SPAN_NOTICE("You wrench the assembly into place."))
				playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
				anchored = TRUE
				state = 1
				update_icon()
				auto_turn()
				return TRUE

		if(1)
			// State 1
			if(iswrench(tool))
				to_chat(user, SPAN_NOTICE("You unwrench the assembly from its place."))
				playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
				anchored = FALSE
				update_icon()
				state = 0
				return TRUE

			if(iswelder(tool))
				if(weld(tool, user))
					to_chat(user, SPAN_NOTICE("You weld the assembly securely into place."))
					anchored = TRUE
					state = 2
				return TRUE

		if(2)
			// State 2
			if(iswelder(tool))
				if(weld(tool, user))
					to_chat(user, SPAN_NOTICE("You unweld the assembly from its place."))
					state = 1
					anchored = TRUE
				return TRUE

			if(iscable(tool))
				var/obj/item/stack/cable_coil/coil = tool
				if(coil.use(2))
					to_chat(user, SPAN_NOTICE("You add wires to the assembly."))
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					state = 3
				return TRUE

		if(3)
			// State 3
			if(iswirecutter(tool))
				new /obj/item/stack/cable_coil(GET_TURF(src), 2)
				playsound(src, 'sound/items/Wirecutter.ogg', 50, 1)
				to_chat(user, SPAN_NOTICE("You cut the wires from the circuits."))
				state = 2
				return TRUE

			if(isscrewdriver(tool))
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				var/input = strip_html(input(user, "Which networks would you like to connect this camera to? Seperate networks with a comma. No Spaces!\nFor example: SS13,Security,Secret.", "Set Network", "SS13"))
				if(isnull(input))
					to_chat(user, SPAN_WARNING("No input found please hang up and try your call again."))
					return TRUE

				var/list/tempnetwork = splittext(input, ",")
				if(!length(tempnetwork))
					to_chat(user, SPAN_WARNING("No network found please hang up and try your call again."))
					return TRUE

				var/temptag = "[GET_AREA(src)] ([rand(1, 999)])"
				input = strip_html(input(user, "How would you like to name the camera?", "Set Camera Name", temptag))

				state = 4
				var/obj/machinery/camera/C = new /obj/machinery/camera(loc)
				loc = C
				C.assembly = src

				C.auto_turn()

				C.network = uniquelist(tempnetwork)
				tempnetwork = difflist(C.network, GLOBL.restricted_camera_networks)
				if(!length(tempnetwork))//Camera isn't on any open network - remove its chunk from AI visibility.
					global.CTcameranet.remove_camera(C)

				C.c_tag = input

				for(var/i = 5; i >= 0; i -= 1)
					var/direct = input(user, "Direction?", "Assembling Camera", null) in list("LEAVE IT", "NORTH", "EAST", "SOUTH", "WEST" )
					if(direct != "LEAVE IT")
						C.set_dir(text2dir(direct))
					if(i != 0)
						var/confirm = alert(user, "Is this what you want? Chances Remaining: [i]", "Confirmation", "Yes", "No")
						if(confirm == "Yes")
							break
				return TRUE

	// Taking out upgrades.
	if(iscrowbar(tool) && length(upgrades))
		var/obj/U = locate(/obj) in upgrades
		if(isnotnull(U))
			to_chat(user, SPAN_NOTICE("You unattach an upgrade from the assembly."))
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			U.loc = GET_TURF(src)
			upgrades.Remove(U)
		else
			to_chat(user, SPAN_WARNING("There are no upgrades to unattach."))
		return TRUE

	return ..()

/obj/item/camera_assembly/attack_by(obj/item/I, mob/living/user)
	// Upgrades!
	if(is_type_in_list(I, possible_upgrades) && !is_type_in_list(I, upgrades)) // Is a possible upgrade and isn't in the camera already.
		to_chat(user, SPAN_NOTICE("You attach \the [I] into the assembly inner circuits."))
		upgrades.Add(I)
		user.drop_item(I)
		I.forceMove(src)
		return TRUE
	return ..()

/obj/item/camera_assembly/update_icon()
	if(anchored)
		icon_state = "camera1"
	else
		icon_state = "cameracase"

/obj/item/camera_assembly/attack_hand(mob/user)
	if(!anchored)
		..()

/obj/item/camera_assembly/proc/weld(obj/item/weldingtool/welder, mob/user)
	if(busy)
		return 0
	if(!welder.isOn())
		return 0

	user.visible_message(
		SPAN_NOTICE("[user] starts to weld \the [src]..."),
		SPAN_NOTICE("You start to weld \the [src]..."),
		SPAN_WARNING("You hear welding.")
	)
	playsound(src, 'sound/items/Welder.ogg', 50, 1)
	welder.eyecheck(user)
	busy = 1
	if(do_after(user, 20))
		busy = 0
		if(!welder.isOn())
			return 0
		return 1
	busy = 0
	return 0