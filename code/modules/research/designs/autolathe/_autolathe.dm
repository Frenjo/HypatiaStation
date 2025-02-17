// NOTE: Autolathe designs cannot have tech levels higher than 1 in any tree or they will only display when a lathe is hacked or emagged.
// This is unintended behaviour and may be removed without notice!
// The intended way to lock an item behind hacking/emagging is to set var/hidden = TRUE on the design datum.
/datum/design/autolathe
	build_type = DESIGN_TYPE_AUTOLATHE
	build_time = 4.8 SECONDS