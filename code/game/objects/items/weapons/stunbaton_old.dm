/obj/item/melee/baton
	name = "stun baton"
	desc = "A stun baton for incapacitating people with."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "stunbaton"
	item_state = "baton"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	var/charges = 10
	var/status = 0
	var/mob/foundmob = "" //Used in throwing proc.

	origin_tech = list(/datum/tech/combat = 2)

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is putting the live [src.name] in \his mouth! It looks like \he's trying to commit suicide.</b>"
		return (FIRELOSS)

/obj/item/melee/baton/update_icon()
	if(status)
		icon_state = "stunbaton_active"
	else
		icon_state = "stunbaton"

/obj/item/melee/baton/attack_self(mob/user as mob)
	if(status && (CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("You grab the [src] on the wrong side."))
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return
	if(charges > 0)
		status = !status
		to_chat(user, SPAN_NOTICE("\The [src] is now [status ? "on" : "off"]."))
		playsound(src.loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		to_chat(user, SPAN_WARNING("\The [src] is out of charge."))
	add_fingerprint(user)

/obj/item/melee/baton/attack(mob/M as mob, mob/user as mob)
	if(status && (CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_DANGER("You accidentally hit yourself with the [src]!"))
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return

	var/mob/living/carbon/human/H = M
	if(isrobot(M))
		..()
		return

	if(user.a_intent == "hurt")
		if(!..()) return
		//H.apply_effect(5, WEAKEN, 0)
		H.visible_message(SPAN_DANGER("[M] has been beaten with the [src] by [user]!"))

		user.attack_log += "\[[time_stamp()]\]<font color='red'> Beat [H.name] ([H.ckey]) with [src.name]</font>"
		H.attack_log += "\[[time_stamp()]\]<font color='orange'> Beaten by [user.name] ([user.ckey]) with [src.name]</font>"
		msg_admin_attack("[user.name] ([user.ckey]) beat [H.name] ([H.ckey]) with [src.name] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		playsound(src.loc, "swing_hit", 50, 1, -1)
	else if(!status)
		H.visible_message(SPAN_WARNING("[M] has been prodded with the [src] by [user]. Luckily it was off."))
		return

	if(status)
		H.apply_effect(10, STUN, 0)
		H.apply_effect(10, WEAKEN, 0)
		H.apply_effect(10, STUTTER, 0)
		user.lastattacked = M
		H.lastattacker = user
		if(isrobot(src.loc))
			var/mob/living/silicon/robot/R = src.loc
			if(R && R.cell)
				R.cell.use(50)
		else
			charges--
		H.visible_message(SPAN_DANGER("[M] has been stunned with the [src] by [user]!"))

		user.attack_log += "\[[time_stamp()]\]<font color='red'> Stunned [H.name] ([H.ckey]) with [src.name]</font>"
		H.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by [user.name] ([user.ckey]) with [src.name]</font>"
		msg_admin_attack("[key_name(user)] stunned [key_name(H)] with [src.name]")

		playsound(src.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		if(charges < 1)
			status = 0
			update_icon()

	add_fingerprint(user)

/obj/item/melee/baton/throw_impact(atom/hit_atom)
	. = ..()
	if (prob(50))
		if(isliving(hit_atom))
			var/mob/living/carbon/human/H = hit_atom
			if(status)
				H.apply_effect(10, STUN, 0)
				H.apply_effect(10, WEAKEN, 0)
				H.apply_effect(10, STUTTER, 0)
				charges--

				for(var/mob/M in player_list) if(M.key == src.fingerprintslast)
					foundmob = M
					break

				H.visible_message(SPAN_DANGER("[src], thrown by [foundmob.name], strikes [H] and stuns them!"))

				H.attack_log += "\[[time_stamp()]\]<font color='orange'> Stunned by thrown [src.name] last touched by ([src.fingerprintslast])</font>"
				msg_admin_attack("Flying [src.name], last touched by ([src.fingerprintslast]) stunned [key_name(H)]" )

/obj/item/melee/baton/emp_act(severity)
	switch(severity)
		if(1)
			charges = 0
		if(2)
			charges = max(0, charges - 5)
	if(charges < 1)
		status = 0
		update_icon()
