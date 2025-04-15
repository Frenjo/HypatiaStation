/*
 * Input and Output Plates
 */
/obj/machinery/mineral/input
	name = "input area"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x2"
	density = FALSE
	opacity = FALSE
	mouse_opacity = FALSE

/obj/machinery/mineral/input/New()
	. = ..()
	icon_state = "blank"

/obj/machinery/mineral/output
	name = "output area"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x"
	density = FALSE
	opacity = FALSE
	mouse_opacity = FALSE

/obj/machinery/mineral/output/New()
	. = ..()
	icon_state = "blank"