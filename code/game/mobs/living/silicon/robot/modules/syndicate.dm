/*
 * Syndicate Module
 */
/obj/item/robot_module/syndicate
	name = "syndicate robot module"

/obj/item/robot_module/syndicate/New()
	. = ..()
	modules.Add(new /obj/item/melee/energy/sword(src))
	modules.Add(new /obj/item/gun/energy/pulse_rifle/destroyer(src))
	modules.Add(new /obj/item/card/emag(src))