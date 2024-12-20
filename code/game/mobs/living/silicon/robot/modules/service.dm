/*
 * Service Module
 */
/obj/item/robot_module/service
	name = "service robot module"

/obj/item/robot_module/service/New()
	. = ..()
	modules.Add(new /obj/item/reagent_holder/food/drinks/cans/beer(src))
	modules.Add(new /obj/item/reagent_holder/food/condiment/enzyme(src))
	modules.Add(new /obj/item/pen/robopen(src))

	var/obj/item/rsf/M = new /obj/item/rsf(src)
	M.matter = 30
	modules.Add(M)

	modules.Add(new /obj/item/reagent_holder/robodropper(src))

	var/obj/item/lighter/zippo/L = new /obj/item/lighter/zippo(src)
	L.lit = 1
	modules.Add(L)

	modules.Add(new /obj/item/tray/robotray(src))
	modules.Add(new /obj/item/reagent_holder/food/drinks/shaker(src))

	emag = new /obj/item/reagent_holder/food/drinks/cans/beer(src)
	emag.create_reagents(50)
	emag.reagents.add_reagent("beer2", 50)
	emag.name = "Mickey Finn's Special Brew"

/obj/item/robot_module/service/add_languages(mob/living/silicon/robot/R)
//full set of languages
	R.add_language("Sol Common")
	R.add_language("Sinta'unathi")
	R.add_language("Siik'maas")
	R.add_language("Siik'tajr", FALSE)
	R.add_language("Skrellian")
	R.add_language("Rootspeak", FALSE)
	R.add_language("Tradeband")
	R.add_language("Gutter")

/obj/item/robot_module/service/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/reagent_holder/food/condiment/enzyme/E = locate() in modules
	E.reagents.add_reagent("enzyme", 2)
	if(emag)
		var/obj/item/reagent_holder/food/drinks/cans/beer/B = emag
		B.reagents.add_reagent("beer2", 2)