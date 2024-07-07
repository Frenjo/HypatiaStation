/area/station/engineering/engine/singularity/power_alert(state, source)
	if(state != power_alarm)
		investigate_log("has a power alarm!", "singulo")
	. = ..()