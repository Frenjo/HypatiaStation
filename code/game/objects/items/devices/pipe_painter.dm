/obj/item/pipe_painter
	name = "pipe painter"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"
	item_state = "flight"
	var/list/modes = list("grey", "red", "blue", "cyan", "green", "yellow", "purple")
	var/mode = "grey"

/obj/item/pipe_painter/afterattack(atom/A, mob/user)
	if(!istype(A, /obj/machinery/atmospherics/pipe) || istype(A, /obj/machinery/atmospherics/pipe/tank) || istype(A, /obj/machinery/atmospherics/pipe/vent) || istype(A, /obj/machinery/atmospherics/pipe/simple/heat_exchanging) || istype(A, /obj/machinery/atmospherics/pipe/simple/insulated))
		return
	var/obj/machinery/atmospherics/pipe/P = A
	P.pipe_color = mode
	user.visible_message(SPAN_NOTICE("[user] paints \the [P] [mode]."), SPAN_NOTICE("You paint \the [P] [mode]."))
	P.update_icon()

/obj/item/pipe_painter/attack_self(mob/user)
	mode = input("Which colour do you want to use?", "Pipe painter") in modes

/obj/item/pipe_painter/get_examine_text()
	. = ..()
	. += "It is in [mode] mode."