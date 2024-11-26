/obj/item/flash
	name = "flash"
	desc = "Used for blinding and being an asshole."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "flash"
	item_state = "flashbang"	//looks exactly like a flash (and nothing like a flashbang)
	throwforce = 5
	w_class = 1.0
	throw_speed = 4
	throw_range = 10
	obj_flags = OBJ_FLAG_CONDUCT
	origin_tech = list(/datum/tech/magnets = 2, /datum/tech/combat = 1)

	var/times_used = 0	//Number of times it's been used.
	var/broken = 0		//Is the flash burnt out?
	var/last_used = 0	//last world.time it was used.

/obj/item/flash/proc/clown_check(mob/user)
	if(user && (MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("\The [src] slips out of your hand."))
		user.drop_item()
		return 0
	return 1

/obj/item/flash/proc/flash_recharge()
	//capacitor recharges over time
	for(var/i = 0, i < 3, i++)
		if(last_used + 600 > world.time)
			break
		last_used += 600
		times_used -= 2
	last_used = world.time
	times_used = max(0, round(times_used)) //sanity


/obj/item/flash/attack(mob/living/M, mob/user)
	if(!user || !M)
		return	//sanity

	M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been flashed (attempt) with [src.name]  by [user.name] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [src.name] to flash [M.name] ([M.ckey])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) Used the [src.name] to flash [M.name] ([M.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if(!clown_check(user))
		return
	if(broken)
		to_chat(user, SPAN_WARNING("\The [src] is broken."))
		return

	flash_recharge()

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			last_used = world.time
			if(prob(times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				to_chat(user, SPAN_WARNING("The bulb has burnt out!"))
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a minute
			to_chat(user, SPAN_WARNING("*click* *click*"))
			return
	playsound(src, 'sound/weapons/flash.ogg', 100, 1)
	var/flashfail = 0

	if(iscarbon(M))
		var/safety = M:eyecheck()
		if(safety <= 0)
			M.Weaken(10)
			flick("e_flash", M.flash)

			if(ishuman(M) && ishuman(user) && M.stat != DEAD)
				if(user.mind && (user.mind in global.PCticker.mode.head_revolutionaries) && IS_GAME_MODE(/datum/game_mode/revolution))
					var/revsafe = 0
					for(var/obj/item/implant/loyalty/L in M)
						if(L && L.implanted)
							revsafe = 1
							break
					M.mind_initialize()		//give them a mind datum if they don't have one.
					if(M.mind.has_been_rev)
						revsafe = 2
					if(!revsafe)
						M.mind.has_been_rev = 1
						global.PCticker.mode.add_revolutionary(M.mind)
					else if(revsafe == 1)
						to_chat(user, SPAN_WARNING("Something seems to be blocking the flash!"))
					else
						to_chat(user, SPAN_WARNING("This mind seems resistant to the flash!"))
		else
			flashfail = 1

	else if(issilicon(M))
		M.Weaken(rand(5, 10))
	else
		flashfail = 1

	if(isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	if(!flashfail)
		flick("flash2", src)
		if(!issilicon(M))
			user.visible_message(SPAN_DISARM("[user] blinds [M] with the flash!"))
		else
			user.visible_message(SPAN_NOTICE("[user] overloads [M]'s sensors with the flash!"))
	else
		user.visible_message(SPAN_NOTICE("[user] fails to blind [M] with the flash!"))
	return

/obj/item/flash/attack_self(mob/living/carbon/user, flag = 0, emp = 0)
	if(!user || !clown_check(user))
		return
	if(broken)
		user.show_message(SPAN_WARNING("The [src.name] is broken!"), 2)
		return

	flash_recharge()

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			if(prob(2 * times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				to_chat(user, SPAN_WARNING("The bulb has burnt out!"))
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a minute
			user.show_message(SPAN_WARNING("*click* *click*"), 2)
			return
	playsound(src, 'sound/weapons/flash.ogg', 100, 1)
	flick("flash2", src)
	if(user && isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	for(var/mob/living/carbon/M in oviewers(3, null))
		if(prob(50))
			if(locate(/obj/item/cloaking_device, M))
				for(var/obj/item/cloaking_device/S in M)
					S.active = 0
					S.icon_state = "shield0"
		var/safety = M:eyecheck()
		if(!safety)
			if(!M.blinded)
				flick("flash", M.flash)
	return

/obj/item/flash/emp_act(severity)
	if(broken)
		return
	flash_recharge()
	switch(times_used)
		if(0 to 5)
			if(prob(2 * times_used))
				broken = 1
				icon_state = "flashburnt"
				return
			times_used++
			if(iscarbon(loc))
				var/mob/living/carbon/M = loc
				var/safety = M.eyecheck()
				if(safety <= 0)
					M.Weaken(10)
					flick("e_flash", M.flash)
					for(var/mob/O in viewers(M, null))
						O.show_message(SPAN_DISARM("[M] is blinded by the flash!"))
	..()

/obj/item/flash/synthetic
	name = "synthetic flash"
	desc = "When a problem arises, SCIENCE is the solution."
	icon_state = "sflash"
	origin_tech = list(/datum/tech/magnets = 2, /datum/tech/combat = 1)
	var/construction_cost = list(MATERIAL_METAL = 750, /decl/material/glass = 750)
	var/construction_time = 100

/obj/item/flash/synthetic/attack(mob/living/M, mob/user)
	..()
	if(!broken)
		broken = 1
		to_chat(user, SPAN_WARNING("The bulb has burnt out!"))
		icon_state = "flashburnt"

/obj/item/flash/synthetic/attack_self(mob/living/carbon/user, flag = 0, emp = 0)
	..()
	if(!broken)
		broken = 1
		to_chat(user, SPAN_WARNING("The bulb has burnt out!"))
		icon_state = "flashburnt"