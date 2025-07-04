/*
 * Service Model
 */
/obj/item/robot_model/service
	name = "service robot model"
	display_name = "Service"

	basic_modules = list(
		/obj/item/flash,
		/obj/item/fire_extinguisher/mini,
		/obj/item/reagent_holder/food/drinks/cans/beer,
		/obj/item/reagent_holder/food/condiment/enzyme,
		/obj/item/pen/cyborg,
		/obj/item/reagent_holder/robodropper,
		/obj/item/tray/robotray,
		/obj/item/reagent_holder/food/drinks/shaker
	)
	emag_modules = list(/obj/item/reagent_holder/food/drinks/cans/beer/special_brew)

	channels = list(CHANNEL_SERVICE)

	sprite_path = 'icons/mob/silicon/robot/service.dmi'
	sprites = list(
		"Default" = "service2",
		"Waitress" = "service",
		"Kent" = "toiletbot",
		"Bro" = "brobot",
		"Rich" = "maximillion",
		"Hydrobot" = "hydrobot",
		"Hatchet Gear Rex" = "hatchetgearrex"
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

/obj/item/robot_model/service/add_languages(mob/living/silicon/robot/robby)
	. = ..()
	// Full set of languages.
	robby.add_language("Sol Common")
	robby.add_language("Sinta'unathi")
	robby.add_language("Siik'maas")
	robby.add_language("Siik'tajr", FALSE)
	robby.add_language("Skrellian")
	robby.add_language("Rootspeak", FALSE)
	robby.add_language("Obsedaian")
	robby.add_language("Plasmalin")
	robby.add_language("Tradeband")
	robby.add_language("Gutter")

/obj/item/robot_model/service/respawn_consumable(mob/living/silicon/robot/robby)
	. = ..()
	var/obj/item/reagent_holder/food/condiment/enzyme/enzyme_container = locate() in modules
	enzyme_container?.reagents.add_reagent("enzyme", 2)
	if(robby.emagged)
		var/obj/item/reagent_holder/food/drinks/cans/beer/special_brew/special = locate() in modules
		special.reagents.add_reagent("beer2", 2)