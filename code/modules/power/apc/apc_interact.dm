/obj/machinery/power/apc/interact(mob/user)
	if(!user)
		return

	if(wiresexposed /*&& (!issilicon(user))*/) //Commented out the typecheck to allow engiborgs to repair damaged apcs.
		wires.Interact(user)

	// Open the APC NanoUI
	return ui_interact(user)

/obj/machinery/power/apc/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(isnull(user))
		return

	var/alist/data = alist(
		"locked" = locked,
		"isOperating" = operating,
		"externalPower" = main_status,
		"powerCellStatus" = cell ? cell.percent() : null,
		"chargeMode" = chargemode,
		"chargingStatus" = charging,
		"totalLoad" = round(last_used[TOTAL]),
		"totalCharging" = round(last_used[CHARGING]),
		"coverLocked" = coverlocked,
		"malfStatus" = get_malf_status(user),

		"powerChannels" = list(
			alist(
				"title" = "Equipment",
				"powerLoad" = last_used[EQUIP],
				"status" = equipment,
				"topicParams" = alist(
					"auto" = alist("eqp" = 3),
					"on" = alist("eqp" = 2),
					"off" = alist("eqp" = 1)
				)
			),
			alist(
				"title" = "Lighting",
				"powerLoad" = last_used[LIGHT],
				"status" = lighting,
				"topicParams" = alist(
					"auto" = alist("lgt" = 3),
					"on" = alist("lgt" = 2),
					"off" = alist("lgt" = 1)
				)
			),
			alist(
				"title" = "Environment",
				"powerLoad" = last_used[ENVIRON],
				"status" = environ,
				"topicParams" = alist(
					"auto" = alist("env" = 3),
					"on" = alist("env" = 2),
					"off" = alist("env" = 1)
				)
			)
		)
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new /datum/nanoui(user, src, ui_key, "apc.tmpl", "[area.name] - APC", 520, data["siliconUser"] ? 465 : 440)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update()

/obj/machinery/power/apc/proc/isWireCut(wireIndex)
	return wires.IsIndexCut(wireIndex)