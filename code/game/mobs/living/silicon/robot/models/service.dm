/*
 * Service Model
 */
/obj/item/robot_model/service
	name = "service robot model"
	display_name = "Service"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/extinguisher/mini,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/condiment/enzyme,
		/obj/item/pen/robopen,
		/obj/item/reagent_holder/robodropper,
		/obj/item/tray/robotray,
		/obj/item/reagent_holder/food/drinks/shaker
	)
	emag_type = /obj/item/reagent_holder/food/drinks/cans/beer/special_brew

	channels = list(CHANNEL_SERVICE)

	sprite_path = 'icons/mob/silicon/robot/service.dmi'
	sprites = list(
		"Default" = "service2",
		"Waitress" = "service",
		"Kent" = "toiletbot",
		"Bro" = "brobot",
		"Rich" = "maximillion",
		"Hydrobot" = "hydrobot"
	)
	model_select_sprite = "service2"

/obj/item/robot_model/service/New()
	. = ..()
	var/obj/item/rsf/M = new /obj/item/rsf(src)
	M.matter = 30
	modules.Add(M)

	var/obj/item/lighter/zippo/L = new /obj/item/lighter/zippo(src)
	L.lit = 1
	modules.Add(L)

/obj/item/robot_model/service/add_languages(mob/living/silicon/robot/R)
	. = ..()
	// Full set of languages.
	R.add_language("Sol Common")
	R.add_language("Sinta'unathi")
	R.add_language("Siik'maas")
	R.add_language("Siik'tajr", FALSE)
	R.add_language("Skrellian")
	R.add_language("Rootspeak", FALSE)
	R.add_language("Tradeband")
	R.add_language("Gutter")

/obj/item/robot_model/service/respawn_consumable(mob/living/silicon/robot/R)
	var/obj/item/reagent_holder/food/condiment/enzyme/E = locate() in modules
	E.reagents.add_reagent("enzyme", 2)
	if(emag)
		var/obj/item/reagent_holder/food/drinks/cans/beer/special_brew/special = emag
		special.reagents.add_reagent("beer2", 2)