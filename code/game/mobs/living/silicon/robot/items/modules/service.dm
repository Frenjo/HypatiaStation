// A special tray for the service droid. Allow droid to pick up and drop items as if they were using the tray normally
// Click on table to unload, click on item to load. Otherwise works identically to a tray.
// Unlike the base item "tray", robotrays ONLY pick up food, drinks and condiments.
/obj/item/tray/robotray
	name = "RoboTray"
	desc = "An autoloading tray specialized for carrying refreshments."

/obj/item/tray/robotray/afterattack(atom/target, mob/user)
	if ( !target )
		return
	// pick up items, mostly copied from base tray pickup proc
	// see code\game\objects\items\weapons\kitchen.dm line 241
	if(isitem(target))
		if ( !isturf(target.loc) ) // Don't load up stuff if it's inside a container or mob!
			return
		var turf/pickup = target.loc

		var addedSomething = 0

		for(var/obj/item/reagent_holder/food/I in pickup)


			if( I != src && !I.anchored && !istype(I, /obj/item/clothing/under) && !istype(I, /obj/item/clothing/suit) && !istype(I, /obj/item/projectile) )
				var/add = 0
				if(I.w_class == 1.0)
					add = 1
				else if(I.w_class == 2.0)
					add = 3
				else
					add = 5
				if(calc_carry() + add >= max_carry)
					break

				I.forceMove(src)
				carrying.Add(I)
				add_overlay(image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = 30 + I.layer))
				addedSomething = 1
		if ( addedSomething )
			user.visible_message("\blue [user] load some items onto their service tray.")

		return

	// Unloads the tray, copied from base item's proc dropped() and altered
	// see code\game\objects\items\weapons\kitchen.dm line 263

	if ( isturf(target) || istype(target,/obj/structure/table) )
		var foundtable = istype(target,/obj/structure/table/)
		if ( !foundtable ) //it must be a turf!
			for(var/obj/structure/table/T in target)
				foundtable = 1
				break

		var turf/dropspot
		if ( !foundtable ) // don't unload things onto walls or other silly places.
			dropspot = user.loc
		else if ( isturf(target) ) // they clicked on a turf with a table in it
			dropspot = target
		else					// they clicked on a table
			dropspot = target.loc


		cut_overlays()

		var droppedSomething = 0

		for(var/obj/item/I in carrying)
			I.forceMove(dropspot)
			carrying.Remove(I)
			droppedSomething = 1
			if(!foundtable && isturf(dropspot))
				// if no table, presume that the person just shittily dropped the tray on the ground and made a mess everywhere!
				spawn()
					for(var/i = 1, i <= rand(1,2), i++)
						if(I)
							step(I, pick(NORTH,SOUTH,EAST,WEST))
							sleep(rand(2,4))
		if ( droppedSomething )
			if ( foundtable )
				user.visible_message("\blue [user] unloads their service tray.")
			else
				user.visible_message("\blue [user] drops all the items on their tray.")

	return ..()

// A special pen for service droids. Can be toggled to switch between normal writting mode, and paper rename mode
// Allows service droids to rename paper items.
/obj/item/pen/cyborg
	desc = "A black ink printing attachment with a paper naming mode."
	name = "Printing Pen"
	var/mode = 1

/obj/item/pen/cyborg/attack_self(mob/user)
	playsound(src, 'sound/effects/pop.ogg', 50, 0)
	if (mode == 1)
		mode = 2
		user << "Changed printing mode to 'Rename Paper'"
		return
	if (mode == 2)
		mode = 1
		user << "Changed printing mode to 'Write Paper'"

// Copied over from paper's rename verb
// see code\modules\paperwork\paper.dm line 62
/obj/item/pen/cyborg/proc/RenamePaper(mob/user, obj/paper)
	if(!user || !paper)
		return
	var/n_name = input(user, "What would you like to label the paper?", "Paper Labelling", null) as text
	if(!user || !paper)
		return

	n_name = copytext(n_name, 1, 32)
	if((get_dist(user,paper) <= 1  && user.stat == CONSCIOUS))
		paper.name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(user)
	return