/obj/item/ashtray
	icon = 'icons/ashtray.dmi'
	var/max_butts 	= 0
	var/empty_desc 	= ""
	var/icon_empty 	= ""
	var/icon_half  	= ""
	var/icon_full  	= ""
	var/icon_broken	= ""

/obj/item/ashtray/initialise()
	. = ..()
	pixel_y = rand(-5, 5)
	pixel_x = rand(-6, 6)

/obj/item/ashtray/attackby(obj/item/W as obj, mob/user as mob)
	if(health < 1)
		return
	if(istype(W, /obj/item/cigbutt) || istype(W, /obj/item/clothing/mask/cigarette) || istype(W, /obj/item/match))
		if(contents.len >= max_butts)
			to_chat(user, "This ashtray is full.")
			return
		user.u_equip(W)
		W.forceMove(src)

		if(istype(W, /obj/item/clothing/mask/cigarette))
			var/obj/item/clothing/mask/cigarette/cig = W
			if(cig.lit == 1)
				src.visible_message("[user] crushes [cig] in [src], putting it out.")
				STOP_PROCESSING(PCobj, cig)
				var/obj/item/butt = new cig.type_butt(src)
				cig.transfer_fingerprints_to(butt)
				qdel(cig)
			else if(cig.lit == 0)
				to_chat(user, "You place [cig] in [src] without even smoking it. Why would you do that?")

		src.visible_message("[user] places [W] in [src].")
		user.update_inv_l_hand()
		user.update_inv_r_hand()
		add_fingerprint(user)
		if(contents.len == max_butts)
			icon_state = icon_full
			desc = empty_desc + " It's stuffed full."
		else if(contents.len > max_butts / 2)
			icon_state = icon_half
			desc = empty_desc + " It's half-filled."
	else
		health = max(0, health - W.force)
		to_chat(user, "You hit [src] with [W].")
		if(health < 1)
			die()
	return

/obj/item/ashtray/throw_impact(atom/hit_atom)
	if(health > 0)
		health = max(0, health - 3)
		if(health < 1)
			die()
			return
		if(contents.len)
			src.visible_message(SPAN_WARNING("[src] slams into [hit_atom], spilling its contents!"))
		for(var/obj/item/clothing/mask/cigarette/O in contents)
			O.forceMove(loc)
		icon_state = icon_empty
	return ..()

/obj/item/ashtray/proc/die()
	src.visible_message(SPAN_WARNING("[src] shatters, spilling its contents!"))
	for(var/obj/item/clothing/mask/cigarette/O in contents)
		O.forceMove(loc)
	icon_state = icon_broken

/obj/item/ashtray/plastic
	name = "plastic ashtray"
	desc = "Cheap plastic ashtray."
	icon_state = "ashtray_bl"
	icon_empty = "ashtray_bl"
	icon_half  = "ashtray_half_bl"
	icon_full  = "ashtray_full_bl"
	icon_broken  = "ashtray_bork_bl"
	max_butts = 14
	health = 24.0
	matter_amounts = alist(/decl/material/plastic = 30, /decl/material/glass = 30)
	empty_desc = "Cheap plastic ashtray."
	throwforce = 3.0

/obj/item/ashtray/plastic/die()
	..()
	name = "pieces of plastic"
	desc = "Pieces of plastic with ash on them."
	return


/obj/item/ashtray/bronze
	name = "bronze ashtray"
	desc = "Massive bronze ashtray."
	icon_state = "ashtray_br"
	icon_empty = "ashtray_br"
	icon_half  = "ashtray_half_br"
	icon_full  = "ashtray_full_br"
	icon_broken  = "ashtray_bork_br"
	max_butts = 10
	health = 72.0
	matter_amounts = alist(/decl/material/steel = 80)
	empty_desc = "Massive bronze ashtray."
	throwforce = 10.0

/obj/item/ashtray/bronze/die()
	..()
	name = "pieces of bronze"
	desc = "Pieces of bronze with ash on them."
	return


/obj/item/ashtray/glass
	name = "glass ashtray"
	desc = "Glass ashtray. Looks fragile."
	icon_state = "ashtray_gl"
	icon_empty = "ashtray_gl"
	icon_half  = "ashtray_half_gl"
	icon_full  = "ashtray_full_gl"
	icon_broken  = "ashtray_bork_gl"
	max_butts = 12
	health = 12.0
	matter_amounts = /datum/design/autolathe/glass_ashtray::materials
	empty_desc = "Glass ashtray. Looks fragile."
	throwforce = 6.0

/obj/item/ashtray/glass/die()
	..()
	name = "shards of glass"
	desc = "Shards of glass with ash on them."
	playsound(src, "shatter", 30, 1)
	return