/obj/structure/stool/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/structures/chairs.dmi'
	icon_state = "chair"

/obj/structure/stool/MouseDrop(atom/over_object)
	return

/obj/structure/stool/bed/chair/New()
	if(anchored)
		src.verbs -= /atom/movable/verb/pull
	..()

/obj/structure/stool/bed/chair/initialise()
	. = ..()
	handle_rotation()

/obj/structure/stool/bed/chair/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			to_chat(user, SPAN_NOTICE("[SK] is not ready to be attached!"))
			return
		user.drop_item()
		var/obj/structure/stool/bed/chair/e_chair/E = new /obj/structure/stool/bed/chair/e_chair(src.loc)
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		E.set_dir(dir)
		E.part = SK
		SK.forceMove(E)
		SK.master = E
		qdel(src)

/obj/structure/stool/bed/chair/attack_tk(mob/user)
	if(buckled_mob)
		..()
	else
		rotate()
	return

/obj/structure/stool/bed/chair/proc/handle_rotation()	//making this into a seperate proc so office chairs can call it on Move()
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER
	if(buckled_mob)
		buckled_mob.set_dir(dir)

/obj/structure/stool/bed/chair/verb/rotate()
	set category = PANEL_OBJECT
	set name = "Rotate Chair"
	set src in oview(1)

	if(CONFIG_GET(/decl/configuration_entry/ghost_interaction))
		src.set_dir(turn(src.dir, 90))
		handle_rotation()
		return
	else
		if(ismouse(usr))
			return
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return

		src.set_dir(turn(src.dir, 90))
		handle_rotation()
		return

/obj/structure/stool/bed/chair/MouseDrop_T(mob/M, mob/user)
	if(!istype(M))
		return
	buckle_mob(M, user)
	return

// Chair types
/obj/structure/stool/bed/chair/wood
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/normal
	icon_state = "wooden_chair"

/obj/structure/stool/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"

/obj/structure/stool/bed/chair/wood/attackby(obj/item/W, mob/user)
	if(iswrench(W))
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/wood(src.loc)
		qdel(src)
	else
		..()

/obj/structure/stool/bed/chair/comfy
	name = "comfy chair"
	desc = "It looks comfy."

/obj/structure/stool/bed/chair/comfy/brown
	icon_state = "comfychair_brown"

/obj/structure/stool/bed/chair/comfy/beige
	icon_state = "comfychair_beige"

/obj/structure/stool/bed/chair/comfy/teal
	icon_state = "comfychair_teal"

/obj/structure/stool/bed/chair/comfy/black
	icon_state = "comfychair_black"

/obj/structure/stool/bed/chair/comfy/lime
	icon_state = "comfychair_lime"

/obj/structure/stool/bed/chair/office
	anchored = FALSE

/obj/structure/stool/bed/chair/office/Move()
	..()
	if(buckled_mob)
		buckled_mob.buckled = null //Temporary, so Move() succeeds.
		var/moved = buckled_mob.Move(src.loc)
		buckled_mob.buckled = src
		if(!moved)
			unbuckle()
	handle_rotation()

/obj/structure/stool/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/stool/bed/chair/office/dark
	icon_state = "officechair_dark"