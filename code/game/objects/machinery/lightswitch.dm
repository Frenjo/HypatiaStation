// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name = "light switch"
	desc = "It turns lights on and off. What are you, simple?"
	icon = 'icons/obj/power.dmi'
	icon_state = "light1"
	anchored = TRUE

	power_channel = LIGHT
	power_usage = alist(
		USE_POWER_IDLE = 20
	)

	var/on = 1
	var/area/connected_area = null
	var/other_area = null

/obj/machinery/light_switch/New()
	..()
	connected_area = isnotnull(other_area) ? locate(other_area) : GET_AREA(src)

/obj/machinery/light_switch/initialise()
	. = ..()
	if(!name)
		name = "light switch ([connected_area.name])"

	on = connected_area.lightswitch
	update_icon()

/obj/machinery/light_switch/update_icon()
	if(stat & (NOPOWER | BROKEN))
		icon_state = "light-p"
		set_light(0)
	else
		icon_state = "light[on]"
		set_light(1, 1, on ? "#82FF4C" : "#F86060")

/obj/machinery/light_switch/examine()
	set src in oview(1)
	if(usr && !usr.stat)
		usr << "A light switch. It is [on? "on" : "off"]."

/obj/machinery/light_switch/attack_paw(mob/user)
	src.attack_hand(user)

/obj/machinery/light_switch/proc/set_state(newstate)
	if(on != newstate)
		on = newstate
		connected_area.set_lightswitch(on)
		update_icon()

/obj/machinery/light_switch/attack_hand(mob/user)
	set_state(!on)

/obj/machinery/light_switch/powered()
	. = ..(power_channel, connected_area) //tie our powered status to the connected area

/obj/machinery/light_switch/power_change()
	. = ..()
	//sync ourselves to the new state
	if(on != connected_area.lightswitch)
		on = connected_area.lightswitch
		update_icon()
		return 1

/obj/machinery/light_switch/emp_act(severity)
	if(stat & (BROKEN | NOPOWER))
		..(severity)
		return

	power_change()
	..(severity)
