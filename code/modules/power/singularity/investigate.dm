/area/station/engineering/engine/singularity/trigger_alert(alert_type, state, source)
	if(alert_type == ALERT_POWER && state != power_alarm)
		investigate_log("has a power alarm!", "singulo")
	. = ..()