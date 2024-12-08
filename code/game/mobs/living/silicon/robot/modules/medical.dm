/*
 * Medical Module
 */
/obj/item/robot_module/medical
	name = "medical robot module"

/obj/item/robot_module/medical/New()
	. = ..()
	modules.Add(new /obj/item/borg/sight/hud/med(src))
	modules.Add(new /obj/item/health_analyser(src))
	modules.Add(new /obj/item/reagent_scanner/adv(src))
	modules.Add(new /obj/item/reagent_holder/borghypo(src))
	modules.Add(new /obj/item/reagent_holder/glass/beaker/large(src))
	modules.Add(new /obj/item/reagent_holder/robodropper(src))
	modules.Add(new /obj/item/reagent_holder/syringe(src))
	modules.Add(new /obj/item/extinguisher/mini(src))

	emag = new /obj/item/reagent_holder/spray(src)
	emag.reagents.add_reagent("pacid", 250)
	emag.name = "Polyacid spray"

/obj/item/robot_module/medical/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/reagent_holder/syringe/S = locate() in modules
	if(S.mode == 2)//SYRINGE_BROKEN
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(emag)
		var/obj/item/reagent_holder/spray/PS = emag
		PS.reagents.add_reagent("pacid", 2)