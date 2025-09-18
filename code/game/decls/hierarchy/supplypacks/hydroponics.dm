/decl/hierarchy/supply_pack/hydroponics
	name = "Hydroponics"


/decl/hierarchy/supply_pack/hydroponics/monkey
	name = "Monkey crate"
	contains = list(/obj/item/storage/box/monkeycubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "monkey crate"


/decl/hierarchy/supply_pack/hydroponics/farwa
	name = "Farwa crate"
	contains = list(/obj/item/storage/box/monkeycubes/farwacubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "farwa crate"


/decl/hierarchy/supply_pack/hydroponics/skrell
	name = "Neaera crate"
	contains = list(/obj/item/storage/box/monkeycubes/neaeracubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "neaera crate"


/decl/hierarchy/supply_pack/hydroponics/stok
	name = "Stok crate"
	contains = list(/obj/item/storage/box/monkeycubes/stokcubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "stok crate"


/decl/hierarchy/supply_pack/hydroponics/lisa
	name = "Corgi Crate"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/lisa
	containername = "corgi crate"


/decl/hierarchy/supply_pack/hydroponics/hydroponics // -- Skie
	name = "Hydroponics Supply Crate"
	contains = list(
		/obj/item/reagent_holder/spray/plantbgone,
		/obj/item/reagent_holder/spray/plantbgone,
		/obj/item/reagent_holder/glass/bottle/ammonia,
		/obj/item/reagent_holder/glass/bottle/ammonia,
		/obj/item/hatchet,
		/obj/item/minihoe,
		/obj/item/plant_analyser,
		/obj/item/clothing/gloves/botanic_leather,
		/obj/item/clothing/suit/apron
	) // Updated with new things
	cost = 15
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "hydroponics crate"
	access = ACCESS_HYDROPONICS


//farm animals - useless and annoying, but potentially a good source of food
/decl/hierarchy/supply_pack/hydroponics/cow
	name = "Cow crate"
	cost = 30
	containertype = /obj/structure/largecrate/cow
	containername = "cow crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/goat
	name = "Goat crate"
	cost = 25
	containertype = /obj/structure/largecrate/goat
	containername = "goat crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/chicken
	name = "Chicken crate"
	cost = 20
	containertype = /obj/structure/largecrate/chick
	containername = "chicken crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/seeds
	name = "Seeds crate"
	contains = list(
		/obj/item/seeds/chili,
		/obj/item/seeds/berry,
		/obj/item/seeds/corn,
		/obj/item/seeds/eggplant,
		/obj/item/seeds/tomato,
		/obj/item/seeds/apple,
		/obj/item/seeds/soya,
		/obj/item/seeds/wheat,
		/obj/item/seeds/carrot,
		/obj/item/seeds/harebell,
		/obj/item/seeds/lemon,
		/obj/item/seeds/orange,
		/obj/item/seeds/grass,
		/obj/item/seeds/sunflower,
		/obj/item/seeds/chanterelle,
		/obj/item/seeds/potato,
		/obj/item/seeds/sugarcaneseed
	)
	cost = 10
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "seeds crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/weedcontrol
	name = "Weed control crate"
	contains = list(
		/obj/item/scythe,
		/obj/item/clothing/mask/gas,
		/obj/item/grenade/chemical/antiweed,
		/obj/item/grenade/chemical/antiweed
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/hydroponics
	containername = "weed control crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/exoticseeds
	name = "Exotic seeds crate"
	contains = list(
		/obj/item/seeds/nettle,
		/obj/item/seeds/replicapod,
		/obj/item/seeds/replicapod,
		/obj/item/seeds/replicapod,
		/obj/item/seeds/plumphelmet,
		/obj/item/seeds/libertycap,
		/obj/item/seeds/amanita,
		/obj/item/seeds/reishi,
		/obj/item/seeds/banana,
		/obj/item/seeds/rice,
		/obj/item/seeds/eggplant,
		/obj/item/seeds/lime,
		/obj/item/seeds/grape,
		/obj/item/seeds/eggy
	)
	cost = 15
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "exotic seeds crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/watertank
	name = "Water tank crate"
	contains = list(/obj/structure/reagent_dispenser/watertank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "water tank crate"


/decl/hierarchy/supply_pack/hydroponics/bee_keeper
	name = "Beekeeping crate"
	contains = list(
		/obj/item/beezeez,
		/obj/item/beezeez,
		/obj/item/bee_net,
		/obj/item/apiary,
		/obj/item/queen_bee,
		/obj/item/queen_bee,
		/obj/item/queen_bee
	)
	cost = 20
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "beekeeping crate"
	access = ACCESS_HYDROPONICS