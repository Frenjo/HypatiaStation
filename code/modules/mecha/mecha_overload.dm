/obj/mecha/verb/overload()
	set category = "Exosuit Interface"
	set name = "Toggle Leg Actuator Overload"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return
	if(!overload_capable)
		return

	overload = !overload
	if(overload)
		step_in = min(1, round(step_in / 2))
		step_energy_drain = step_energy_drain * overload_coeff
		occupant_message(SPAN_WARNING("You enable the leg actuator overload."))
	else
		step_in = initial(step_in)
		step_energy_drain = initial(step_energy_drain)
		occupant_message(SPAN_INFO("You disable the leg actuator overload."))
	log_message("Toggled leg actuator overload.")