/client/proc/shift_change()
	set name = "Call Transfer Shuttle"
	set category = "Special Verbs"

	if(alert("Are you sure you want to call the transfer shuttle?",,"Yes","No")!="Yes")
		return
	init_shift_change(src, 1)