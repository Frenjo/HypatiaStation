/obj/item/candle
	name = "red candle"
	desc = "a candle"
	icon = 'icons/obj/items/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = WEIGHT_CLASS_TINY

	var/wax = 200
	var/lit = 0

/obj/item/candle/proc/light(flavor_text = SPAN_WARNING("[usr] lights the [name]."))

/obj/item/candle/update_icon()
	var/i
	if(wax > 150)
		i = 1
	else if(wax > 80)
		i = 2
	else i = 3
	icon_state = "candle[i][lit ? "_lit" : ""]"

/obj/item/candle/attack_by(obj/item/I, mob/user)
	if(iswelder(I))
		var/obj/item/welding_torch/WT = I
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a welding torch.
			light(SPAN_WARNING("[user] casually lights the [name] with [I]."))
		return TRUE

	if(istype(I, /obj/item/lighter))
		var/obj/item/lighter/L = I
		if(L.lit)
			light()
		return TRUE

	if(istype(I, /obj/item/match))
		var/obj/item/match/M = I
		if(M.lit)
			light()
		return TRUE

	if(istype(I, /obj/item/candle))
		var/obj/item/candle/C = I
		if(C.lit)
			light()
		return TRUE

	return ..()

/obj/item/candle/light(flavor_text = SPAN_WARNING("[usr] lights the [name]."))
	if(!src.lit)
		src.lit = 1
		//src.damtype = "fire"
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, 1)
		//SetLuminosity(CANDLE_LUM)
		set_light(CANDLE_LUM)
		START_PROCESSING(PCobj, src)

/obj/item/candle/process()
	if(!lit)
		return
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		if(ismob(src.loc))
			src.dropped()
		qdel(src)
	update_icon()
	if(isturf(loc)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/candle/attack_self(mob/user)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)
		user.set_light(user.luminosity - CANDLE_LUM)

/obj/item/candle/pickup(mob/user)
	if(lit)
		set_light(0)
		user.set_light(user.luminosity + CANDLE_LUM)

/obj/item/candle/dropped(mob/user)
	if(lit)
		user.set_light(user.luminosity - CANDLE_LUM)
		set_light(CANDLE_LUM)