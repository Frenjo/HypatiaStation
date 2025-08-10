/obj/item/mecha_equipment/weapon/ballistic
	name = "general ballistic weapon"

	var/projectile_energy_cost

/obj/item/mecha_equipment/weapon/ballistic/get_equip_info()
	. = "[..()] \[[projectiles]\][projectiles < initial(projectiles) ? " - <a href='byond://?src=\ref[src];rearm=1'>Rearm</a>" : null]"

/obj/item/mecha_equipment/weapon/ballistic/proc/rearm()
	if(projectiles < initial(projectiles))
		var/projectiles_to_add = initial(projectiles) - projectiles
		while(chassis.get_charge() >= projectile_energy_cost && projectiles_to_add)
			projectiles++
			projectiles_to_add--
			chassis.use_power(projectile_energy_cost)
	send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())
	log_message("Rearmed [name].")

/obj/item/mecha_equipment/weapon/ballistic/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("rearm"))
		rearm()