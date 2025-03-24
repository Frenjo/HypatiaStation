/*
 * Swarmer Module Items
 */
/obj/item/swarmer_teleporter
	name = "organic relocation device"
	desc = "A cyborg module which mimics the innate forced teleportation ability of standard Swarmer constructs."
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "direction_evac"

/obj/item/swarmer_teleporter/attack(mob/living/target, mob/living/silicon/robot/user)
	if(target == user)
		return
	if(isnotstationlevel(user.z))
		balloon_alert(user, "cannot locate a bluespace link")
		return

	to_chat(user, SPAN_INFO("Attempting to remove this being from our presence."))
	if(!do_after(user, 3 SECONDS, target))
		return

	swarmer_teleport_target(user, target)