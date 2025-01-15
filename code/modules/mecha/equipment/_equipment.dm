//TODO: Add critfail checks and reliability
//DO NOT ADD MECHA PARTS TO THE GAME WITH THE DEFAULT "SPRITE ME" SPRITE!
//I'm annoyed I even have to tell you this! SPRITE FIRST, then commit.

/obj/item/mecha_part/equipment
	name = "mecha equipment"
	desc = "A default piece of exosuit equipment. You should never see this."
	icon = 'icons/obj/mecha/mecha_equipment.dmi'
	icon_state = "mecha_equip"

	force = 5
	origin_tech = list(/datum/tech/materials = 2)
	construction_time = 100
	construction_cost = list(MATERIAL_METAL = 10000)
	reliability = 1000

	var/equip_cooldown = 0
	var/equip_ready = TRUE
	var/energy_drain = 0
	var/obj/mecha/chassis = null
	var/range = MELEE //bitflags
	var/salvageable = 1
	var/destruction_sound = 'sound/mecha/critdestr.ogg'

/obj/item/mecha_part/equipment/Destroy() //missiles detonating, teleporter creating singularity?
	if(isnotnull(chassis))
		chassis.equipment.Remove(src)
		listclearnulls(chassis.equipment)
		if(chassis.selected == src)
			chassis.selected = null
		update_chassis_page()
		chassis.occupant_message(SPAN_DANGER("The [src] is destroyed!"))
		chassis.log_append_to_last("[src] is destroyed.", 1)
		chassis.occupant << sound(destruction_sound, volume = 50)
		chassis = null
	return ..()

/obj/item/mecha_part/equipment/proc/can_attach(obj/mecha/M)
	if(!istype(M))
		return FALSE
	if(is_type_in_list(src, M.excluded_equipment))
		return FALSE
	if(length(M.equipment) >= M.max_equip)
		return FALSE
	return TRUE

/obj/item/mecha_part/equipment/proc/attach(obj/mecha/M)
	M.equipment.Add(src)
	chassis = M
	loc = M
	M.log_message("[src] initialized.")
	if(!M.selected)
		M.selected = src
	update_chassis_page()

/obj/item/mecha_part/equipment/proc/detach(atom/moveto = null)
	moveto = moveto || GET_TURF(chassis)
	if(Move(moveto))
		chassis.equipment.Remove(src)
		if(chassis.selected == src)
			chassis.selected = null
		update_chassis_page()
		chassis.log_message("[src] removed from equipment.")
		chassis = null
		set_ready_state(1)

/obj/item/mecha_part/equipment/proc/do_after_cooldown(target = 1)
	sleep(equip_cooldown)
	set_ready_state(1)
	if(isnotnull(target) && isnotnull(chassis))
		return TRUE
	return FALSE

/obj/item/mecha_part/equipment/proc/update_chassis_page()
	if(isnotnull(chassis))
		send_byjax(chassis.occupant, "exosuit.browser", "eq_list", chassis.get_equipment_list())
		send_byjax(chassis.occupant, "exosuit.browser", "equipment_menu", chassis.get_equipment_menu(), "dropdowns")
		return TRUE

/obj/item/mecha_part/equipment/proc/update_equip_info()
	if(isnotnull(chassis))
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())
		return TRUE

/obj/item/mecha_part/equipment/proc/critfail()
	if(isnotnull(chassis))
		log_message("Critical failure", 1)

/obj/item/mecha_part/equipment/proc/get_equip_info()
	. = "<span style=\"color:[equip_ready ? "#0f0" : "#f00"];\">*</span>&nbsp;[chassis.selected == src ? "<b>" : "<a href='byond://?src=\ref[chassis];select_equip=\ref[src]'>"][name][chassis.selected == src ? "</b>" : "</a>"]"

/obj/item/mecha_part/equipment/proc/is_ranged()//add a distance restricted equipment. Why not?
	return range & RANGED

/obj/item/mecha_part/equipment/proc/is_melee()
	return range & MELEE

/obj/item/mecha_part/equipment/proc/action_checks(atom/target)
	if(isnull(target))
		return FALSE
	if(isnull(chassis))
		return FALSE
	if(!equip_ready)
		return FALSE
	if(crit_fail)
		return FALSE
	if(energy_drain && !chassis.has_charge(energy_drain))
		return FALSE
	return TRUE

/obj/item/mecha_part/equipment/proc/action(atom/target)
	return

/obj/item/mecha_part/equipment/Topic(href, href_list)
	if(href_list["detach"])
		detach()

/obj/item/mecha_part/equipment/proc/set_ready_state(state)
	equip_ready = state
	if(isnotnull(chassis))
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())

/obj/item/mecha_part/equipment/proc/occupant_message(message)
	if(isnotnull(chassis))
		chassis.occupant_message("\icon[src] [message]")

/obj/item/mecha_part/equipment/proc/log_message(message)
	if(isnotnull(chassis))
		chassis.log_message("<i>[src]:</i> [message]")