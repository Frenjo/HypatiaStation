/*
 * Input and Output Plates
 */
/obj/machinery/input_plate
	name = "input area"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x2"
	density = FALSE
	opacity = FALSE
	mouse_opacity = FALSE

/obj/machinery/input_plate/initialise()
	. = ..()
	icon_state = "blank"

/obj/machinery/output_plate
	name = "output area"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x"
	density = FALSE
	opacity = FALSE
	mouse_opacity = FALSE

/obj/machinery/output_plate/initialise()
	. = ..()
	icon_state = "blank"