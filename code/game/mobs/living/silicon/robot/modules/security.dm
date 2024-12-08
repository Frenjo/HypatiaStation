/*
 * Security Module
 */
/obj/item/robot_module/security
	name = "security robot module"

/obj/item/robot_module/security/New()
	. = ..()
	modules.Add(new /obj/item/borg/sight/hud/sec(src))
	modules.Add(new /obj/item/handcuffs/cyborg(src))
	//modules.Add(new /obj/item/melee/baton(src))
	modules.Add(new /obj/item/melee/baton/loaded(src))
	modules.Add(new /obj/item/gun/energy/taser/cyborg(src))
	modules.Add(new /obj/item/taperoll/police(src))
	emag = new /obj/item/gun/energy/laser/cyborg(src)

/obj/item/robot_module/security/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/flash/F = locate() in modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/gun/energy/taser/cyborg/T = locate() in modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost)
		T.update_icon()
	else
		T.charge_tick = 0
	//var/obj/item/melee/baton/B = locate() in modules
	//if(B.charges < 10)
	//	B.charges += 1