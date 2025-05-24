/*
 * Implanter
 */
/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0

	var/imp_type = null
	var/obj/item/implant/imp = null

/obj/item/implanter/New()
	. = ..()
	if(isnotnull(imp_type))
		imp = new imp_type()
		update()

/obj/item/implanter/proc/update()
	if(isnotnull(imp))
		icon_state = "implanter1"
	else
		icon_state = "implanter0"

/obj/item/implanter/attack(mob/M, mob/user)
	if(!iscarbon(M))
		return
	if(isnotnull(user) && isnotnull(imp))
		visible_message(SPAN_WARNING("[user] is attemping to implant [M]."))

		var/turf/T = GET_TURF(M)
		if(isnotnull(T) && (M == user || do_after(user, 50)))
			if(isnotnull(user) && isnotnull(M) && (GET_TURF(M) == T) && isnotnull(src) && isnotnull(imp))
				visible_message(SPAN_WARNING("[M] has been implanted by [user]."))

				M.attack_log += "\[[time_stamp()]\] <font color='orange'> Implanted with [name] ([imp.name])  by [user.name] ([user.ckey])</font>"
				user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [name] ([imp.name]) to implant [M.name] ([M.ckey])</font>"
				msg_admin_attack("[user.name] ([user.ckey]) implanted [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

				user.show_message(SPAN_WARNING("You implanted the implant into [M]."))
				if(imp.implanted(M))
					imp.forceMove(M)
					imp.imp_in = M
					imp.implanted = 1
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						var/datum/organ/external/affected = H.get_organ(user.zone_sel.selecting)
						affected.implants.Add(imp)
						imp.part = affected

						BITSET(H.hud_updateflag, WANTED_HUD)

				imp = null
				update()