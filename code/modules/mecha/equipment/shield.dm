/obj/item/mecha_part/equipment/linear_shield_droid
	name = "linear shield droid"
	desc = "A shield droid that forms a rectangular, unidirectionally projectile-blocking wall in front of the exosuit. (Can be attached to: Any Exosuit)"
	icon_state = "shield_droid"
	origin_tech = list(/datum/tech/magnets = 6, /datum/tech/plasma = 3, /datum/tech/syndicate = 4)
	construction_cost = list(
		MATERIAL_METAL = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 3
	)
	equip_cooldown = 10
	energy_drain = 100
	range = 0

	allow_duplicates = FALSE

	var/obj/item/shield_projector/line/exosuit/my_shield = null
	var/my_shield_type = /obj/item/shield_projector/line/exosuit
	var/icon/drone_overlay

/obj/item/mecha_part/equipment/linear_shield_droid/New()
	. = ..()
	my_shield = new my_shield_type
	my_shield.shield_regen_delay = equip_cooldown
	my_shield.my_tool = src

/obj/item/mecha_part/equipment/linear_shield_droid/critfail()
	. = ..()
	my_shield.adjust_health(-200)

/obj/item/mecha_part/equipment/linear_shield_droid/Destroy()
	chassis.overlays.Remove(drone_overlay)
	my_shield.forceMove(src)
	my_shield.destroy_shields()
	my_shield.my_tool = null
	my_shield.my_mecha = null
	QDEL_NULL(my_shield)
	return ..()

/obj/item/mecha_part/equipment/linear_shield_droid/attach(obj/mecha/M)
	. = ..()
	if(isnotnull(chassis))
		my_shield.shield_health = my_shield.shield_health / 2
		my_shield.my_mecha = chassis
		my_shield.forceMove(chassis)

		drone_overlay = new /icon(icon, icon_state = "shield_droid_idle")
		M.overlays.Add(drone_overlay)

/obj/item/mecha_part/equipment/linear_shield_droid/detach()
	chassis.overlays.Remove(drone_overlay)
	. = ..()
	my_shield.destroy_shields()
	my_shield.my_mecha = null
	my_shield.shield_health = my_shield.max_shield_health
	my_shield.forceMove(src)

/obj/item/mecha_part/equipment/linear_shield_droid/handle_movement_action()
	if(isnotnull(chassis))
		my_shield.update_shield_positions()

/obj/item/mecha_part/equipment/linear_shield_droid/proc/toggle_shield()
	if(isnotnull(chassis))
		my_shield.attack_self(chassis.occupant)
		if(my_shield.active)
			set_ready_state(0)
			log_message("Activated.")
		else
			set_ready_state(1)
			log_message("Deactivated.")

/obj/item/mecha_part/equipment/linear_shield_droid/Topic(href, href_list)
	. = ..()
	if(href_list["toggle_shield"])
		toggle_shield()
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())

/obj/item/mecha_part/equipment/linear_shield_droid/get_equip_info()
	. = "<span style=\"color:[equip_ready ? "#0f0" : "#f00"];\">*</span>&nbsp;[name] - <a href='?src=\ref[src];toggle_shield=1'>[my_shield.active ? "Dea" : "A"]ctivate</a>"