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

	var/obj/item/implant/imp = null

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

		var/turf/T = get_turf(M)
		if(isnotnull(T) && (M == user || do_after(user, 50)))
			if(isnotnull(user) && isnotnull(M) && (get_turf(M) == T) && isnotnull(src) && isnotnull(imp))
				visible_message(SPAN_WARNING("[M] has been implanted by [user]."))

				M.attack_log += "\[[time_stamp()]\] <font color='orange'> Implanted with [name] ([imp.name])  by [user.name] ([user.ckey])</font>"
				user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [name] ([imp.name]) to implant [M.name] ([M.ckey])</font>"
				msg_admin_attack("[user.name] ([user.ckey]) implanted [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

				user.show_message(SPAN_WARNING("You implanted the implant into [M]."))
				if(imp.implanted(M))
					imp.loc = M
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

/*
 * Prefab Types
 */
// Loyalty.
/obj/item/implanter/loyalty
	name = "implanter-loyalty"

/obj/item/implanter/loyalty/New()
	. = ..()
	imp = new /obj/item/implant/loyalty(src)
	update()

// Explosive.
/obj/item/implanter/explosive
	name = "implanter (E)"

/obj/item/implanter/explosive/New()
	. = ..()
	imp = new /obj/item/implant/explosive(src)
	update()

// Adrenalin.
/obj/item/implanter/adrenalin
	name = "implanter-adrenalin"

/obj/item/implanter/adrenalin/New()
	. = ..()
	imp = new /obj/item/implant/adrenalin(src)
	update()

// Compressed Matter.
/obj/item/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"

/obj/item/implanter/compressed/New()
	. = ..()
	imp = new /obj/item/implant/compressed(src)
	update()

/obj/item/implanter/compressed/update()
	if(isnotnull(imp))
		var/obj/item/implant/compressed/c = imp
		if(isnull(c.scanned))
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"

/obj/item/implanter/compressed/attack(mob/M, mob/user)
	var/obj/item/implant/compressed/c = imp
	if(isnull(c))
		return
	if(isnull(c.scanned))
		to_chat(user, "Please scan an object with the implanter first.")
		return
	return ..()

/obj/item/implanter/compressed/afterattack(atom/A, mob/user)
	if(isitem(A) && isnotnull(imp))
		var/obj/item/implant/compressed/c = imp
		if(isnotnull(c.scanned))
			to_chat(user, SPAN_WARNING("Something is already scanned inside the implant!"))
			return
		c.scanned = A
		if(ishuman(A.loc))
			var/mob/living/carbon/human/H = A.loc
			H.u_equip(A)
		else if(istype(A.loc, /obj/item/storage))
			var/obj/item/storage/S = A.loc
			S.remove_from_storage(A)
		A.loc.contents.Remove(A)
		update()