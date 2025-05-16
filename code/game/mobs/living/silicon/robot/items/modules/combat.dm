//Personal shielding for the combat module.
/obj/item/robot_module/combat_shield
	name = "personal shielding"
	desc = "A powerful experimental module that turns aside or absorbs incoming attacks at the cost of charge."
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "shock"
	var/shield_level = 0.5 //Percentage of damage absorbed by the shield.

/obj/item/robot_module/combat_shield/verb/set_shield_level()
	set category = PANEL_OBJECT
	set name = "Set shield level"
	set src in range(0)

	var/N = input("How much damage should the shield absorb?") in list("5","10","25","50","75","100")
	if (N)
		shield_level = text2num(N)/100

/obj/item/robot_module/combat_mobility
	name = "mobility module"
	desc = "By retracting limbs and tucking in its head, a combat android can roll at high speeds."
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "shock"