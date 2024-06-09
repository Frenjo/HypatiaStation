//device to take core samples from mineral turfs - used for various types of analysis

// Should really refactor /obj/item/evidencebag...
// ... into /obj/item/bag/evidence and /obj/item/bag/sample.
/obj/item/evidencebag/sample
	name = "sample bag"
	desc = "a bag for holding research samples."

/obj/item/storage/box/samplebags
	name = "sample bag box"
	desc = "A box claiming to contain sample bags."

	starts_with = list(
		/obj/item/evidencebag/sample = 7
	)

//////////////////////////////////////////////////////////////////
/obj/item/core_sampler
	name = "core sampler"
	desc = "Used to extract geological core samples."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "sampler0"
	item_state = "screwdriver_brown"
	w_class = 1.0
	//slot_flags = SLOT_BELT

	var/sampled_turf = ""
	var/num_stored_bags = 10
	var/obj/item/evidencebag/sample/filled_bag

/obj/item/core_sampler/examine()
	set src in orange(1)
	if(!usr)
		return
	if(get_dist(src, usr) < 2)
		to_chat(usr, "That's \a [src].")
		to_chat(usr, SPAN_INFO("Used to extract geological core samples - this one is [sampled_turf ? "full" : "empty"], and has [num_stored_bags] bag[num_stored_bags != 1 ? "s" : ""] remaining."))
	else
		return ..()

/obj/item/core_sampler/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/evidencebag/sample))
		if(num_stored_bags >= 10)
			to_chat(user, SPAN_WARNING("The core sampler cannot fit any more bags!"))
			return TRUE
		qdel(I)
		num_stored_bags++
		to_chat(user, SPAN_INFO("You insert \the [I] into the core sampler."))
		return TRUE
	return ..()

/obj/item/core_sampler/proc/sample_item(item_to_sample, mob/user)
	var/datum/geosample/geo_data
	if(istype(item_to_sample, /turf/simulated/rock))
		var/turf/simulated/rock/T = item_to_sample
		T.geologic_data.UpdateNearbyArtifactInfo(T)
		geo_data = T.geologic_data
	else if(istype(item_to_sample, /obj/item/ore))
		var/obj/item/ore/O = item_to_sample
		geo_data = O.geologic_data

	if(geo_data)
		if(isnotnull(filled_bag))
			to_chat(user, SPAN_WARNING("The core sampler is full!"))
		else if(num_stored_bags < 1)
			to_chat(user, SPAN_WARNING("The core sampler is out of sample bags!"))
		else
			//create a new sample bag which we'll fill with rock samples
			filled_bag = new /obj/item/evidencebag/sample(src)

			icon_state = "sampler1"
			num_stored_bags--

			//put in a rock sliver
			var/obj/item/rocksliver/R = new /obj/item/rocksliver()
			R.geological_data = geo_data
			R.loc = filled_bag

			//update the sample bag
			filled_bag.icon_state = "evidence"
			var/image/I = image("icon" = R, "layer" = FLOAT_LAYER)
			filled_bag.underlays.Add(I)
			filled_bag.w_class = 1

			to_chat(user, SPAN_INFO("You take a core sample of the [item_to_sample]."))
	else
		to_chat(user, SPAN_WARNING("You are unable to take a sample of [item_to_sample]."))

/obj/item/core_sampler/attack_self()
	if(isnotnull(filled_bag))
		to_chat(usr, SPAN_INFO("You eject the full sample bag."))
		var/success = 0
		if(ismob(loc))
			var/mob/M = loc
			success = M.put_in_inactive_hand(filled_bag)
		if(!success)
			filled_bag.loc = get_turf(src)
		filled_bag = null
		icon_state = "sampler0"
	else
		to_chat(usr, SPAN_WARNING("The core sampler is empty."))