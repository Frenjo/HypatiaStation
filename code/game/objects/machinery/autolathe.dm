//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/var/global/list/autolathe_recipes = list(
	/*screwdriver removed*/
	new /obj/item/reagent_containers/glass/bucket(),
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
	new /obj/item/stack/sheet/metal(),
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
	new /obj/item/reagent_containers/glass/beaker(),
	new /obj/item/reagent_containers/glass/beaker/large(),
	new /obj/item/reagent_containers/glass/beaker/vial(),
	new /obj/item/reagent_containers/syringe(),
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
	desc = "It produces items using metal and glass."
	icon = 'icons/obj/machines/fabricators.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 100
	)

	var/list/stored_materials = list(MATERIAL_METAL = 0, MATERIAL_GLASS = 0)
	var/list/storage_capacity = list(MATERIAL_METAL = 150000, MATERIAL_GLASS = 75000)

	var/operating = 0.0
	var/panel_open = 0

	var/list/L = list()
	var/list/LL = list()

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0

	var/datum/wires/autolathe/wires = null

	var/busy = 0

/obj/machinery/autolathe/proc/wires_win(mob/user)
	var/dat
	dat += "Autolathe Wires:<BR>"
	dat += wires.GetInteractWindow()

/obj/machinery/autolathe/proc/regular_win(mob/user)
	var/dat = "<B>Metal Amount:</B> [stored_materials[MATERIAL_METAL]] cm<sup>3</sup> (MAX: [storage_capacity[MATERIAL_METAL]])<BR>\n<FONT color=blue><B>Glass Amount:</B></FONT> [stored_materials[MATERIAL_GLASS]] cm<sup>3</sup> (MAX: [storage_capacity[MATERIAL_GLASS]])<HR>"
	var/list/objs = list()
	objs += src.L
	if(src.hacked)
		objs += src.LL
	for(var/obj/t in objs)
		var/title = "[t.name] ([t.matter_amounts[MATERIAL_METAL]] m /[t.matter_amounts[MATERIAL_GLASS]] g)"
		if(stored_materials[MATERIAL_METAL] < t.matter_amounts[MATERIAL_METAL] || stored_materials[MATERIAL_GLASS] < t.matter_amounts[MATERIAL_GLASS])
			dat += title + "<br>"
			continue
		dat += "<A href='byond://?src=\ref[src];make=\ref[t]'>[title]</A>"
		if(istype(t, /obj/item/stack))
			var/obj/item/stack/S = t
			var/max_multiplier = min(S.max_amount, S.matter_amounts[MATERIAL_METAL] ? round(stored_materials[MATERIAL_METAL] / S.matter_amounts[MATERIAL_METAL]) : INFINITY, \
				S.matter_amounts[MATERIAL_GLASS] ? round(stored_materials[MATERIAL_GLASS] / S.matter_amounts[MATERIAL_GLASS]) : INFINITY)
			if(max_multiplier > 1)
				dat += " |"
			if(max_multiplier > 10)
				dat += " <A href='byond://?src=\ref[src];make=\ref[t];multiplier=[10]'>x[10]</A>"
			if(max_multiplier > 25)
				dat += " <A href='byond://?src=\ref[src];make=\ref[t];multiplier=[25]'>x[25]</A>"
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
	if(electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/obj/machinery/autolathe/interact(mob/user)
	if(..())
		return

	if(src.shocked)
		src.shock(user, 50)

	if(src.panel_open)
		wires_win(user, 50)
		return

	if(src.disabled)
		to_chat(user, SPAN_WARNING("You press the button, but nothing happens."))
		return

	regular_win(user)
	return

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
			for(var/obj/I in component_parts)
				I.loc = loc
				if(I.reliability != 100 && crit_fail)
					I.crit_fail = TRUE
			for(var/material_path in stored_materials)
				var/decl/material/material = GET_DECL_INSTANCE(material_path)
				if(stored_materials[material_path] >= material.per_unit)
					new material.sheet_path(loc, round(stored_materials[material_path] / material.per_unit))
			qdel(src)
			return TRUE

	return ..()

/obj/machinery/autolathe/attackby(obj/item/O, mob/user)
	if(stored_materials[MATERIAL_METAL] + O.matter_amounts[MATERIAL_METAL] > storage_capacity[MATERIAL_METAL])
		to_chat(user, SPAN_WARNING("The autolathe is full. Please remove metal from the autolathe in order to insert more."))
		return 1
	if(stored_materials[MATERIAL_GLASS] + O.matter_amounts[MATERIAL_GLASS] > storage_capacity[MATERIAL_GLASS])
		to_chat(user, SPAN_WARNING("The autolathe is full. Please remove glass from the autolathe in order to insert more."))
		return 1
	if(O.matter_amounts[MATERIAL_METAL] == 0 && O.matter_amounts[MATERIAL_GLASS] == 0)
		to_chat(user, SPAN_WARNING("This object does not contain significant amounts of metal or glass, or cannot be accepted by the autolathe due to size or hazardous materials."))
		return 1
	/*
		if (istype(O, /obj/item/grab) && src.hacked)
			var/obj/item/grab/G = O
			if (prob(25) && G.affecting)
				G.affecting.gib()
				m_amount += 50000
			return
	*/

	var/amount = 1
	var/obj/item/stack/stack
	var/m_amt = O.matter_amounts[MATERIAL_METAL]
	var/g_amt = O.matter_amounts[MATERIAL_GLASS]
	if(istype(O, /obj/item/stack))
		stack = O
		amount = stack.amount
		if(m_amt)
			amount = min(amount, round((storage_capacity[MATERIAL_METAL] - stored_materials[MATERIAL_METAL]) / m_amt))
			flick("autolathe_o", src)//plays metal insertion animation
		if(g_amt)
			amount = min(amount, round((storage_capacity[MATERIAL_GLASS] - stored_materials[MATERIAL_GLASS]) / g_amt))
			flick("autolathe_r", src)//plays glass insertion animation
		stack.use(amount)
	else
		usr.before_take_item(O)
		O.loc = src

	icon_state = "autolathe"
	busy = 1
	use_power(max(1000, (m_amt + g_amt) * amount / 10))
	stored_materials[MATERIAL_METAL] += m_amt * amount
	stored_materials[MATERIAL_GLASS] += g_amt * amount
	to_chat(user, "You insert [amount] sheet[amount > 1 ? "s" : ""] to the autolathe.")
	if(O && O.loc == src)
		qdel(O)
	busy = 0
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

	if(!busy)
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
				var/turf/LOC = get_turf(usr)
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
				max_multiplier = min(S.max_amount, S.matter_amounts[MATERIAL_METAL] ? round(stored_materials[MATERIAL_METAL] / S.matter_amounts[MATERIAL_METAL]) : INFINITY, \
					S.matter_amounts[MATERIAL_GLASS] ? round(stored_materials[MATERIAL_GLASS] / S.matter_amounts[MATERIAL_GLASS]) : INFINITY)  // pasta from regular_win() to make sure the numbers match -walter0o

			if((multiplier > max_multiplier) || (multiplier <= 0)) // somebody is trying to exploit, alert admins-walter0o
				var/turf/LOC = get_turf(usr)
				message_admins("[key_name_admin(usr)] tried to exploit an autolathe with multiplier set to <u>[multiplier]</u> on <u>[template]</u>  ! ([LOC ? "<a href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[LOC.x];Y=[LOC.y];Z=[LOC.z]'>JMP</a>" : "null"])" , 0)
				log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe with multiplier set to [multiplier] on [template]  !")
				return

			var/power = max(2000, (template.matter_amounts[MATERIAL_METAL] + template.matter_amounts[MATERIAL_GLASS]) * multiplier / 5)
			if(stored_materials[MATERIAL_METAL] >= template.matter_amounts[MATERIAL_METAL] * multiplier && stored_materials[MATERIAL_GLASS] >= template.matter_amounts[MATERIAL_GLASS] * multiplier)
				busy = 1
				use_power(power)
				icon_state = "autolathe"
				flick("autolathe_n", src)
				spawn(16)
					use_power(power)
					spawn(16)
						use_power(power)
						spawn(16)
							stored_materials[MATERIAL_METAL] -= template.matter_amounts[MATERIAL_METAL] * multiplier
							stored_materials[MATERIAL_GLASS] -= template.matter_amounts[MATERIAL_GLASS] * multiplier
							if(stored_materials[MATERIAL_METAL] < 0)
								stored_materials[MATERIAL_METAL] = 0
							if(stored_materials[MATERIAL_GLASS] < 0)
								stored_materials[MATERIAL_GLASS] = 0
							var/obj/new_item = new template.type(T)
							if(multiplier > 1)
								var/obj/item/stack/S = new_item
								S.amount = multiplier
							busy = 0
							src.updateUsrDialog()
	else
		to_chat(usr, SPAN_WARNING("The autolathe is busy. Please wait for completion of previous operation."))
	src.updateUsrDialog()
	return

/obj/machinery/autolathe/RefreshParts()
	..()
	var/tot_rating = 0
	for(var/obj/item/stock_part/matter_bin/MB in component_parts)
		tot_rating += MB.rating
	tot_rating *= 25000
	storage_capacity[MATERIAL_METAL] = tot_rating * 2
	storage_capacity[MATERIAL_GLASS] = tot_rating

/obj/machinery/autolathe/New()
	..()

	wires = new(src)

	component_parts = list()
	component_parts += new /obj/item/circuitboard/autolathe(src)
	component_parts += new /obj/item/stock_part/matter_bin(src)
	component_parts += new /obj/item/stock_part/matter_bin(src)
	component_parts += new /obj/item/stock_part/matter_bin(src)
	component_parts += new /obj/item/stock_part/manipulator(src)
	component_parts += new /obj/item/stock_part/console_screen(src)
	RefreshParts()

	src.L = global.autolathe_recipes
	src.LL = global.autolathe_recipes_hidden