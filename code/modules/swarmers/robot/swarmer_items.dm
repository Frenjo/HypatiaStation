/*
 * Swarmer Model Items
 */
/obj/item/robot_module/swarmer_disperser
	name = "biological dispersion matrix"
	desc = "A cyborg module which mimics the innate forced teleportation ability of standard Swarmer constructs."
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "direction_evac"

/obj/item/robot_module/swarmer_disperser/attack(mob/living/target, mob/living/silicon/robot/robby)
	swarmer_disperse_target(robby, target)

/obj/item/robot_module/swarmer_disintegrator
	name = "abiological disintegration matrix"
	desc = "A cyborg module which mimics the innate disintegration ability of standard Swarmer constructs."
	icon = 'icons/mob/simple/swarmer.dmi'
	icon_state = "swarmer"

/obj/item/robot_module/swarmer_disintegrator/afterattack(atom/target, mob/living/silicon/robot/robby, proximity_flag, click_parameters)
	if(robby.next_move > world.time)
		return FALSE
	if(!proximity_flag)
		return FALSE

	return swarmer_disintegrate(robby, target)