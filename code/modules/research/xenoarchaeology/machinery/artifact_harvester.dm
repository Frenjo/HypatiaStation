/obj/machinery/artifact_harvester
	name = "exotic particle harvester"
	icon = 'icons/obj/machines/virology.dmi'
	icon_state = "incubator"	//incubator_on
	anchored = TRUE
	density = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 50,
		USE_POWER_ACTIVE = 750
	)

	var/harvesting = 0
	var/obj/item/anobattery/inserted_battery
	var/obj/machinery/artifact/cur_artifact
	var/obj/machinery/artifact_scanpad/owned_scanner = null

/obj/machinery/artifact_harvester/initialise()
	. = ..()
	//connect to a nearby scanner pad
	owned_scanner = locate(/obj/machinery/artifact_scanpad) in get_step(src, dir)
	if(!owned_scanner)
		owned_scanner = locate(/obj/machinery/artifact_scanpad) in orange(1, src)

/obj/machinery/artifact_harvester/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/anobattery))
		if(isnotnull(inserted_battery))
			to_chat(user, SPAN_WARNING("There is already a battery in \the [src]."))
			return TRUE
		to_chat(user, SPAN_INFO("You insert [I] into [src]."))
		user.drop_item()
		I.forceMove(src)
		inserted_battery = I
		updateDialog()
		return TRUE
	return..()

/obj/machinery/artifact_harvester/attack_hand(mob/user)
	src.add_fingerprint(user)
	interact(user)

/obj/machinery/artifact_harvester/interact(mob/user)
	if(stat & (NOPOWER | BROKEN))
		return
	user.set_machine(src)
	var/dat = "<B>Artifact Power Harvester</B><BR>"
	dat += "<HR><BR>"
	//
	if(owned_scanner)
		if(harvesting)
			if(harvesting > 0)
				dat += "Please wait. Harvesting in progress ([(inserted_battery.stored_charge/inserted_battery.capacity) * 100]%).<br>"
			else
				dat += "Please wait. Energy dump in progress ([(inserted_battery.stored_charge/inserted_battery.capacity) * 100]%).<br>"
			dat += "<A href='byond://?src=\ref[src];stopharvest=1'>Halt early</A><BR>"
		else
			if(inserted_battery)
				dat += "<b>[inserted_battery.name]</b> inserted, charge level: [inserted_battery.stored_charge]/[inserted_battery.capacity] ([(inserted_battery.stored_charge/inserted_battery.capacity)*100]%)<BR>"
				dat += "<b>Energy signature ID:</b>[inserted_battery.battery_effect.artifact_id == "" ? "???" : "[inserted_battery.battery_effect.artifact_id]"]<BR>"
				dat += "<A href='byond://?src=\ref[src];ejectbattery=1'>Eject battery</a><BR>"
				dat += "<A href='byond://?src=\ref[src];drainbattery=1'>Drain battery of all charge</a><BR>"
				dat += "<A href='byond://?src=\ref[src];harvest=1'>Begin harvesting</a><BR>"

			else
				dat += "No battery inserted.<BR>"
	else
		dat += "<B><font color=red>Unable to locate analysis pad.</font><BR></b>"
	//
	dat += "<HR>"
	dat += "<A href='byond://?src=\ref[src];refresh=1'>Refresh</A> <A href='byond://?src=\ref[src];close=1'>Close<BR>"
	user << browse(dat, "window=artharvester;size=450x500")
	onclose(user, "artharvester")

/obj/machinery/artifact_harvester/process()
	if(stat & (NOPOWER | BROKEN))
		return

	if(harvesting > 0)
		//gain a bit of charge
		inserted_battery.stored_charge += 0.5

		//check if we've finished
		if(inserted_battery.stored_charge >= inserted_battery.capacity)
			update_power_state(USE_POWER_IDLE)
			harvesting = 0
			cur_artifact.anchored = FALSE
			cur_artifact.being_used = 0
			visible_message("<b>[name]</b> states, \"Battery is full.\"")
			icon_state = "incubator"

	else if(harvesting < 0)
		//dump some charge
		inserted_battery.stored_charge -= 2

		//do the effect
		if(inserted_battery.battery_effect)
			inserted_battery.battery_effect.process()

			//if the effect works by touch, activate it on anyone viewing the console
			if(inserted_battery.battery_effect.effect == 0)
				var/list/nearby = viewers(1, src)
				for(var/mob/M in nearby)
					if(M.machine == src)
						inserted_battery.battery_effect.DoEffectTouch(M)

		//if there's no charge left, finish
		if(inserted_battery.stored_charge <= 0)
			update_power_state(USE_POWER_IDLE)
			inserted_battery.stored_charge = 0
			harvesting = 0
			if(inserted_battery.battery_effect && inserted_battery.battery_effect.activated)
				inserted_battery.battery_effect.ToggleActivate()
			visible_message("<b>[name]</b> states, \"Battery dump completed.\"")
			icon_state = "incubator"

/obj/machinery/artifact_harvester/Topic(href, href_list)
	if(href_list["harvest"])
		//locate artifact on analysis pad
		cur_artifact = null
		var/articount = 0
		var/obj/machinery/artifact/analysed
		for(var/obj/machinery/artifact/A in GET_TURF(owned_scanner))
			analysed = A
			articount++

		var/mundane = 0
		for(var/obj/O in GET_TURF(owned_scanner))
			if(O.invisibility)
				continue
			if(!istype(O, /obj/machinery/artifact) && !istype(O, /obj/machinery/artifact_scanpad))
				mundane++
				break
		for(var/mob/O in GET_TURF(owned_scanner))
			if(O.invisibility)
				continue
			mundane++
			break

		if(analysed.being_used)
			visible_message("<b>[src]</b> states, \"Cannot harvest. Too much interference.\"")
		else if(articount == 1 && !mundane)
			cur_artifact = analysed
			//there should already be a battery inserted, but this is just in case
			if(inserted_battery)
				//see if we can clear out an old effect
				//delete it when the ids match to account for duplicate ids having different effects
				if(inserted_battery.battery_effect && inserted_battery.stored_charge <= 0)
					qdel(inserted_battery.battery_effect)

				//only charge up
				var/matching_id = 0
				if(inserted_battery.battery_effect)
					matching_id = (inserted_battery.battery_effect.artifact_id == cur_artifact.my_effect.artifact_id)
				var/matching_effecttype = 0
				if(inserted_battery.battery_effect)
					matching_effecttype = (inserted_battery.battery_effect.type == cur_artifact.my_effect.type)
				if(!inserted_battery.battery_effect || (matching_id && matching_effecttype))
					harvesting = 1
					update_power_state(USE_POWER_ACTIVE)
					cur_artifact.anchored = TRUE
					cur_artifact.being_used = 1
					icon_state = "incubator_on"
					visible_message("<b>[src]</b> states, \"Beginning artifact energy harvesting.\"")

					//duplicate the artifact's effect datum
					if(!inserted_battery.battery_effect)
						var/effecttype = cur_artifact.my_effect.type
						var/datum/artifact_effect/E = new effecttype(inserted_battery)

						//duplicate it's unique settings
						for(var/varname in list("chargelevelmax", "artifact_id", "effect", "effectrange", "trigger"))
							E.vars[varname] = cur_artifact.my_effect.vars[varname]

						//copy the new datum into the battery
						inserted_battery.battery_effect = E
						inserted_battery.stored_charge = 0
				else
					visible_message("<b>[src]</b> states, \"Cannot harvest. Incompatible energy signatures detected.\"")
			else if(cur_artifact)
				visible_message("<b>[src]</b> states, \"Cannot harvest. No battery inserted.\"")
		else if(articount > 1 || mundane)
			visible_message("<b>[src]</b> states, \"Cannot harvest. Error isolating energy signature.\"")
		else if(!articount)
			visible_message("<b>[src]</b> states, \"Cannot harvest. No noteworthy energy signature isolated.\"")

	if(href_list["stopharvest"])
		if(harvesting)
			if(harvesting < 0 && inserted_battery.battery_effect && inserted_battery.battery_effect.activated)
				inserted_battery.battery_effect.ToggleActivate()
			harvesting = 0
			cur_artifact.anchored = FALSE
			cur_artifact.being_used = 0
			visible_message("<b>[name]</b> states, \"Activity interrupted.\"")
			icon_state = "incubator"

	if(href_list["ejectbattery"])
		inserted_battery.forceMove(loc)
		src.inserted_battery = null

	if(href_list["drainbattery"])
		if(inserted_battery)
			if(inserted_battery.battery_effect && inserted_battery.stored_charge > 0)
				if(alert("This action will dump all charge, safety gear is recommended before proceeding", "Warning", "Continue", "Cancel"))
					if(!inserted_battery.battery_effect.activated)
						inserted_battery.battery_effect.ToggleActivate(0)
					harvesting = -1
					update_power_state(USE_POWER_ACTIVE)
					icon_state = "incubator_on"
					visible_message("<b>[src]</b> states, \"Warning, battery charge dump commencing.\"")
			else
				visible_message("<b>[src]</b> states, \"Cannot dump energy. Battery is drained of charge already.\"")
		else
			visible_message("<b>[src]</b> states, \"Cannot dump energy. No battery inserted.\"")

	if(href_list["close"])
		usr << browse(null, "window=artharvester")
		usr.unset_machine(src)

	updateDialog()