/decl/hierarchy/supply_pack/supply
	name = "Supply"


/decl/hierarchy/supply_pack/supply/food
	name = "Kitchen supply crate"
	contains = list(
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/snacks/flour,
		/obj/item/reagent_holder/food/drinks/milk,
		/obj/item/reagent_holder/food/drinks/milk,
		/obj/item/storage/fancy/egg_box,
		/obj/item/reagent_holder/food/snacks/tofu,
		/obj/item/reagent_holder/food/snacks/tofu,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/meat,
		/obj/item/reagent_holder/food/snacks/grown/banana,
		/obj/item/reagent_holder/food/snacks/grown/banana
	)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "Food crate"


/decl/hierarchy/supply_pack/supply/toner
	name = "Toner cartridges"
	contains = list(
		/obj/item/toner,
		/obj/item/toner,
		/obj/item/toner,
		/obj/item/toner,
		/obj/item/toner,
		/obj/item/toner
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Toner cartridges"


/decl/hierarchy/supply_pack/supply/janitor
	name = "Janitorial supplies"
	contains = list(
		/obj/item/reagent_holder/glass/bucket,
		/obj/item/reagent_holder/glass/bucket,
		/obj/item/reagent_holder/glass/bucket,
		/obj/item/mop,
		/obj/item/caution,
		/obj/item/caution,
		/obj/item/caution,
		/obj/item/storage/bag/trash,
		/obj/item/reagent_holder/spray/cleaner,
		/obj/item/reagent_holder/glass/rag,
		/obj/item/grenade/chemical/cleaner,
		/obj/item/grenade/chemical/cleaner,
		/obj/item/grenade/chemical/cleaner,
		/obj/structure/mopbucket
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Janitorial supplies"


/decl/hierarchy/supply_pack/supply/boxes
	name = "Empty boxes"
	contains = list(
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Empty box crate"