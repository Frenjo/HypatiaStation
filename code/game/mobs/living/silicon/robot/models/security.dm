/*
 * Security Model
 */
/obj/item/robot_model/security
	name = "security robot model"

	module_types = list(
		/obj/item/flashlight,
		/obj/item/flash,
		/obj/item/handcuffs/cyborg,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/taser/cyborg,
		/obj/item/taperoll/police
	)
	emag_type = /obj/item/gun/energy/laser/cyborg

	channels = list(CHANNEL_SECURITY = TRUE)

	sprite_path = 'icons/mob/silicon/robot/security.dmi'
	sprites = list(
		"Basic" = "secborg",
		"Red Knight" = "security",
		"Black Knight" = "securityrobot",
		"Bloodhound" = "bloodhound"
	)

/obj/item/robot_model/security/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/flash/F = locate() in modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/gun/energy/taser/cyborg/T = locate() in modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost)
		T.update_icon()
	else
		T.charge_tick = 0