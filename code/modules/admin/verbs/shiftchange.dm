/client/proc/shift_change()
	set category = PANEL_SPECIAL_VERBS
	set name = "Call Transfer Shuttle"

	if(alert("Are you sure you want to call the transfer shuttle?",,"Yes","No")!="Yes")
		return
	init_shift_change(src, 1)