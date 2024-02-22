//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items.dmi'
	icon_state = "strangepresent"
	density = TRUE
	anchored = FALSE

/obj/effect/mark
	icon = 'icons/misc/mark.dmi'
	icon_state = "blank"
	anchored = TRUE
	plane = UNLIT_EFFECTS_PLANE
	layer = 99
	mouse_opacity = FALSE
	unacidable = 1 //Just to be sure.

	var/mark = ""

/obj/effect/beam
	name = "beam"
	unacidable = 1 //Just to be sure.
	pass_flags = PASS_FLAG_TABLE

	var/def_zone

/obj/effect/begin
	name = "begin"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "begin"
	anchored = TRUE
	unacidable = 1

/obj/effect/laser
	name = "laser"
	desc = "IT BURNS!!!"
	icon = 'icons/obj/weapons/projectiles.dmi'

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

/obj/effect/stop
	// name = ""
	icon_state = "empty"
	name = "Geas"
	desc = "You can't resist."

	var/victim = null

/obj/effect/spawner
	name = "object spawner"