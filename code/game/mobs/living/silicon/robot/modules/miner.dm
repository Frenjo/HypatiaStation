/*
 * Mining Module
 */
/obj/item/robot_module/miner
	name = "miner robot module"

/obj/item/robot_module/miner/New()
	. = ..()
	modules.Add(new /obj/item/borg/sight/meson(src))
	emag = new /obj/item/borg/stun(src)
	modules.Add(new /obj/item/storage/bag/ore(src))
	modules.Add(new /obj/item/pickaxe/borgdrill(src))
	modules.Add(new /obj/item/storage/bag/sheetsnatcher/borg(src))
//	modules.Add(new /obj/item/shovel(src) Uneeded due to buffed drill