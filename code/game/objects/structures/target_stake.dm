// Basically they are for the firing range
/obj/structure/target_stake
	name = "target stake"
	desc = "A thin platform with negatively-magnetized wheels."
	icon = 'icons/obj/objects.dmi'
	icon_state = "target_stake"
	density = TRUE
	obj_flags = OBJ_FLAG_CONDUCT
	var/obj/item/target/pinned_target // the current pinned target

/obj/structure/target_stake/Move()
	..()
	// Move the pinned target along with the stake
	if(pinned_target in view(3, src))
		pinned_target.forceMove(loc)

	else // Sanity check: if the pinned target can't be found in immediate view
		pinned_target = null
		density = TRUE

/obj/structure/target_stake/attackby(obj/item/W, mob/user)
	// Putting objects on the stake. Most importantly, targets
	if(pinned_target)
		return // get rid of that pinned target first!

	if(istype(W, /obj/item/target))
		density = FALSE
		W.density = TRUE
		user.drop_item(src)
		W.forceMove(loc)
		W.layer = 3.1
		pinned_target = W
		to_chat(user, "You slide the target onto the stake.")
	return

/obj/structure/target_stake/attack_hand(mob/user)
	// taking pinned targets off!
	if(pinned_target)
		density = TRUE
		pinned_target.density = FALSE
		pinned_target.layer = OBJ_LAYER

		pinned_target.forceMove(user.loc)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(pinned_target)
				to_chat(user, "You take the target off of the stake.")
		else
			pinned_target.forceMove(GET_TURF(user))
			to_chat(user, "You take the target off of the stake.")

		pinned_target = null