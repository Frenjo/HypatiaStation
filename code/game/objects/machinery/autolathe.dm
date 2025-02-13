//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/var/global/list/autolathe_recipes = list(
	/*screwdriver removed*/
	new /obj/item/reagent_holder/glass/bucket(),
	new /obj/item/crowbar(),
	new /obj/item/flashlight(),
	new /obj/item/extinguisher(),
	new /obj/item/multitool(),
	new /obj/item/t_scanner(),
	new /obj/item/weldingtool(),
	new /obj/item/screwdriver(),
	new /obj/item/wirecutters(),
	new /obj/item/wrench(),
	new /obj/item/clothing/head/welding(),
	new /obj/item/stock_part/console_screen(),
	new /obj/item/airlock_electronics(),
	new /obj/item/airalarm_electronics(),
	new /obj/item/firealarm_electronics(),
	new /obj/item/module/power_control(),
	new /obj/item/stack/sheet/steel(),
	new /obj/item/stack/sheet/glass(),
	new /obj/item/stack/sheet/glass/reinforced(),
	new /obj/item/stack/rods(),
	new /obj/item/rcd_ammo(),
	new /obj/item/kitchenknife(),
	new /obj/item/scalpel(),
	new /obj/item/circular_saw(),
	new /obj/item/surgicaldrill(),
	new /obj/item/retractor(),
	new /obj/item/cautery(),
	new /obj/item/hemostat(),
	new /obj/item/reagent_holder/glass/beaker(),
	new /obj/item/reagent_holder/glass/beaker/large(),
	new /obj/item/reagent_holder/glass/beaker/vial(),
	new /obj/item/reagent_holder/syringe(),
	new /obj/item/ammo_casing/shotgun/blank(),
	new /obj/item/ammo_casing/shotgun/beanbag(),
	new /obj/item/ammo_magazine/c45r(),
	new /obj/item/taperecorder(),
	new /obj/item/assembly/igniter(),
	new /obj/item/assembly/signaler(),
	new /obj/item/radio/headset(),
	new /obj/item/radio/off(),
	new /obj/item/assembly/infra(),
	new /obj/item/assembly/timer(),
	new /obj/item/assembly/prox_sensor(),
	new /obj/item/light/tube(),
	new /obj/item/light/bulb(),
	new /obj/item/ashtray/glass(),
	new /obj/item/camera_assembly()
)

/var/global/list/autolathe_recipes_hidden = list(
	new /obj/item/flamethrower/full(),
	new /obj/item/rcd(),
	new /obj/item/radio/electropack(),
	new /obj/item/weldingtool/largetank(),
	new /obj/item/handcuffs(),
	new /obj/item/ammo_magazine/a357(),
	new /obj/item/ammo_magazine/c45m(),
	new /obj/item/ammo_casing/shotgun(),
	new /obj/item/ammo_casing/shotgun/dart()
	/* new /obj/item/shield/riot()*/
)

/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using steel and glass."
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 100
	)

	var/list/stored_materials = list(/decl/material/steel = 0, /decl/material/glass = 0)
	var/list/storage_capacity = list(/decl/material/steel = 0, /decl/material/glass = 0) // This gets determined by the installed matter bins.

	var/panel_open = 0

	var/list/L = list()
	var/list/LL = list()

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0

	var/datum/wires/autolathe/wires = null

	var/busy = FALSE

/obj/machinery/autolathe/New()
	. = ..()
	wires = new /datum/wires/autolathe(src)

	src.L = global.autolathe_recipes
	src.LL = global.autolathe_recipes_hidden

/obj/machinery/autolathe/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/autolathe/add_parts()
	component_parts = list(
		new /obj/item/circuitboard/autolathe(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/manipulator(src),
		new /obj/item/stock_part/console_screen(src)
	)
	return TRUE

/obj/machinery/autolathe/refresh_parts()
	var/total_rating = 0
	for(var/obj/item/stock_part/matter_bin/bin in component_parts)
		total_rating += bin.rating
	total_rating *= 25000
	for(var/material_path in storage_capacity)
		storage_capacity[material_path] = total_rating * 2

/obj/machinery/autolathe/interact(mob/user)
	if(..())
		return

	if(shocked)
		shock(user, 50)

	if(panel_open)
		wires_win(user, 50)
		return

	if(disabled)
		to_chat(user, SPAN_WARNING("You press the button, but nothing happens."))
		return

	regular_win(user)
	return

/obj/machinery/autolathe/proc/wires_win(mob/user)
	var/dat
	dat += "Autolathe Wires:"
	dat += "<br>"
	dat += wires.GetInteractWindow()

/obj/machinery/autolathe/proc/regular_win(mob/user)
	var/dat
	var/total_stored = 0
	var/total_capacity = 0
	for(var/material_path in stored_materials)
		var/decl/material/mat = material_path
		total_stored += stored_materials[mat]
		total_capacity += storage_capacity[mat]
		dat += "<font color='[initial(mat.mint_colour_code)]'><b>[initial(mat.name)] Amount:</b></font> [stored_materials[mat]]cm<sup>3</sup>"
		dat += " (MAX: [storage_capacity[mat]]cm<sup>3</sup>)"
		dat += "<br>"
	dat += "<b>Total Amount:</b> [total_stored]cm<sup>3</sup> (MAX: [total_capacity]cm<sup>3</sup>)"
	dat += "<hr>"

	var/list/objs = list()
	objs += src.L
	if(src.hacked)
		objs += src.LL
	for(var/obj/t in objs)
		var/title = "[t.name] ([output_part_cost(t)])"
		if(!check_resources(t))
			dat += title
			dat += "<br>"
			continue
		dat += "<A href='byond://?src=\ref[src];make=\ref[t]'>[title]</A>"
		if(istype(t, /obj/item/stack))
			var/obj/item/stack/S = t
			var/max_multiplier = S.max_amount
			for(var/material_path in S.matter_amounts)
				max_multiplier = min(max_multiplier, round(stored_materials[material_path] / S.matter_amounts[material_path]))
			if(max_multiplier > 1)
				dat += " |"
			if(max_multiplier > 10)
				dat += " <A href='byond://?src=\ref[src];make=\ref[t];multiplier=10'>x10</A>"
			if(max_multiplier > 25)
				dat += " <A href='byond://?src=\ref[src];make=\ref[t];multiplier=25'>x25</A>"
			if(max_multiplier > 1)
				dat += " <A href='byond://?src=\ref[src];make=\ref[t];multiplier=[max_multiplier]'>x[max_multiplier]</A>"
		dat += "<br>"
	user << browse("<HTML><HEAD><TITLE>Autolathe Control Panel</TITLE></HEAD><BODY><TT>[dat]</TT></BODY></HTML>", "window=autolathe_regular")
	onclose(user, "autolathe_regular")

/obj/machinery/autolathe/proc/shock(mob/user, prb)
	if(stat & (BROKEN | NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	make_sparks(5, TRUE, src)
	if(electrocute_mob(user, GET_AREA(src), src, 0.7))
		return 1
	else
		return 0

/obj/machinery/autolathe/attack_tool(obj/item/tool, mob/user)
	if(stat)
		return TRUE
	if(busy)
		to_chat(user, SPAN_WARNING("The autolathe is busy. Please wait for completion of previous operation."))
		return TRUE

	if(isscrewdriver(tool))
		if(!panel_open)
			icon_state = "autolathe_t"
		else
			icon_state = "autolathe"
		panel_open = !panel_open
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, panel_open)
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		return TRUE

	if(iscrowbar(tool))
		if(panel_open)
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(loc)
			M.state = 2
			M.icon_state = "box_1"
			for_no_type_check(var/obj/item/part, component_parts)
				part.forceMove(loc)
				if(part.reliability != 100 && crit_fail)
					part.crit_fail = TRUE
			for(var/material_path in stored_materials)
				var/decl/material/mat = material_path
				var/per_unit = initial(mat.per_unit)
				if(stored_materials[material_path] >= per_unit)
					var/sheet_path = initial(mat.sheet_path)
					new sheet_path(loc, round(stored_materials[material_path] / per_unit))
			qdel(src)
			return TRUE

	return ..()

/obj/machinery/autolathe/attack_by(obj/item/I, mob/user)
	// If it doesn't have any matter then we obviously can't recycle it.
	if(!length(I.matter_amounts))
		to_chat(user, SPAN_WARNING("\The [I] does not contain sufficient material to be accepted by \the [src]."))
		return TRUE

	for(var/material_path in I.matter_amounts)
		// If it has any matter that we can't accept, then we also can't recycle it.
		if(!(material_path in stored_materials))
			to_chat(user, SPAN_WARNING("\The [src] cannot accept \the [I]."))
			return TRUE
		// Finally, if any of the required material storages are full, then we again can't recycle it.
		if(stored_materials[material_path] + I.matter_amounts[material_path] > storage_capacity[material_path])
			var/decl/material/mat = material_path
			to_chat(user, SPAN_WARNING("\The [src] is full. Please remove [lowertext(initial(mat.name))] from \the [src] in order to insert more."))
			return TRUE

	return ..()

/obj/machinery/autolathe/attackby(obj/item/O, mob/user)
	var/amount = 1
	var/m_amt = O.matter_amounts[MATERIAL_METAL]
	var/g_amt = O.matter_amounts[/decl/material/glass]
	if(istype(O, /obj/item/stack))
		var/obj/item/stack/stack = O
		amount = stack.amount
		if(m_amt)
			amount = min(amount, round((storage_capacity[MATERIAL_METAL] - stored_materials[MATERIAL_METAL]) / m_amt))
			flick("autolathe_o", src)//plays metal insertion animation
		if(g_amt)
			amount = min(amount, round((storage_capacity[/decl/material/glass] - stored_materials[/decl/material/glass]) / g_amt))
			flick("autolathe_r", src)//plays glass insertion animation
		stack.use(amount)
	else
		usr.before_take_item(O)
		O.forceMove(src)

	icon_state = "autolathe"
	busy = TRUE
	use_power(max(1000, (m_amt + g_amt) * amount / 10))
	stored_materials[MATERIAL_METAL] += m_amt * amount
	stored_materials[/decl/material/glass] += g_amt * amount
	to_chat(user, SPAN_INFO("You insert [amount] sheet\s into the autolathe."))
	if(O?.loc == src)
		qdel(O)
	busy = FALSE
	updateUsrDialog()

/obj/machinery/autolathe/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/autolathe/attack_hand(mob/user)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(busy)
		to_chat(usr, SPAN_WARNING("The autolathe is busy. Please wait for completion of previous operation."))
		return

	if(href_list["make"])
		var/turf/T = get_step(src.loc, get_dir(src, usr))

		// critical exploit fix start -walter0o
		var/obj/item/template = null
		var/attempting_to_build = locate(href_list["make"])

		if(!attempting_to_build)
			return

		if(locate(attempting_to_build, src.L) || locate(attempting_to_build, src.LL)) // see if the requested object is in one of the construction lists, if so, it is legit -walter0o
			template = attempting_to_build

		else // somebody is trying to exploit, alert admins -walter0o
			var/turf/LOC = GET_TURF(usr)
			message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate <a href='byond://?_src_=vars;Vars=\ref[attempting_to_build]'>[attempting_to_build]</a> ! ([LOC ? "<a href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[LOC.x];Y=[LOC.y];Z=[LOC.z]'>JMP</a>" : "null"])", 0)
			log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe to duplicate [attempting_to_build] !")
			return

		// now check for legit multiplier, also only stacks should pass with one to prevent raw-materials-manipulation -walter0o

		var/multiplier = text2num(href_list["multiplier"])

		if(!multiplier)
			multiplier = 1
		var/max_multiplier = 1

		if(istype(template, /obj/item/stack)) // stacks are the only items which can have a multiplier higher than 1 -walter0o
			var/obj/item/stack/S = template
			max_multiplier = S.max_amount
			for(var/material_path in S.matter_amounts)
				max_multiplier = min(max_multiplier, round(stored_materials[material_path] / S.matter_amounts[material_path]))

		if((multiplier > max_multiplier) || (multiplier <= 0)) // somebody is trying to exploit, alert admins-walter0o
			var/turf/LOC = GET_TURF(usr)
			message_admins("[key_name_admin(usr)] tried to exploit an autolathe with multiplier set to <u>[multiplier]</u> on <u>[template]</u>  ! ([LOC ? "<a href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[LOC.x];Y=[LOC.y];Z=[LOC.z]'>JMP</a>" : "null"])" , 0)
			log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe with multiplier set to [multiplier] on [template]  !")
			return

		var/total_amount_used = 0
		var/has_enough_materials = FALSE
		for(var/material_path in template.matter_amounts)
			var/matter_amount = template.matter_amounts[material_path]
			total_amount_used += matter_amount
			if(stored_materials[material_path] >= matter_amount * multiplier)
				has_enough_materials = TRUE
		var/power = max(2000, total_amount_used * multiplier / 5)
		if(has_enough_materials)
			busy = TRUE
			use_power(power)
			icon_state = "autolathe"
			flick("autolathe_n", src)
			spawn(16)
				use_power(power)
				spawn(16)
					use_power(power)
					spawn(16)
						for(var/material_path in template.matter_amounts)
							stored_materials[material_path] -= template.matter_amounts[material_path] * multiplier
						var/obj/new_item = new template.type(T)
						if(multiplier > 1)
							var/obj/item/stack/S = new_item
							S.amount = multiplier
						busy = FALSE
						src.updateUsrDialog()
	src.updateUsrDialog()
	return

/obj/machinery/autolathe/proc/output_part_cost(obj/item/I)
	var/i = 0
	for(var/material_path in I.matter_amounts)
		if(material_path in stored_materials)
			var/decl/material/mat = material_path
			. += "[i ? " / " : null][I.matter_amounts[material_path]]cm<sup>3</sup> [lowertext(initial(mat.name))]"
			i++

/obj/machinery/autolathe/proc/check_resources(obj/item/I)
	for(var/material_path in I.matter_amounts)
		if(material_path in stored_materials)
			if(stored_materials[material_path] < I.matter_amounts[material_path])
				return FALSE
		else
			return FALSE
	return TRUE