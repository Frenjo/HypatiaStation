/obj/machinery/computer/shuttle_control/specops
	name = "special operations shuttle console"
	shuttle_tag = "Special Operations"
	req_access = list(ACCESS_CENT_SPECOPS)

/obj/machinery/computer/shuttle_control/specops/attack_ai(mob/user)
	FEEDBACK_ACCESS_DENIED(user)
	return 1