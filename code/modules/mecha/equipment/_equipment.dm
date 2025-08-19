//TODO: Add critfail checks and reliability
//DO NOT ADD MECHA PARTS TO THE GAME WITH THE DEFAULT "SPRITE ME" SPRITE!
//I'm annoyed I even have to tell you this! SPRITE FIRST, then commit.

/obj/item/mecha_equipment
	name = "mecha equipment"
	desc = "A default piece of exosuit equipment. You should never see this."
	icon = 'icons/obj/mecha/mecha_equipment.dmi'
	icon_state = "blank"

	obj_flags = OBJ_FLAG_CONDUCT
	w_class = WEIGHT_CLASS_HUGE

	force = 5
	origin_tech = alist(/decl/tech/materials = 2)
	reliability = 1000

	var/obj/mecha/chassis = null

	var/mecha_types = null // Bitflags which determine which exosuits this equipment can be fitted to.

	var/equip_ready = TRUE
	var/equip_cooldown = 0
	var/energy_drain = 0
	var/equip_range = 0 //bitflags
	var/selectable = TRUE // This should be set to FALSE for equipment that's passive or has a separate activate button. IE armour plates, droids and passenger compartments.

	var/salvageable = TRUE
	var/destruction_sound = 'sound/mecha/voice/critdestr.ogg'

	var/allow_duplicates = TRUE // Can duplicates of this equipment be fitted?
	var/allow_detach = TRUE // Can this equipment detach once fitted?

/obj/item/mecha_equipment/Destroy() //missiles detonating, teleporter creating singularity?
	if(isnotnull(chassis))
		chassis.equipment.Remove(src)
		listclearnulls(chassis.equipment)
		if(chassis.selected == src)
			chassis.selected = null
		update_chassis_page()
		chassis.occupant_message(SPAN_DANGER("The [src] is destroyed!"))
		chassis.log_append_to_last("[src] is destroyed.", 1)
		SOUND_TO(chassis.occupant, sound(destruction_sound, volume = 50))
		chassis = null
	return ..()

/obj/item/mecha_equipment/process()
	if(isnull(chassis))
		set_ready_state(TRUE)
		return PROCESS_KILL

/obj/item/mecha_equipment/proc/can_attach(obj/mecha/mech)
	if(!istype(mech))
		return FALSE
	if(isnotnull(mecha_types) && !(mecha_types & mech.mecha_type)) // If we have flags and they aren't right, not allowed!
		return FALSE
	if(is_type_in_list(src, mech.excluded_equipment)) // If it's in the special exclusions list then it's also not allowed!
		return FALSE
	if(length(mech.equipment) >= mech.max_equip)
		return FALSE
	if(!allow_duplicates)
		for_no_type_check(var/obj/item/mecha_equipment/equip, mech.equipment) // Exact duplicate components aren't allowed.
			if(equip.type == type)
				return FALSE
	return TRUE

/obj/item/mecha_equipment/proc/attach(obj/mecha/M)
	M.equipment.Add(src)
	chassis = M
	loc = M
	M.log_message("[src] initialized.")
	if(!M.selected && selectable)
		M.selected = src
	update_chassis_page()

/obj/item/mecha_equipment/proc/can_detach(obj/mecha/mech)
	if(!allow_detach)
		return FALSE
	return TRUE

/obj/item/mecha_equipment/proc/detach(atom/moveto = null, force = FALSE)
	if(!force && !can_detach(chassis))
		chassis.occupant_message(SPAN_WARNING("Cannot detach \the [src]."))
		chassis.log_message("Attempted to detach non-removable equipment: [src].")
		return FALSE
	moveto = moveto || GET_TURF(chassis)
	if(!Move(moveto))
		return FALSE

	chassis.equipment.Remove(src)
	if(chassis.selected == src)
		chassis.selected = null
	update_chassis_page()
	chassis.log_message("[src] removed from equipment.")
	chassis = null
	set_ready_state(1)
	return TRUE

/obj/item/mecha_equipment/proc/start_cooldown(energy_modifier = 1)
	set_ready_state(FALSE)
	chassis.use_power(energy_drain * energy_modifier)
	sleep(equip_cooldown)
	set_ready_state(TRUE)

/obj/item/mecha_equipment/proc/do_after_cooldown(atom/target, energy_modifier = 1)
	if(isnull(chassis))
		return FALSE

	var/chassis_loc = chassis.loc
	set_ready_state(FALSE)
	chassis.use_power(energy_drain * energy_modifier)
	. = do_after(chassis.occupant, equip_cooldown, target = target)
	set_ready_state(TRUE)
	if(isnull(chassis) || chassis.loc != chassis_loc || src != chassis.selected)
		return FALSE

/obj/item/mecha_equipment/proc/update_chassis_page()
	if(isnotnull(chassis))
		send_byjax(chassis.occupant, "exosuit.browser", "eq_list", chassis.get_equipment_list())
		send_byjax(chassis.occupant, "exosuit.browser", "equipment_menu", chassis.get_equipment_menu(), "dropdowns")
		return TRUE

/obj/item/mecha_equipment/proc/update_equip_info()
	if(isnotnull(chassis))
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())
		return TRUE

/obj/item/mecha_equipment/proc/critfail()
	if(isnotnull(chassis))
		log_message("Critical failure", 1)

/obj/item/mecha_equipment/proc/get_equip_info()
	. = "<span style='color:[equip_ready ? "#0f0" : "#f00"]'>*</span> "
	if(chassis.selected == src)
		. += "<b>[name]</b>"
	else if(selectable)
		. += "<a href='byond://?src=\ref[chassis];select_equip=\ref[src]'>[name]</a>"
	else
		. += "[name]"

/obj/item/mecha_equipment/proc/is_melee()
	return equip_range & MECHA_EQUIP_MELEE

/obj/item/mecha_equipment/proc/is_ranged() // Add a distance restricted equipment. Why not?
	return equip_range & MECHA_EQUIP_RANGED

/obj/item/mecha_equipment/proc/action_checks(atom/target)
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

/obj/item/mecha_equipment/proc/action(atom/target)
	SHOULD_CALL_PARENT(TRUE)

	if(!action_checks(target))
		return FALSE
	return TRUE

/obj/item/mecha_equipment/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("detach"))
		detach()

/obj/item/mecha_equipment/proc/set_ready_state(state)
	equip_ready = state
	if(isnotnull(chassis))
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())

/obj/item/mecha_equipment/proc/occupant_message(message)
	if(isnotnull(chassis))
		chassis.occupant_message("[icon2html(src, chassis.occupant)] [message]")

/obj/item/mecha_equipment/proc/log_message(message)
	if(isnotnull(chassis))
		chassis.log_message("<i>[src]:</i> [message]")