//Simple borg hand.
//Limited use.
/obj/item/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool for synthetic assets."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "gripper"

	//Has a list of items that it can hold.
	var/list/can_hold = list(
		/obj/item/cell,
		/obj/item/firealarm_electronics,
		/obj/item/airalarm_electronics,
		/obj/item/airlock_electronics,
		/obj/item/module/power_control,
		/obj/item/stock_part,
		/obj/item/frame/light_fixture,
		/obj/item/apc_frame,
		/obj/item/frame/alarm,
		/obj/item/frame/firealarm,
		/obj/item/table_parts,
		/obj/item/rack_parts,
		/obj/item/camera_assembly,
	)

	//Item currently being held.
	var/obj/item/wrapped = null

/obj/item/gripper/attack_self(mob/user)
	if(wrapped)
		wrapped.attack_self(user)

/obj/item/gripper/verb/drop_item()
	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Drone"

	if(!wrapped)
		//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
		for(var/obj/item/thing in src.contents)
			thing.loc = GET_TURF(src)
		return

	if(wrapped.loc != src)
		wrapped = null
		return

	src.loc << "\red You drop \the [wrapped]."
	wrapped.loc = GET_TURF(src)
	wrapped = null
	//update_icon()

/obj/item/gripper/afterattack(atom/target, mob/user)
	if(!target) //Target is invalid.
		return

	//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
	if(!wrapped)
		for(var/obj/item/thing in src.contents)
			wrapped = thing
			break

	if(wrapped) //Already have an item.
		wrapped.loc = user
		//Pass the attack on to the target.
		target.attackby(wrapped,user)

		if(wrapped && src && wrapped.loc == user)
			wrapped.loc = src

		//Sanity/item use checks.

		if(!wrapped || !user)
			return

		if(wrapped.loc != src.loc)
			wrapped = null
			return

	if(isitem(target)) // Check that we're not pocketing a mob.
		//...and that the item is not in a container.
		if(!isturf(target.loc))
			return

		var/obj/item/I = target

		//Check if the item is blacklisted.
		var/grab = 0
		for(var/typepath in can_hold)
			if(istype(I, typepath))
				grab = 1
				break

		//We can grab the item, finally.
		if(grab)
			user << "You collect \the [I]."
			I.loc = src
			wrapped = I
			return
		else
			user << "\red Your gripper cannot hold \the [target]."

//TODO: Matter decompiler.
/obj/item/matter_decompiler
	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "decompiler"

	var/list/stored_comms = list(
		/decl/material/steel = 0,
		/decl/material/glass = 0,
		/decl/material/plastic = 0,
		/decl/material/wood = 0
	)

/obj/item/matter_decompiler/afterattack(atom/target, mob/user)
	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = GET_TURF(target)
	if(!istype(T))
		return

	//Used to give the right message.
	var/grabbed_something = 0

	for(var/mob/M in T)
		if(istype(M, /mob/living/simple/lizard) || istype(M, /mob/living/simple/mouse))
			loc.visible_message(
				"\red [loc] sucks [M] into its decompiler. There's a horrible crunching noise.",
				"\red It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises."
			)
			new/obj/effect/decal/cleanable/blood/splatter(GET_TURF(src))
			qdel(M)
			stored_comms[/decl/material/wood] += 2
			stored_comms[/decl/material/plastic] += 2
			return
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W, /obj/effect/spider/spiderling))
			stored_comms[/decl/material/wood] +=2
			stored_comms[/decl/material/plastic] += 2
		else if(istype(W, /obj/item/light))
			var/obj/item/light/L = W
			if(L.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				stored_comms[/decl/material/steel]++
				stored_comms[/decl/material/glass]++
			else
				continue
		else if(istype(W, /obj/effect/decal/remains/robot))
			stored_comms[/decl/material/steel] += 2
			stored_comms[/decl/material/plastic] += 2
			stored_comms[/decl/material/glass]++
		else if(istype(W, /obj/item/trash))
			stored_comms[/decl/material/steel]++
			stored_comms[/decl/material/plastic] += 3
		else if(istype(W, /obj/effect/decal/cleanable/blood/gibs/robot))
			stored_comms[/decl/material/steel] += 2
			stored_comms[/decl/material/glass] += 2
		else if(istype(W, /obj/item/ammo_casing))
			stored_comms[/decl/material/steel]++
		else if(istype(W, /obj/item/shard/shrapnel))
			stored_comms[/decl/material/steel] += 3
		else if(istype(W, /obj/item/shard))
			stored_comms[/decl/material/glass] += 3
		else if(istype(W, /obj/item/reagent_holder/food/snacks/grown))
			stored_comms[/decl/material/wood] += 4
		else
			continue

		qdel(W)
		grabbed_something = 1

	if(grabbed_something)
		user << "\blue You deploy your decompiler and clear out the contents of \the [T]."
	else
		user << "\red Nothing on \the [T] is useful to you."
	return

//PRETTIER TOOL LIST.
/mob/living/silicon/robot/drone/installed_modules()
	if(weapon_lock)
		src << "\red Weapon lock active, unable to use modules! Count:[weaponlock_time]"
		return

	if(istype(module, /obj/item/robot_model/default))
		module = new /obj/item/robot_model/drone(src)

	var/dat = "<HEAD><TITLE>Drone modules</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += {"<A href='byond://?src=\ref[src];mach_close=robotmod'>Close</A>
	<BR>
	<BR>
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A href=byond://?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A href=byond://?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A href=byond://?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}


	var/tools = "<B>Tools and devices</B><BR>"
	var/resources = "<BR><B>Resources</B><BR>"

	for (var/O in module.modules)
		var/module_string = ""

		if (!O)
			module_string += text("<B>Resource depleted</B><BR>")
		else if(activated(O))
			module_string += text("[O]: <B>Activated</B><BR>")
		else
			module_string += text("[O]: <A href=byond://?src=\ref[src];act=\ref[O]>Activate</A><BR>")

		if(isitem(O) && !iscable(O))
			tools += module_string
		else
			resources += module_string

	dat += tools

	if(emagged)
		if(!module.emag)
			dat += text("<B>Resource depleted</B><BR>")
		else if(activated(module.emag))
			dat += text("[module.emag]: <B>Activated</B><BR>")
		else
			dat += text("[module.emag]: <A href=byond://?src=\ref[src];act=\ref[module.emag]>Activate</A><BR>")

	dat += resources

	src << browse(dat, "window=robotmod&can_close=0")

//Putting the decompiler here to avoid doing list checks every tick.
/mob/living/silicon/robot/drone/use_power()
	..()
	if(!src.cell.charge > 0 || !decompiler)
		return

	//The decompiler replenishes drone stores from hoovered-up junk each tick.
	for(var/type in decompiler.stored_comms)
		if(decompiler.stored_comms[type] > 0)
			var/obj/item/stack/sheet/stack
			switch(type)
				if(/decl/material/steel)
					if(isnull(stack_metal))
						stack_metal = new /obj/item/stack/sheet/steel/cyborg(module, 1)
					stack = stack_metal
				if(/decl/material/glass)
					if(isnull(stack_glass))
						stack_glass = new /obj/item/stack/sheet/glass/cyborg(module, 1)
					stack = stack_glass
				if(/decl/material/plastic)
					if(isnull(stack_plastic))
						stack_plastic = new /obj/item/stack/sheet/plastic/cyborg(module, 1)
					stack = stack_plastic
				if(/decl/material/wood)
					if(isnull(stack_wood))
						stack_wood = new /obj/item/stack/sheet/wood/cyborg(module, 1)
					stack = stack_wood

			stack.amount++
			decompiler.stored_comms[type]--;