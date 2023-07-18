/obj/item/candle
	name = "red candle"
	desc = "a candle"
	icon = 'icons/obj/items/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = 1

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

/obj/item/candle/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a welding tool
			light(SPAN_WARNING("[user] casually lights the [name] with [W]."))
	else if(istype(W, /obj/item/lighter))
		var/obj/item/lighter/L = W
		if(L.lit)
			light()
	else if(istype(W, /obj/item/match))
		var/obj/item/match/M = W
		if(M.lit)
			light()
	else if(istype(W, /obj/item/candle))
		var/obj/item/candle/C = W
		if(C.lit)
			light()

/obj/item/candle/light(flavor_text = SPAN_WARNING("[usr] lights the [name]."))
	if(!src.lit)
		src.lit = 1
		//src.damtype = "fire"
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, 1)
		//SetLuminosity(CANDLE_LUM)
		set_light(CANDLE_LUM)
		GLOBL.processing_objects.Add(src)

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

/obj/item/candle/attack_self(mob/user as mob)
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