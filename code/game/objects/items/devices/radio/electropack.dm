/obj/item/device/radio/electropack
	name = "electropack"
	desc = "Dance my monkeys! DANCE!!!"
	icon_state = "electropack0"
	item_state = "electropack"
	frequency = 1449
	flags = CONDUCT
	slot_flags = SLOT_BACK
	w_class = 5.0
	matter_amounts = list(MATERIAL_METAL = 10000, MATERIAL_GLASS = 2500)

	var/code = 2

/obj/item/device/radio/electropack/attack_hand(mob/user as mob)
	if(src == user.back)
		to_chat(user, SPAN_NOTICE("You need help taking this off!"))
		return
	..()

/obj/item/device/radio/electropack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/clothing/head/helmet))
		if(!b_stat)
			to_chat(user, SPAN_NOTICE("[src] is not ready to be attached!"))
			return
		var/obj/item/assembly/shock_kit/A = new /obj/item/assembly/shock_kit(user)
		A.icon = 'icons/obj/assemblies.dmi'

		user.drop_from_inventory(W)
		W.loc = A
		W.master = A
		A.part1 = W

		user.drop_from_inventory(src)
		loc = A
		master = A
		A.part2 = src

		user.put_in_hands(A)
		A.add_fingerprint(user)

/obj/item/device/radio/electropack/Topic(href, href_list)
	//..()
	if(usr.stat || usr.restrained())
		return
	if(((ishuman(usr) && ((!global.CTgame_ticker || (global.CTgame_ticker && global.CTgame_ticker.mode != "monkey")) && usr.contents.Find(src))) || (usr.contents.Find(master) || (in_range(src, usr) && isturf(loc)))))
		usr.set_machine(src)
		if(href_list["freq"])
			var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
			radio_connection = register_radio(src, new_frequency, new_frequency, RADIO_CHAT)
		else
			if(href_list["code"])
				code += text2num(href_list["code"])
				code = round(code)
				code = min(100, code)
				code = max(1, code)
			else
				if(href_list["power"])
					on = !(on)
					icon_state = "electropack[on]"
		if(!(master))
			if(ismob(loc))
				attack_self(loc)
			else
				for(var/mob/M in viewers(1, src))
					if(M.client)
						attack_self(M)
		else
			if(ismob(master.loc))
				attack_self(master.loc)
			else
				for(var/mob/M in viewers(1, master))
					if(M.client)
						attack_self(M)
	else
		usr << browse(null, "window=radio")
		return
	return

/obj/item/device/radio/electropack/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption != code)
		return

	if(ismob(loc) && on)
		var/mob/M = loc
		var/turf/T = M.loc
		if(isturf(T))
			if(!M.moved_recently && M.last_move)
				M.moved_recently = TRUE
				step(M, M.last_move)
				sleep(50)
				if(M)
					M.moved_recently = FALSE
		to_chat(M, SPAN_DANGER("You feel a sharp shock!"))
		var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
		s.set_up(3, 1, M)
		s.start()

		M.Weaken(10)

	if(master && wires & 1)
		master.receive_signal()
	return

/obj/item/device/radio/electropack/attack_self(mob/user as mob, flag1)
	if(!ishuman(user))
		return
	user.set_machine(src)
	var/dat = {"<TT>
<A href='?src=\ref[src];power=1'>Turn [on ? "Off" : "On"]</A><BR>
<B>Frequency/Code</B> for electropack:<BR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

Code:
<A href='byond://?src=\ref[src];code=-5'>-</A>
<A href='byond://?src=\ref[src];code=-1'>-</A> [code]
<A href='byond://?src=\ref[src];code=1'>+</A>
<A href='byond://?src=\ref[src];code=5'>+</A><BR>
</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return