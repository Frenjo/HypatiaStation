/*
 * Standard Module
 */
/obj/item/robot_module/standard
	name = "standard robot module"

/obj/item/robot_module/standard/New()
	. = ..()
	//modules.Add(new /obj/item/melee/baton(src))
	modules.Add(new /obj/item/melee/baton/loaded(src))
	modules.Add(new /obj/item/extinguisher(src))
	modules.Add(new /obj/item/wrench(src))
	modules.Add(new /obj/item/crowbar(src))
	modules.Add(new /obj/item/health_analyser(src))
	emag = new /obj/item/melee/energy/sword(src)

///obj/item/robot_module/standard/respawn_consumable(mob/living/silicon/robot/R)
	//var/obj/item/melee/baton/B = locate() in modules
	//if(B.charges < 10)
	//	B.charges += 1