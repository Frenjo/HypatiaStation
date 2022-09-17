//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/var/global/list/autolathe_recipes = list(
	/*screwdriver removed*/
	new /obj/item/weapon/reagent_containers/glass/bucket(),
	new /obj/item/weapon/crowbar(),
	new /obj/item/device/flashlight(),
	new /obj/item/weapon/extinguisher(),
	new /obj/item/device/multitool(),
	new /obj/item/device/t_scanner(),
	new /obj/item/weapon/weldingtool(),
	new /obj/item/weapon/screwdriver(),
	new /obj/item/weapon/wirecutters(),
	new /obj/item/weapon/wrench(),
	new /obj/item/clothing/head/welding(),
	new /obj/item/weapon/stock_part/console_screen(),
	new /obj/item/weapon/airlock_electronics(),
	new /obj/item/weapon/airalarm_electronics(),
	new /obj/item/weapon/firealarm_electronics(),
	new /obj/item/weapon/module/power_control(),
	new /obj/item/stack/sheet/metal(),
	new /obj/item/stack/sheet/glass(),
	new /obj/item/stack/sheet/rglass(),
	new /obj/item/stack/rods(),
	new /obj/item/weapon/rcd_ammo(),
	new /obj/item/weapon/kitchenknife(),
	new /obj/item/weapon/scalpel(),
	new /obj/item/weapon/circular_saw(),
	new /obj/item/weapon/surgicaldrill(),
	new /obj/item/weapon/retractor(),
	new /obj/item/weapon/cautery(),
	new /obj/item/weapon/hemostat(),
	new /obj/item/weapon/reagent_containers/glass/beaker(),
	new /obj/item/weapon/reagent_containers/glass/beaker/large(),
	new /obj/item/weapon/reagent_containers/glass/beaker/vial(),
	new /obj/item/weapon/reagent_containers/syringe(),
	new /obj/item/ammo_casing/shotgun/blank(),
	new /obj/item/ammo_casing/shotgun/beanbag(),
	new /obj/item/ammo_magazine/c45r(),
	new /obj/item/device/taperecorder(),
	new /obj/item/device/assembly/igniter(),
	new /obj/item/device/assembly/signaler(),
	new /obj/item/device/radio/headset(),
	new /obj/item/device/radio/off(),
	new /obj/item/device/assembly/infra(),
	new /obj/item/device/assembly/timer(),
	new /obj/item/device/assembly/prox_sensor(),
	new /obj/item/weapon/light/tube(),
	new /obj/item/weapon/light/bulb(),
	new /obj/item/ashtray/glass(),
	new /obj/item/weapon/camera_assembly()
)

/var/global/list/autolathe_recipes_hidden = list(
	new /obj/item/weapon/flamethrower/full(),
	new /obj/item/weapon/rcd(),
	new /obj/item/device/radio/electropack(),
	new /obj/item/weapon/weldingtool/largetank(),
	new /obj/item/weapon/handcuffs(),
	new /obj/item/ammo_magazine/a357(),
	new /obj/item/ammo_magazine/c45m(),
	new /obj/item/ammo_casing/shotgun(),
	new /obj/item/ammo_casing/shotgun/dart()
	/* new /obj/item/weapon/shield/riot()*/
)

/obj/machinery/autolathe
	name = "\improper Autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE

	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100

	var/m_amount = 0.0
	var/max_m_amount = 150000.0

	var/g_amount = 0.0
	var/max_g_amount = 75000.0

	var/operating = 0.0
	var/panel_open = 0

	var/list/L = list()
	var/list/LL = list()

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0

	var/datum/wires/autolathe/wires = null

	var/busy = 0

/obj/machinery/autolathe/proc/wires_win(mob/user as mob)
	var/dat
	dat += "Autolathe Wires:<BR>"
	dat += wires.GetInteractWindow()

/obj/machinery/autolathe/proc/regular_win(mob/user as mob)
	var/dat = "<B>Metal Amount:</B> [src.m_amount] cm<sup>3</sup> (MAX: [max_m_amount])<BR>\n<FONT color=blue><B>Glass Amount:</B></FONT> [src.g_amount] cm<sup>3</sup> (MAX: [max_g_amount])<HR>"
	var/list/objs = list()
	objs += src.L
	if(src.hacked)
		objs += src.LL
	for(var/obj/t in objs)
		var/title = "[t.name] ([t.m_amt] m /[t.g_amt] g)"
		if(m_amount < t.m_amt || g_amount < t.g_amt)
			dat += title + "<br>"
			continue
		dat += "<A href='?src=\ref[src];make=\ref[t]'>[title]</A>"
		if(istype(t, /obj/item/stack))
			var/obj/item/stack/S = t
			var/max_multiplier = min(S.max_amount, S.m_amt ? round(m_amount / S.m_amt) : INFINITY, S.g_amt ? round(g_amount / S.g_amt) : INFINITY)
			if(max_multiplier > 1)
				dat += " |"
			if(max_multiplier > 10)
				dat += " <A href='?src=\ref[src];make=\ref[t];multiplier=[10]'>x[10]</A>"
			if(max_multiplier > 25)
				dat += " <A href='?src=\ref[src];make=\ref[t];multiplier=[25]'>x[25]</A>"
			if(max_multiplier > 1)
				dat += " <A href='?src=\ref[src];make=\ref[t];multiplier=[max_multiplier]'>x[max_multiplier]</A>"
		dat += "<br>"
	user << browse("<HTML><HEAD><TITLE>Autolathe Control Panel</TITLE></HEAD><BODY><TT>[dat]</TT></BODY></HTML>", "window=autolathe_regular")
	onclose(user, "autolathe_regular")

/obj/machinery/autolathe/proc/shock(mob/user, prb)
	if(stat & (BROKEN | NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/obj/machinery/autolathe/interact(mob/user as mob)
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

/obj/machinery/autolathe/attackby(obj/item/O as obj, mob/user as mob)
	if(stat)
		return 1

	if(busy)
		to_chat(user, SPAN_WARNING("The autolathe is busy. Please wait for completion of previous operation."))
		return 1

	if(istype(O, /obj/item/weapon/screwdriver))
		if(!panel_open)
			src.panel_open = 1
			src.icon_state = "autolathe_t"
			to_chat(user, "You open the maintenance hatch of [src].")
		else
			src.panel_open = 0
			src.icon_state = "autolathe"
			to_chat(user, "You close the maintenance hatch of [src].")
		return 1

	if(panel_open)
		if(istype(O, /obj/item/weapon/crowbar))
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			M.state = 2
			M.icon_state = "box_1"
			for(var/obj/I in component_parts)
				if(I.reliability != 100 && crit_fail)
					I.crit_fail = 1
				I.loc = src.loc
			if(m_amount >= 3750)
				var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal(src.loc)
				G.amount = round(m_amount / 3750)
			if(g_amount >= 3750)
				var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass(src.loc)
				G.amount = round(g_amount / 3750)
			qdel(src)
			return 1
		else
			user.set_machine(src)
			interact(user)
			return 1

	if(src.m_amount + O.m_amt > max_m_amount)
		to_chat(user, SPAN_WARNING("The autolathe is full. Please remove metal from the autolathe in order to insert more."))
		return 1
	if(src.g_amount + O.g_amt > max_g_amount)
		to_chat(user, SPAN_WARNING("The autolathe is full. Please remove glass from the autolathe in order to insert more."))
		return 1
	if(O.m_amt == 0 && O.g_amt == 0)
		to_chat(user, SPAN_WARNING("This object does not contain significant amounts of metal or glass, or cannot be accepted by the autolathe due to size or hazardous materials."))
		return 1
	/*
		if (istype(O, /obj/item/weapon/grab) && src.hacked)
			var/obj/item/weapon/grab/G = O
			if (prob(25) && G.affecting)
				G.affecting.gib()
				m_amount += 50000
			return
	*/

	var/amount = 1
	var/obj/item/stack/stack
	var/m_amt = O.m_amt
	var/g_amt = O.g_amt
	if(istype(O, /obj/item/stack))
		stack = O
		amount = stack.amount
		if(m_amt)
			amount = min(amount, round((max_m_amount - src.m_amount) / m_amt))
			flick("autolathe_o", src)//plays metal insertion animation
		if(g_amt)
			amount = min(amount, round((max_g_amount - src.g_amount) / g_amt))
			flick("autolathe_r", src)//plays glass insertion animation
		stack.use(amount)
	else
		usr.before_take_item(O)
		O.loc = src

	icon_state = "autolathe"
	busy = 1
	use_power(max(1000, (m_amt + g_amt) * amount / 10))
	src.m_amount += m_amt * amount
	src.g_amount += g_amt * amount
	to_chat(user, "You insert [amount] sheet[amount > 1 ? "s" : ""] to the autolathe.")
	if(O && O.loc == src)
		qdel(O)
	busy = 0
	src.updateUsrDialog()

/obj/machinery/autolathe/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(!busy)
		if(href_list["make"])
			var/turf/T = get_step(src.loc, get_dir(src,usr))

			// critical exploit fix start -walter0o
			var/obj/item/template = null
			var/attempting_to_build = locate(href_list["make"])

			if(!attempting_to_build)
				return

			if(locate(attempting_to_build, src.L) || locate(attempting_to_build, src.LL)) // see if the requested object is in one of the construction lists, if so, it is legit -walter0o
				template = attempting_to_build

			else // somebody is trying to exploit, alert admins -walter0o
				var/turf/LOC = get_turf(usr)
				message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate <a href='?_src_=vars;Vars=\ref[attempting_to_build]'>[attempting_to_build]</a> ! ([LOC ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[LOC.x];Y=[LOC.y];Z=[LOC.z]'>JMP</a>" : "null"])", 0)
				log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe to duplicate [attempting_to_build] !")
				return

			// now check for legit multiplier, also only stacks should pass with one to prevent raw-materials-manipulation -walter0o

			var/multiplier = text2num(href_list["multiplier"])

			if(!multiplier)
				multiplier = 1
			var/max_multiplier = 1

			if(istype(template, /obj/item/stack)) // stacks are the only items which can have a multiplier higher than 1 -walter0o
				var/obj/item/stack/S = template
				max_multiplier = min(S.max_amount, S.m_amt ? round(m_amount / S.m_amt) : INFINITY, S.g_amt ? round(g_amount / S.g_amt) : INFINITY)  // pasta from regular_win() to make sure the numbers match -walter0o

			if((multiplier > max_multiplier) || (multiplier <= 0)) // somebody is trying to exploit, alert admins-walter0o
				var/turf/LOC = get_turf(usr)
				message_admins("[key_name_admin(usr)] tried to exploit an autolathe with multiplier set to <u>[multiplier]</u> on <u>[template]</u>  ! ([LOC ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[LOC.x];Y=[LOC.y];Z=[LOC.z]'>JMP</a>" : "null"])" , 0)
				log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe with multiplier set to [multiplier] on [template]  !")
				return

			var/power = max(2000, (template.m_amt + template.g_amt) * multiplier / 5)
			if(src.m_amount >= template.m_amt * multiplier && src.g_amount >= template.g_amt * multiplier)
				busy = 1
				use_power(power)
				icon_state = "autolathe"
				flick("autolathe_n", src)
				spawn(16)
					use_power(power)
					spawn(16)
						use_power(power)
						spawn(16)
							src.m_amount -= template.m_amt * multiplier
							src.g_amount -= template.g_amt * multiplier
							if(src.m_amount < 0)
								src.m_amount = 0
							if(src.g_amount < 0)
								src.g_amount = 0
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
	for(var/obj/item/weapon/stock_part/matter_bin/MB in component_parts)
		tot_rating += MB.rating
	tot_rating *= 25000
	max_m_amount = tot_rating * 2
	max_g_amount = tot_rating

/obj/machinery/autolathe/New()
	..()

	wires = new(src)

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/autolathe(src)
	component_parts += new /obj/item/weapon/stock_part/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_part/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_part/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_part/manipulator(src)
	component_parts += new /obj/item/weapon/stock_part/console_screen(src)
	RefreshParts()

	src.L = global.autolathe_recipes
	src.LL = global.autolathe_recipes_hidden