/obj/item/storage/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon = 'icons/obj/storage/briefcase.dmi'
	icon_state = "briefcase"
	item_state = "briefcase"
	obj_flags = OBJ_FLAG_CONDUCT
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
	max_w_class = 3
	max_combined_w_class = 16

/obj/item/storage/briefcase/attack(mob/living/M, mob/living/user)
	//..()
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("The [src] slips out of your hand and hits your head."))
		user.take_organ_damage(10)
		user.Paralyse(2)
		return

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A href='byond://?_src_=holder;adminmoreinfo=\ref[user]'>?</A>)")

	if(M.stat < 2 && M.health < 50 && prob(90))
		/*
		var/mob/H = M
		// ******* Check
		// I don't even know what flag this was supposed to be checking?? Were they checking NO_BLUDGEON but for the wrong reason?
		if((ishuman(H) && istype(H, /obj/item/clothing/head) && H.flags & 8 && prob(80)))
			to_chat(M, SPAN_WARNING("The helmet protects you from being hit hard in the head!"))
			return
		*/
		var/time = rand(2, 6)
		if(prob(75))
			M.Paralyse(time)
		else
			M.Stun(time)
		if(M.stat != DEAD)
			M.stat = UNCONSCIOUS
		for(var/mob/O in viewers(M, null))
			O.show_message(SPAN_DANGER("[M] has been knocked unconscious!"), 1, SPAN_WARNING("You hear someone fall."), 2)
	else
		to_chat(M, SPAN_WARNING("[user] tried to knock you unconcious!"))
		M.eye_blurry += 3