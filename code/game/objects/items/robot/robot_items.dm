//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
 * Cyborg Spec Items
 *
 * Might want to move this into several files later but for now it works here.
 */
/obj/item/borg/stun
	name = "electrified arm"
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "shock"

/obj/item/borg/stun/attack(mob/M, mob/living/silicon/robot/user)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] to attack [M.name] ([M.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	user.cell.charge -= 30

	M.Weaken(5)
	if(M.stuttering < 5)
		M.stuttering = 5
	M.Stun(5)

	visible_message(
		SPAN_DANGER("[user] has prodded [M] with an electrically-charged arm!"),
		SPAN_WARNING("You hear someone fall.")
	)

/obj/item/borg/overdrive
	name = "overdrive"
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "shock"

/*
 * Sight
 */
/obj/item/borg/sight
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "securearea"

	var/sight_mode = null

/obj/item/borg/sight/xray
	name = "\proper x-ray vision"
	sight_mode = BORGXRAY

/obj/item/borg/sight/thermal
	name = "\proper thermal vision"
	sight_mode = BORGTHERM
	icon_state = "thermal"
	icon = 'icons/obj/items/clothing/glasses.dmi'

/obj/item/borg/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon_state = "meson"
	icon = 'icons/obj/items/clothing/glasses.dmi'