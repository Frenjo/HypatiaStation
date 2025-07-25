/obj/item/dart_cartridge
	name = "dart cartridge"
	desc = "A rack of hollow darts."
	icon = 'icons/obj/weapons/ammo.dmi'
	icon_state = "darts-5"
	item_state = "rcdammo"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	origin_tech = alist(/decl/tech/materials = 2)
	var/darts = 5

/obj/item/dart_cartridge/update_icon()
	if(!darts)
		icon_state = "darts-0"
	else if(darts > 5)
		icon_state = "darts-5"
	else
		icon_state = "darts-[darts]"
	return 1

/obj/item/gun/dartgun
	name = "dart gun"
	desc = "A small gas-powered dartgun, capable of delivering chemical cocktails swiftly across short distances."
	icon_state = "dartgun-empty"

	var/list/beakers = list() //All containers inside the gun.
	var/list/mixing = list() //Containers being used for mixing.
	var/obj/item/dart_cartridge/cartridge = null //Container of darts.
	var/max_beakers = 3
	var/dart_reagent_amount = 15
	var/container_type = /obj/item/reagent_holder/glass/beaker
	var/list/starting_chems = null

/obj/item/gun/dartgun/update_icon()
	if(!cartridge)
		icon_state = "dartgun-empty"
		return 1

	if(!cartridge.darts)
		icon_state = "dartgun-0"
	else if(cartridge.darts > 5)
		icon_state = "dartgun-5"
	else
		icon_state = "dartgun-[cartridge.darts]"
	return 1

/obj/item/gun/dartgun/New()
	. = ..()
	if(starting_chems)
		for(var/chem in starting_chems)
			var/obj/item/reagent_holder/B = new container_type(src)
			LAZYASET(B.starting_reagents, chem, 50)
			beakers.Add(B)
	cartridge = new /obj/item/dart_cartridge(src)
	update_icon()

/obj/item/gun/dartgun/examine()
	set src in view()
	update_icon()
	..()
	if(!(usr in view(2)) && usr!=src.loc)
		return
	if(length(beakers))
		to_chat(usr, SPAN_INFO("[src] contains:"))
		for(var/obj/item/reagent_holder/glass/beaker/B in beakers)
			if(B.reagents && length(B.reagents.reagent_list))
				for(var/datum/reagent/R in B.reagents.reagent_list)
					to_chat(usr, SPAN_INFO("[R.volume] units of [R.name]"))

/obj/item/gun/dartgun/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dart_cartridge))
		var/obj/item/dart_cartridge/D = I

		if(!D.darts)
			to_chat(user, SPAN_INFO("[D] is empty."))
			return 0

		if(cartridge)
			if(cartridge.darts <= 0)
				src.remove_cartridge()
			else
				to_chat(user, SPAN_INFO("There's already a cartridge in [src]."))
				return 0

		user.drop_item()
		cartridge = D
		D.forceMove(src)
		to_chat(user, SPAN_INFO("You slot [D] into [src]."))
		update_icon()
		return
	if(istype(I, /obj/item/reagent_holder/glass))
		if(!istype(I, container_type))
			to_chat(user, SPAN_INFO("[I] doesn't seem to fit into [src]."))
			return
		if(length(beakers) >= max_beakers)
			to_chat(user, SPAN_INFO("[src] already has [max_beakers] beakers in it - another one isn't going to fit!"))
			return
		var/obj/item/reagent_holder/glass/beaker/B = I
		user.drop_item()
		B.forceMove(src)
		beakers += B
		to_chat(user, SPAN_INFO("You slot [B] into [src]."))
		src.updateUsrDialog()

/obj/item/gun/dartgun/can_fire()
	if(!cartridge)
		return 0
	else
		return cartridge.darts

/obj/item/gun/dartgun/proc/has_selected_beaker_reagents()
	return 0

/obj/item/gun/dartgun/proc/remove_cartridge()
	if(cartridge)
		to_chat(usr, SPAN_INFO("You pop the cartridge out of [src]."))
		var/obj/item/dart_cartridge/C = cartridge
		C.forceMove(GET_TURF(src))
		C.update_icon()
		cartridge = null
		src.update_icon()

/obj/item/gun/dartgun/proc/get_mixed_syringe()
	if(!cartridge)
		return 0
	if(!cartridge.darts)
		return 0

	var/obj/item/reagent_holder/syringe/dart = new(src)

	if(length(mixing))
		var/mix_amount = dart_reagent_amount / length(mixing)
		for(var/obj/item/reagent_holder/glass/beaker/B in mixing)
			B.reagents.trans_to(dart,mix_amount)

	return dart

/obj/item/gun/dartgun/proc/fire_dart(atom/target, mob/user)
	if(locate(/obj/structure/table, src.loc))
		return
	else
		var/turf/trg = GET_TURF(target)
		var/obj/effect/syringe_gun_dummy/D = new/obj/effect/syringe_gun_dummy(GET_TURF(src))
		var/obj/item/reagent_holder/syringe/S = get_mixed_syringe()
		if(!S)
			to_chat(user, SPAN_WARNING("There are no darts in [src]!"))
			return
		if(!S.reagents)
			to_chat(user, SPAN_WARNING("There are no reagents available!"))
			return
		cartridge.darts--
		src.update_icon()
		S.reagents.trans_to(D, S.reagents.total_volume)
		qdel(S)
		D.icon_state = "syringeproj"
		D.name = "syringe"
		SET_ATOM_FLAGS(D, ATOM_FLAG_NO_REACT)
		playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)

		for(var/i = 0, i < 6, i++)
			if(!D)
				break
			if(D.loc == trg)
				break
			step_towards(D, trg)

			if(D)
				for(var/mob/living/carbon/M in D.loc)
					if(!iscarbon(M))
						continue
					if(M == user)
						continue
					//Syringe gun attack logging by Yvarov
					var/R
					if(D.reagents)
						for(var/datum/reagent/A in D.reagents.reagent_list)
							R += A.id + " ("
							R += num2text(A.volume) + "),"
					if(ismob(M))
						M.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[M]/[M.ckey]</b> with a <b>dartgun</b> ([R])"
						user.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[M]/[M.ckey]</b> with a <b>dartgun</b> ([R])"
						msg_admin_attack("[user] ([user.ckey]) shot [M] ([M.ckey]) with a dartgun ([R]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

					else
						M.attack_log += "\[[time_stamp()]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[M]/[M.ckey]</b> with a <b>dartgun</b> ([R])"
						msg_admin_attack("UNKNOWN shot [M] ([M.ckey]) with a <b>dartgun</b> ([R]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

					if(D.reagents)
						D.reagents.trans_to(M, 15)
					to_chat(M, SPAN_DANGER("You feel a slight prick."))

					qdel(D)
					break
			if(D)
				for(var/atom/A in D.loc)
					if(A == user)
						continue
					if(A.density)
						qdel(D)

			sleep(1)

		if(D)
			spawn(10)
				qdel(D)

		return

/obj/item/gun/dartgun/afterattack(obj/target, mob/user , flag)
	if(!isturf(target.loc) || target == user)
		return
	..()

/obj/item/gun/dartgun/can_hit(mob/living/target, mob/living/user)
	return 1

/obj/item/gun/dartgun/attack_self(mob/user)
	user.set_machine(src)
	var/dat = "<b>[src] mixing control:</b><br><br>"

	if(length(beakers))
		var/i = 1
		for(var/obj/item/reagent_holder/glass/beaker/B in beakers)
			dat += "Beaker [i] contains: "
			if(B.reagents && length(B.reagents.reagent_list))
				for(var/datum/reagent/R in B.reagents.reagent_list)
					dat += "<br>    [R.volume] units of [R.name], "
				if(check_beaker_mixing(B))
					dat += text("<A href='byond://?src=\ref[src];stop_mix=[i]'><font color='green'>Mixing</font></A> ")
				else
					dat += text("<A href='byond://?src=\ref[src];mix=[i]'><font color='red'>Not mixing</font></A> ")
			else
				dat += "nothing."
			dat += " \[<A href='byond://?src=\ref[src];eject=[i]'>Eject</A>\]<br>"
			i++
	else
		dat += "There are no beakers inserted!<br><br>"

	if(cartridge)
		if(cartridge.darts)
			dat += "The dart cartridge has [cartridge.darts] shots remaining."
		else
			dat += "<font color='red'>The dart cartridge is empty!</font>"
		dat += " \[<A href='byond://?src=\ref[src];eject_cart=1'>Eject</A>\]"

	user << browse(dat, "window=dartgun")
	onclose(user, "dartgun", src)

/obj/item/gun/dartgun/proc/check_beaker_mixing(obj/item/B)
	if(!mixing || !beakers)
		return 0
	for(var/obj/item/M in mixing)
		if(M == B)
			return 1
	return 0

/obj/item/gun/dartgun/Topic(href, href_list)
	src.add_fingerprint(usr)
	if(href_list["stop_mix"])
		var/index = text2num(href_list["stop_mix"])
		if(index <= length(beakers))
			for(var/obj/item/M in mixing)
				if(M == beakers[index])
					mixing -= M
					break
	else if(href_list["mix"])
		var/index = text2num(href_list["mix"])
		if(index <= length(beakers))
			mixing += beakers[index]
	else if(href_list["eject"])
		var/index = text2num(href_list["eject"])
		if(index <= length(beakers))
			if(beakers[index])
				var/obj/item/reagent_holder/glass/beaker/B = beakers[index]
				to_chat(usr, "You remove [B] from [src].")
				mixing -= B
				beakers -= B
				B.forceMove(GET_TURF(src))
	else if (href_list["eject_cart"])
		remove_cartridge()
	src.updateUsrDialog()
	return

/obj/item/gun/dartgun/Fire(atom/target, mob/living/user, params, point_blank = FALSE, reflex = FALSE)
	if(cartridge)
		spawn(0) fire_dart(target,user)
	else
		to_chat(usr, SPAN_WARNING("[src] is empty."))

/obj/item/gun/dartgun/vox
	name = "alien dart gun"
	desc = "A small gas-powered dartgun, fitted for nonhuman hands."

/obj/item/gun/dartgun/vox/medical
	starting_chems = list("kelotane", "bicaridine", "anti_toxin")

/obj/item/gun/dartgun/vox/raider
	starting_chems = list("space_drugs", "stoxin", "impedrezene")