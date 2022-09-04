/obj/structure/signpost
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "signpost"
	anchored = TRUE
	density = TRUE

/obj/structure/signpost/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return attack_hand(user)

/obj/structure/signpost/attack_hand(mob/user as mob)
	switch(alert("Travel back to ss13?", , "Yes", "No"))
		if("Yes")
			if(user.z != src.z)
				return
			user.loc.loc.Exited(user)
			user.loc = pick(global.latejoin)
		if("No")
			return


/obj/effect/mark
	var/mark = ""
	icon = 'icons/misc/mark.dmi'
	icon_state = "blank"
	anchored = TRUE
	layer = 99
	mouse_opacity = FALSE
	unacidable = 1//Just to be sure.


/obj/effect/beam
	name = "beam"
	unacidable = 1//Just to be sure.
	var/def_zone
	pass_flags = PASSTABLE


/obj/effect/begin
	name = "begin"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "begin"
	anchored = TRUE
	unacidable = 1


/obj/effect/laser
	name = "laser"
	desc = "IT BURNS!!!"
	icon = 'icons/obj/projectiles.dmi'
	var/damage = 0.0
	var/range = 10.0


/obj/effect/list_container
	name = "list container"

/obj/effect/list_container/mobl
	name = "mobl"
	var/master = null

	var/list/container = list()


/obj/effect/projection
	name = "Projection"
	desc = "This looks like a projection of something."
	anchored = TRUE


/obj/effect/shut_controller
	name = "shut controller"
	var/moving = null
	var/list/parts = list()


/obj/structure/showcase
	name = "Showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = TRUE
	anchored = TRUE
	unacidable = 1//temporary until I decide whether the borg can be removed. -veyveyr


/obj/item/mouse_drag_pointer = MOUSE_ACTIVE_POINTER


/obj/item/weapon/beach_ball
	icon = 'icons/misc/beach.dmi'
	icon_state = "ball"
	name = "beach ball"
	item_state = "beachball"
	density = FALSE
	anchored = FALSE
	w_class = 1.0
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	throw_range = 20
	flags = CONDUCT
	
/obj/item/weapon/beach_ball/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	user.drop_item()
	src.throw_at(target, throw_range, throw_speed)


/obj/effect/stop
	var/victim = null
	icon_state = "empty"
	name = "Geas"
	desc = "You can't resist."
	// name = ""


/obj/effect/spawner
	name = "object spawner"