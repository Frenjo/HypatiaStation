/obj/item/stack/tile/light
	name = "light tile"
	singular_name = "light floor tile"
	desc = "A floor tile, made out off glass. It produces light."
	icon_state = "tile_e"
	force = 3.0
	throwforce = 5.0
	throw_speed = 5
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCT
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "smashed")
	turf_path = /turf/simulated/floor/light

	var/on = 1
	var/state //0 = fine, 1 = flickering, 2 = breaking, 3 = broken

/obj/item/stack/tile/light/New(loc, amount = null)
	..()
	if(prob(5))
		state = 3 //broken
	else if(prob(5))
		state = 2 //breaking
	else if(prob(10))
		state = 1 //flickering occasionally
	else
		state = 0 //fine

/obj/item/stack/tile/light/attack_tool(obj/item/tool, mob/user)
	if(iscrowbar(tool) && use(1))
		new /obj/item/stack/sheet/metal(user.loc)
		new /obj/item/stack/light_w(user.loc)
		return TRUE

	return ..()