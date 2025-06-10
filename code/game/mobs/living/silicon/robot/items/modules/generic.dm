//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
 * Cyborg Spec Items
 */
/obj/item/robot_module/stun
	name = "electrified arm"
	icon_state = "elecarm"

/obj/item/robot_module/stun/attack(mob/M, mob/living/silicon/robot/user)
	M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been attacked with \the [src] by \the [user] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <font color='red'>Used \the [src] to attack \the [M] ([M.ckey])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) used \the [src] to attack \the [M] ([M.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	user.cell.charge -= 30

	M.Weaken(5)
	if(M.stuttering < 5)
		M.stuttering = 5
	M.Stun(5)

	visible_message(
		SPAN_DANGER("[user] prods \the [M] with \the [src]!"),
		SPAN_DANGER("You prod \the [M] with \the [src]!"),
		SPAN_WARNING("You hear someone fall.")
	)

/obj/item/robot_module/overdrive
	name = "overdrive"
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "shock"