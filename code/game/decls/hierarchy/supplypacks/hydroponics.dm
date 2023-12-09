/decl/hierarchy/supply_pack/hydroponics
	name = "Hydroponics"


/decl/hierarchy/supply_pack/hydroponics/monkey
	name = "Monkey crate"
	contains = list(/obj/item/storage/box/monkeycubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Monkey crate"


/decl/hierarchy/supply_pack/hydroponics/farwa
	name = "Farwa crate"
	contains = list(/obj/item/storage/box/monkeycubes/farwacubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "Farwa crate"


/decl/hierarchy/supply_pack/hydroponics/skrell
	name = "Neaera crate"
	contains = list(/obj/item/storage/box/monkeycubes/neaeracubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "Neaera crate"


/decl/hierarchy/supply_pack/hydroponics/stok
	name = "Stok crate"
	contains = list(/obj/item/storage/box/monkeycubes/stokcubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "Stok crate"


/decl/hierarchy/supply_pack/hydroponics/lisa
	name = "Corgi Crate"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/lisa
	containername = "Corgi Crate"


/decl/hierarchy/supply_pack/hydroponics/hydroponics // -- Skie
	name = "Hydroponics Supply Crate"
	contains = list(
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/reagent_containers/glass/bottle/ammonia,
		/obj/item/reagent_containers/glass/bottle/ammonia,
		/obj/item/hatchet,
		/obj/item/minihoe,
		/obj/item/analyzer/plant_analyzer,
		/obj/item/clothing/gloves/botanic_leather,
		/obj/item/clothing/suit/apron
	) // Updated with new things
	cost = 15
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Hydroponics crate"
	access = ACCESS_HYDROPONICS


//farm animals - useless and annoying, but potentially a good source of food
/decl/hierarchy/supply_pack/hydroponics/cow
	name = "Cow crate"
	cost = 30
	containertype = /obj/structure/largecrate/cow
	containername = "Cow crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/goat
	name = "Goat crate"
	cost = 25
	containertype = /obj/structure/largecrate/goat
	containername = "Goat crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/chicken
	name = "Chicken crate"
	cost = 20
	containertype = /obj/structure/largecrate/chick
	containername = "Chicken crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/seeds
	name = "Seeds crate"
	contains = list(
		/obj/item/seeds/chiliseed,
		/obj/item/seeds/berryseed,
		/obj/item/seeds/cornseed,
		/obj/item/seeds/eggplantseed,
		/obj/item/seeds/tomatoseed,
		/obj/item/seeds/appleseed,
		/obj/item/seeds/soyaseed,
		/obj/item/seeds/wheatseed,
		/obj/item/seeds/carrotseed,
		/obj/item/seeds/harebell,
		/obj/item/seeds/lemonseed,
		/obj/item/seeds/orangeseed,
		/obj/item/seeds/grassseed,
		/obj/item/seeds/sunflowerseed,
		/obj/item/seeds/chantermycelium,
		/obj/item/seeds/potatoseed,
		/obj/item/seeds/sugarcaneseed
	)
	cost = 10
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Seeds crate"
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
	containertype = /obj/structure/closet/crate/secure/hydrosec
	containername = "Weed control crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/exoticseeds
	name = "Exotic seeds crate"
	contains = list(
		/obj/item/seeds/nettleseed,
		/obj/item/seeds/replicapod,
		/obj/item/seeds/replicapod,
		/obj/item/seeds/replicapod,
		/obj/item/seeds/plumpmycelium,
		/obj/item/seeds/libertymycelium,
		/obj/item/seeds/amanitamycelium,
		/obj/item/seeds/reishimycelium,
		/obj/item/seeds/bananaseed,
		/obj/item/seeds/riceseed,
		/obj/item/seeds/eggplantseed,
		/obj/item/seeds/limeseed,
		/obj/item/seeds/grapeseed,
		/obj/item/seeds/eggyseed
	)
	cost = 15
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Exotic Seeds crate"
	access = ACCESS_HYDROPONICS


/decl/hierarchy/supply_pack/hydroponics/watertank
	name = "Water tank crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
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
	containername = "Beekeeping crate"
	access = ACCESS_HYDROPONICS