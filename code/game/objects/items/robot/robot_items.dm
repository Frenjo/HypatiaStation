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
	M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>"
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

// Harm alarm!
/obj/item/harm_alarm
	name = "sonic harm prevention tool"
	desc = "Releases a harmless blast that confuses most organics. For when the harm is JUST TOO MUCH."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "megaphone"

	var/cooldown = 0
	var/emagged = FALSE

/obj/item/harm_alarm/attack_emag(mob/user)
	emagged = !emagged
	if(emagged)
		to_chat(user, SPAN_WARNING("You short out the safeties on \the [src]!"))
	else
		to_chat(user, SPAN_WARNING("You reset the safeties on \the [src]!"))
	return TRUE

/obj/item/harm_alarm/attack_self(mob/user)
	var/safety = !emagged
	if(cooldown < world.time && cooldown > 0)
		to_chat(user, SPAN_WARNING("\The [src] is still recharging!"))

	if(isrobot(user))
		var/mob/living/silicon/robot/robby = user
		if(robby.cell.charge < 1200)
			to_chat(user, SPAN_WARNING("You don't have enough charge to do this!"))
			return
		robby.cell.charge -= 1000
		if(robby.emagged)
			safety = FALSE

	if(safety)
		for(var/mob/living/M in hearers(9, user))
			if(iscarbon(M))
				M.confused += 6
			to_chat(M, "<font color='red' size='7'>HUMAN HARM</font>")
		playsound(GET_TURF(src), 'sound/items/harm_alarm.ogg', 100, 3)
		cooldown = world.time + 200
		message_admins("[key_name_admin(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) used a cyborg harm alarm in ([user.x], [user.y], [user.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)", 0, 1)
		log_game("[user.ckey]([user]) used a cyborg harm alarm in ([user.x], [user.y], [user.z])")
		return

	if(!safety)
		for(var/mob/living/M in hearers(9, user))
			if(iscarbon(M))
				M.confused += 15
				M.Weaken(1)
				M.stuttering += 30
				//M.adjustEarDamage(0, 15)
				M.make_jittery(25)
			to_chat(M, "<font color='red' size='7'>BZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZT</font>")
		playsound(GET_TURF(src), 'sound/machines/warning-buzzer.ogg', 130, 3)
		cooldown = world.time + 600
		message_admins("[key_name_admin(user, user.client)](<A HREF='byond://?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='byond://?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) used an emagged cyborg harm alarm in ([user.x], [user.y], [user.z] - <A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)", 0, 1)
		log_game("[user.ckey]([user]) used an emagged cyborg harm alarm in ([user.x], [user.y], [user.z])")
		return

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