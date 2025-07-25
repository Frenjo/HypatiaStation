/*
 * Security Model
 */
/obj/item/robot_model/security
	name = "security robot model"
	display_name = "Security"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/fire_extinguisher/mini,
		/obj/item/handcuffs/cyborg,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/taser/cyborg,
		/obj/item/taperoll/police,
		/obj/item/crowbar
	)
	emag_modules = list(/obj/item/gun/energy/laser/cyborg)

	channels = list(CHANNEL_SECURITY)

	sprite_path = 'icons/mob/silicon/robot/security.dmi'
	sprites = list(
		"Basic" = "secborg",
		"Red Knight" = "security",
		"Black Knight" = "securityrobot",
		"Bloodhound" = "bloodhound",
		"Treadhound" = "treadhound"
	)
	model_select_sprite = "bloodhound"

	can_be_pushed = FALSE

	advanced_huds = list(SILICON_HUD_SECURITY)

/obj/item/robot_model/security/respawn_consumable(mob/living/silicon/robot/robby)
	. = ..()
	var/obj/item/gun/energy/taser/cyborg/taser = locate() in modules
	if(isnotnull(taser))
		if(taser.power_supply.charge < taser.power_supply.maxcharge)
			taser.power_supply.give(taser.charge_cost)
			taser.update_icon()
		else
			taser.charge_tick = 0

/obj/item/robot_model/security/get_playstyle_string()
	. = SPAN_DANGER("Remember: While you have selected the security model and CAN act in that capacity, you MUST follow your LAWS above all else.")