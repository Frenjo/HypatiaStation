/*
 * Janitor Module
 */
/obj/item/robot_module/janitor
	name = "janitorial robot module"

/obj/item/robot_module/janitor/New()
	. = ..()
	modules.Add(new /obj/item/soap/nanotrasen(src))
	modules.Add(new /obj/item/storage/bag/trash(src))
	modules.Add(new /obj/item/mop(src))
	modules.Add(new /obj/item/lightreplacer(src))

	emag = new /obj/item/reagent_holder/spray(src)
	emag.reagents.add_reagent("lube", 250)
	emag.name = "Lube spray"

/obj/item/robot_module/janitor/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/lightreplacer/LR = locate() in modules
	LR.Charge(R)
	if(emag)
		var/obj/item/reagent_holder/spray/S = emag
		S.reagents.add_reagent("lube", 2)