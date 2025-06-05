// Tesla Energy Relay
/obj/item/mecha_equipment/tesla_energy_relay
	name = "tesla energy relay"
	desc = "Wirelessly drains energy from any available power channel in area. The performance index is quite low. (Can be attached to: Any Exosuit)"
	icon_state = "tesla"
	matter_amounts = /datum/design/mechfab/equipment/general/energy_relay::materials
	origin_tech = /datum/design/mechfab/equipment/general/energy_relay::req_tech

	equip_cooldown = 1 SECOND

	selectable = FALSE

	var/coeff = 100
	var/energy_amount = 12
	var/list/use_channels = list(EQUIP, ENVIRON, LIGHT)

/obj/item/mecha_equipment/tesla_energy_relay/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/mecha_equipment/tesla_energy_relay/detach()
	GLOBL.processing_objects.Remove(src)
	. = ..()

/obj/item/mecha_equipment/tesla_energy_relay/proc/get_power_channel(area/A)
	. = null
	if(isnull(A))
		return
	for(var/channel in use_channels)
		if(A.powered(channel))
			. = channel
			break

/obj/item/mecha_equipment/tesla_energy_relay/Topic(href, href_list)
	. = ..()
	if(href_list["toggle_relay"])
		if(equip_ready)
			GLOBL.processing_objects.Add(src)
			log_message("Activated.")
			set_ready_state(FALSE)
		else
			log_message("Deactivated.")
			set_ready_state(TRUE)

/obj/item/mecha_equipment/tesla_energy_relay/get_equip_info()
	. = "[..()] - <a href='byond://?src=\ref[src];toggle_relay=1'>[equip_ready ? "A" : "Dea"]ctivate</a>"

/obj/item/mecha_equipment/tesla_energy_relay/process()
	if(..() == PROCESS_KILL || chassis.internal_damage & MECHA_INT_SHORT_CIRCUIT)
		return PROCESS_KILL

	var/cur_charge = chassis.get_charge()
	if(isnull(cur_charge) || isnull(chassis.cell))
		occupant_message("No power cell detected.")
		set_ready_state(TRUE)
		return PROCESS_KILL

	if(cur_charge < chassis.cell.maxcharge)
		var/area/current_area = GET_AREA(chassis)
		var/power_channel = get_power_channel(current_area)
		if(isnotnull(power_channel))
			var/delta = min(energy_amount, chassis.cell.maxcharge - cur_charge)
			chassis.give_power(delta)
			current_area.use_power(delta * coeff, power_channel)