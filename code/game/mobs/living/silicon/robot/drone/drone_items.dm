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

/obj/item/gripper/attack_self(mob/user as mob)
	if(wrapped)
		wrapped.attack_self(user)

/obj/item/gripper/verb/drop_item()
	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Drone"

	if(!wrapped)
		//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
		for(var/obj/item/thing in src.contents)
			thing.loc = get_turf(src)
		return

	if(wrapped.loc != src)
		wrapped = null
		return

	src.loc << "\red You drop \the [wrapped]."
	wrapped.loc = get_turf(src)
	wrapped = null
	//update_icon()

/obj/item/gripper/afterattack(atom/target, mob/user as mob)
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

	//Metal, glass, wood, plastic.
	var/list/stored_comms = list(
		MATERIAL_METAL		= 0,
		MATERIAL_GLASS		= 0,
		MATERIAL_WOOD		= 0,
		MATERIAL_PLASTIC	= 0
	)

/obj/item/matter_decompiler/afterattack(atom/target, mob/user as mob)
	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(target)
	if(!istype(T))
		return

	//Used to give the right message.
	var/grabbed_something = 0

	for(var/mob/M in T)
		if(istype(M, /mob/living/simple_animal/lizard) || istype(M, /mob/living/simple_animal/mouse))
			src.loc.visible_message("\red [src.loc] sucks [M] into its decompiler. There's a horrible crunching noise.","\red It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises.")
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(M)
			stored_comms[MATERIAL_WOOD]++
			stored_comms[MATERIAL_WOOD]++
			stored_comms[MATERIAL_PLASTIC]++
			stored_comms[MATERIAL_PLASTIC]++
			return
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W, /obj/effect/spider/spiderling))
			stored_comms[MATERIAL_WOOD]++
			stored_comms[MATERIAL_WOOD]++
			stored_comms[MATERIAL_PLASTIC]++
			stored_comms[MATERIAL_PLASTIC]++
		else if(istype(W, /obj/item/light))
			var/obj/item/light/L = W
			if(L.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				stored_comms[MATERIAL_METAL]++
				stored_comms[MATERIAL_GLASS]++
			else
				continue
		else if(istype(W, /obj/effect/decal/remains/robot))
			stored_comms[MATERIAL_METAL]++
			stored_comms[MATERIAL_METAL]++
			stored_comms[MATERIAL_PLASTIC]++
			stored_comms[MATERIAL_PLASTIC]++
			stored_comms[MATERIAL_GLASS]++
		else if(istype(W, /obj/item/trash))
			stored_comms[MATERIAL_METAL]++
			stored_comms[MATERIAL_PLASTIC]++
			stored_comms[MATERIAL_PLASTIC]++
			stored_comms[MATERIAL_PLASTIC]++
		else if(istype(W, /obj/effect/decal/cleanable/blood/gibs/robot))
			stored_comms[MATERIAL_METAL]++
			stored_comms[MATERIAL_GLASS]++
			stored_comms[MATERIAL_METAL]++
			stored_comms[MATERIAL_GLASS]++
		else if(istype(W, /obj/item/ammo_casing))
			stored_comms[MATERIAL_METAL]++
		else if(istype(W, /obj/item/shard/shrapnel))
			stored_comms[MATERIAL_METAL]++
			stored_comms[MATERIAL_METAL]++
			stored_comms[MATERIAL_METAL]++
		else if(istype(W, /obj/item/shard))
			stored_comms[MATERIAL_GLASS]++
			stored_comms[MATERIAL_GLASS]++
			stored_comms[MATERIAL_GLASS]++
		else if(istype(W, /obj/item/reagent_containers/food/snacks/grown))
			stored_comms[MATERIAL_WOOD]++
			stored_comms[MATERIAL_WOOD]++
			stored_comms[MATERIAL_WOOD]++
			stored_comms[MATERIAL_WOOD]++
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

	if(!module)
		module = new /obj/item/robot_module/drone(src)

	var/dat = "<HEAD><TITLE>Drone modules</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += {"<A HREF='?src=\ref[src];mach_close=robotmod'>Close</A>
	<BR>
	<BR>
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
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
			module_string += text("[O]: <A HREF=?src=\ref[src];act=\ref[O]>Activate</A><BR>")

		if((istype(O,/obj/item) || istype(O,/obj/item)) && !(istype(O,/obj/item/stack/cable_coil)))
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
			dat += text("[module.emag]: <A HREF=?src=\ref[src];act=\ref[module.emag]>Activate</A><BR>")

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
				if(MATERIAL_METAL)
					if(!stack_metal)
						stack_metal = new(src.module)
						stack_metal.amount = 1
					stack = stack_metal
				if(MATERIAL_GLASS)
					if(!stack_glass)
						stack_glass = new(src.module)
						stack_glass.amount = 1
					stack = stack_glass
				if(MATERIAL_WOOD)
					if(!stack_wood)
						stack_wood = new(src.module)
						stack_wood.amount = 1
					stack = stack_wood
				if(MATERIAL_PLASTIC)
					if(!stack_plastic)
						stack_plastic = new(src.module)
						stack_plastic.amount = 1
					stack = stack_plastic

			stack.amount++
			decompiler.stored_comms[type]--;