/obj/item/mecha_part/equipment/shield_droid
	name = "shield droid"
	icon_state = "shield_droid"

	equip_cooldown = 1 SECOND
	energy_drain = 50
	range = 0

	allow_duplicates = FALSE

	var/obj/item/shield_projector/shield = null
	var/shield_type
	var/icon/drone_overlay

/obj/item/mecha_part/equipment/shield_droid/New()
	. = ..()
	shield = new shield_type(src)
	shield.shield_regen_delay = equip_cooldown
	shield:my_tool = src

/obj/item/mecha_part/equipment/shield_droid/critfail()
	. = ..()
	shield.adjust_health(-200)

/obj/item/mecha_part/equipment/shield_droid/Destroy()
	chassis.overlays.Remove(drone_overlay)
	shield.forceMove(src)
	shield.destroy_shields()
	shield:my_tool = null
	shield:my_mecha = null
	QDEL_NULL(shield)
	return ..()

/obj/item/mecha_part/equipment/shield_droid/attach(obj/mecha/M)
	. = ..()
	if(isnotnull(chassis))
		shield.shield_health = shield.shield_health / 2
		shield:my_mecha = chassis
		shield.forceMove(chassis)

		drone_overlay = new /icon(icon, icon_state = "shield_droid_idle")
		M.overlays.Add(drone_overlay)

/obj/item/mecha_part/equipment/shield_droid/detach()
	chassis.overlays.Remove(drone_overlay)
	. = ..()
	shield.destroy_shields()
	shield:my_mecha = null
	shield.shield_health = shield.max_shield_health
	shield.forceMove(src)

/obj/item/mecha_part/equipment/shield_droid/handle_movement_action()
	if(isnotnull(chassis))
		shield.update_shield_positions()

/obj/item/mecha_part/equipment/shield_droid/proc/toggle_shield()
	if(isnull(chassis))
		return
	shield.attack_self(chassis.occupant)
	if(shield.active)
		set_ready_state(0)
		log_message("Activated.")
	else
		set_ready_state(1)
		log_message("Deactivated.")

/obj/item/mecha_part/equipment/shield_droid/Topic(href, href_list)
	. = ..()
	if(href_list["toggle_shield"])
		toggle_shield()
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())

/obj/item/mecha_part/equipment/shield_droid/get_equip_info()
	. = "<span style=\"color:[equip_ready ? "#0f0" : "#f00"];\">*</span>&nbsp;[name] - <a href='?src=\ref[src];toggle_shield=1'>[shield.active ? "Dea" : "A"]ctivate</a>"

// Linear
/obj/item/mecha_part/equipment/shield_droid/linear
	name = "linear shield droid"
	desc = "A shield droid that forms a rectangular, unidirectionally projectile-blocking wall in front of the exosuit. (Can be attached to: Any Exosuit)"
	origin_tech = list(/datum/tech/magnets = 6, /datum/tech/plasma = 3, /datum/tech/syndicate = 4)

	shield_type = /obj/item/shield_projector/line/exosuit

// Omnidirectional
/obj/item/mecha_part/equipment/shield_droid/omnidirectional
	name = "omnidirectional shield droid"
	desc = "A shield droid that forms a rectangular, unidirectionally projectile-blocking wall around the exosuit. (Can be attached to: Any Exosuit)"
	origin_tech = list(/datum/tech/magnets = 6, /datum/tech/plasma = 6, /datum/tech/syndicate = 6)

	shield_type = /obj/item/shield_projector/rectangle/weak/exosuit