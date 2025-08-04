/obj/machinery/replicator
	name = "alien machine"
	desc = "It's some kind of pod with strange wires and gadgets all over it."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "borgcharger0(old)"
	density = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 100,
		USE_POWER_ACTIVE = 1000
	)

	var/spawn_progress = 0
	var/max_spawn_ticks = 5
	var/list/construction = list()
	var/list/spawning_types = list()

/obj/machinery/replicator/initialise()
	. = ..()

	var/list/viables = list(
		/obj/item/roller,
		/obj/structure/closet/crate,
		/obj/structure/closet/alien,
		/mob/living/simple/hostile/mimic,
		/mob/living/simple/hostile/viscerator,
		/mob/living/simple/hostile/hivebot,
		/obj/item/gas_analyser,
		/obj/item/camera,
		/obj/item/flash,
		/obj/item/flashlight,
		/obj/item/health_analyser,
		/obj/item/multitool,
		/obj/item/paicard,
		/obj/item/radio,
		/obj/item/radio/headset,
		/obj/item/radio/beacon,
		/obj/item/autopsy_scanner,
		/obj/item/bikehorn,
		/obj/item/bonesetter,
		/obj/item/butch,
		/obj/item/caution,
		/obj/item/caution/cone,
		/obj/item/crowbar,
		/obj/item/clipboard,
		/obj/item/cell,
		/obj/item/circular_saw,
		/obj/item/hatchet,
		/obj/item/handcuffs,
		/obj/item/hemostat,
		/obj/item/kitchenknife,
		/obj/item/lighter,
		/obj/item/lighter,
		/obj/item/light/bulb,
		/obj/item/light/tube,
		/obj/item/pickaxe,
		/obj/item/shovel,
		/obj/item/table_parts,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/screwdriver,
		/obj/item/grenade/chemical/cleaner,
		/obj/item/grenade/chemical/metalfoam
	)

	var/quantity = rand(5, 15)
	for(var/i = 0, i < quantity, i++)
		var/button_desc = "[pick("a yellow", "a purple", "a green", "a blue", "a red", "an orange", "a white")], "
		button_desc += "[pick("round", "square", "diamond", "heart", "dog", "human")] shaped "
		button_desc += "[pick("toggle", "switch", "lever", "button", "pad", "hole")]"
		var/type = pick(viables)
		viables.Remove(type)
		construction[button_desc] = type

/obj/machinery/replicator/process()
	if(length(spawning_types) && powered())
		spawn_progress++
		if(spawn_progress > max_spawn_ticks)
			visible_message(SPAN_INFO("[html_icon(src)] [src] pings!"))
			var/spawn_type = spawning_types[1]
			new spawn_type(src.loc)

			spawning_types.Remove(spawning_types[1])
			spawn_progress = 0
			max_spawn_ticks = rand(5, 30)

			if(!length(spawning_types))
				update_power_state(USE_POWER_IDLE)
				icon_state = "borgcharger0(old)"

		else if(prob(5))
			visible_message(SPAN_INFO("[html_icon(src)] [src] [pick("clicks", "whizzes", "whirrs", "whooshes", "clanks", "clongs", "clonks", "bangs")]."))

/obj/machinery/replicator/attack_hand(mob/user)
	interact(user)

/obj/machinery/replicator/interact(mob/user)
	var/dat = "The control panel displays an incomprehensible selection of controls, many with unusual markings or text around them.<br>"
	dat += "<br>"
	for(var/index = 1, index <= length(construction), index++)
		dat += "<A href='byond://?src=\ref[src];activate=[index]'>\[[construction[index]]\]</a><br>"

	SHOW_BROWSER(user, dat, "window=alien_replicator")

/obj/machinery/replicator/Topic(href, href_list)
	if(href_list["activate"])
		var/index = text2num(href_list["activate"])
		if(index > 0 && index <= length(construction))
			if(length(spawning_types))
				visible_message(SPAN_INFO("[html_icon(src)] a [pick("light", "dial", "display", "meter", "pad")] on [src]'s front [pick("blinks","flashes")] [pick("red", "yellow", "blue", "orange", "purple", "green", "white")]."))
			else
				visible_message(SPAN_INFO("[html_icon(src)] [src]'s front compartment slides shut."))

			spawning_types.Add(construction[construction[index]])
			spawn_progress = 0
			update_power_state(USE_POWER_ACTIVE)
			icon_state = "borgcharger1(old)"