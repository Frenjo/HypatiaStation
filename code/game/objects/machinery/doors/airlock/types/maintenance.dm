/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access" // I debated standardising these as "Maintenance Airlock" like the others but decided against it.
	icon = 'icons/obj/doors/engineering/maintenance.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_mai

/obj/machinery/door/airlock/maintenance/New()
	. = ..()
	GLOBL.maintenance_airlocks_list.Add(src)

/obj/machinery/door/airlock/maintenance/Destroy()
	GLOBL.maintenance_airlocks_list.Remove(src)
	return ..()

/obj/machinery/door/airlock/maintenance/update_icon()
	if(isnotnull(overlays))
		overlays.Cut()
	if(density)
		// Maintenance doors flash yellow if we have emergency maintenance access. -Frenjo
		if(GLOBL.maint_all_access && isstationlevel(z))
			if(lights && !locked)
				icon_state = "door_maint_access"
			else if(lights && locked)
				icon_state = "door_maint_access_locked"
		else if(locked && lights)
			icon_state = "door_locked"
		else
			icon_state = "door_closed"
		if(p_open || welded)
			overlays = list()
			if(p_open)
				overlays.Add(image(icon, "panel_open"))
			if(welded)
				overlays.Add(image(icon, "welded"))
	else
		icon_state = "door_open"

/obj/machinery/door/airlock/maintenance/do_animate(animation)
	switch(animation)
		if("opening")
			if(isnotnull(overlays))
				overlays.Cut()
			if(p_open)
				flick("o_door_opening", src)
			else
				flick("door_opening", src)
		if("closing")
			if(isnotnull(overlays))
				overlays.Cut()
			if(p_open)
				flick("o_door_closing", src)
			else
				flick("door_closing", src)
		if("spark")
			flick("door_spark", src)
		if("deny")
			// Flick to deny even if the door has maint access. -Frenjo
			if(GLOBL.maint_all_access && isstationlevel(z))
				flick("door_maint_access_locked_deny", src)
			else
				flick("door_deny", src)

/obj/machinery/door/airlock/maintenance/allowed(mob/M)
	if(GLOBL.maint_all_access && isstationlevel(M.z))
		return TRUE
	return ..(M)