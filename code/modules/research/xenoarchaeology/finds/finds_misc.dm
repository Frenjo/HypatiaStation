/obj/item/shard/plasma
	name = "plasma shard"
	desc = "A shard of plasma glass. Considerably tougher then normal glass shards. Apparently not tough enough to be a window."
	force = 8.0
	throwforce = 15.0
	icon_state = "plasmalarge"
	sharp = 1
	edge = 1

/obj/item/shard/plasma/New()
	. = ..()
	icon_state = pick("plasmalarge", "plasmamedium", "plasmasmall")
	switch(icon_state)
		if("plasmasmall")
			pixel_x = rand(-12, 12)
			pixel_y = rand(-12, 12)
		if("plasmamedium")
			pixel_x = rand(-8, 8)
			pixel_y = rand(-8, 8)
		if("plasmalarge")
			pixel_x = rand(-5, 5)
			pixel_y = rand(-5, 5)

/obj/item/shard/plasma/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			var/obj/item/stack/sheet/glass/plasma/NG = new(user.loc)
			for(var/obj/item/stack/sheet/glass/plasma/G in user.loc)
				if(G == NG)
					continue
				if(G.amount >= G.max_amount)
					continue
				G.attackby(NG, user)
				to_chat(user, "You add the newly-formed plasma glass to the stack. It now contains [NG.amount] sheets.")
			//SN del(src)
			qdel(src)
			return
	return ..()

//legacy crystal
/obj/machinery/crystal
	name = "crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"

/obj/machinery/crystal/New()
	. = ..()
	if(prob(50))
		icon_state = "crystal2"

//large finds
				/*
				/obj/machinery/syndicate_beacon
				/obj/machinery/wish_granter
			if(18)
				item_type = "jagged green crystal"
				additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")
				icon_state = "crystal"
				apply_material_decorations = 0
				if(prob(10))
					apply_image_decorations = 1
			if(19)
				item_type = "jagged pink crystal"
				additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")
				icon_state = "crystal2"
				apply_material_decorations = 0
				if(prob(10))
					apply_image_decorations = 1
				*/
			//machinery type artifacts?