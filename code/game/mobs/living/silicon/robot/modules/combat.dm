/*
 * Combat Module
 */
/obj/item/robot_module/combat
	name = "combat robot module"

/obj/item/robot_module/combat/New()
	. = ..()
	modules.Add(new /obj/item/borg/sight/thermal(src))
	modules.Add(new /obj/item/gun/energy/laser/cyborg(src))
	modules.Add(new /obj/item/pickaxe/plasmacutter(src))
	modules.Add(new /obj/item/borg/combat/shield(src))
	modules.Add(new /obj/item/borg/combat/mobility(src))
	modules.Add(new /obj/item/wrench(src)) // Is a combat android really going to be stopped by a chair?
	emag = new /obj/item/gun/energy/lasercannon/cyborg(src)