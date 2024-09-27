/obj/item/stack/sheet/animalhide/human
	name = "human skin"
	desc = "The by-product of human farming."
	singular_name = "human skin piece"
	icon_state = "hide"

/obj/item/stack/sheet/animalhide/corgi
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	singular_name = "corgi hide piece"
	icon_state = "corgi"

/obj/item/stack/sheet/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	singular_name = "cat hide piece"
	icon_state = "cat"

/obj/item/stack/sheet/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of monkey farming."
	singular_name = "monkey hide piece"
	icon_state = "monkey"

/obj/item/stack/sheet/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	singular_name = "lizard skin piece"
	icon_state = "lizard"

/obj/item/stack/sheet/animalhide/xeno
	name = "alien hide"
	desc = "The skin of a terrible creature."
	singular_name = "alien hide piece"
	icon_state = "xeno"

// Step one - dehairing.
/obj/item/stack/sheet/animalhide/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/kitchenknife) || istype(I, /obj/item/kitchen/utensil/knife) || istype(I, /obj/item/twohanded/fireaxe) || istype(I, /obj/item/hatchet))
		//visible message on mobs is defined as visible_message(var/message, var/self_message, var/blind_message)
		user.visible_message(
			SPAN_INFO("[user] starts cutting the hair off \the [src]."),
			SPAN_INFO("You start cutting the hair off \the [src]."),
			SPAN_WARNING("You hear the sound of a knife rubbing against flesh.")
		)
		if(do_after(user, 5 SECONDS))
			to_chat(user, SPAN_INFO("You cut the hair from the [singular_name]."))
			// Try locating an existing stack on the tile and add to there if possible
			for(var/obj/item/stack/sheet/hairlesshide/sheet in user.loc)
				if(sheet.amount < 50)
					sheet.amount++
					use(1)
					break
			// If it gets to here it means it did not find a suitable stack on the tile.
			new /obj/item/stack/sheet/hairlesshide(user.loc, 1)
			use(1)
		return TRUE
	return ..()

//Step two - washing..... it's actually in washing machine code.
/obj/item/stack/sheet/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of it's hair, but still needs tanning."
	singular_name = "hairless hide piece"
	icon_state = "hairlesshide"

//Step three - drying
/obj/item/stack/sheet/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	singular_name = "wet leather piece"
	icon_state = "wetleather"
	var/wetness = 30 //Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 500 //Kelvin to start drying

/obj/item/stack/sheet/wetleather/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/sheet/leather/HS in loc)
				if(HS.amount < 50)
					HS.amount++
					use(1)
					wetness = initial(wetness)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			new /obj/item/stack/sheet/leather(loc, 1)
			wetness = initial(wetness)
			use(1)