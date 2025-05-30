/decl/hierarchy/supply_pack/operations
	name = "Operations"


/decl/hierarchy/supply_pack/operations/mule
	name = "MULEbot Crate"
	contains = list(/obj/machinery/bot/mulebot)
	cost = 20
	containertype = /obj/structure/largecrate/mule
	containername = "MULEbot crate"


// Ported hoverpod from NSS Eternal. -Frenjo
/decl/hierarchy/supply_pack/operations/hoverpod
	name = "Hoverpod Shipment"
	contains = list()
	cost = 80
	containertype = /obj/structure/largecrate/hoverpod
	containername = "hoverpod crate"


/decl/hierarchy/supply_pack/operations/artscrafts
	name = "Arts and Crafts supplies"
	contains = list(
		/obj/item/storage/fancy/crayons,
		/obj/item/camera,
		/obj/item/camera_film,
		/obj/item/camera_film,
		/obj/item/storage/photo_album,
		/obj/item/package_wrap,
		/obj/item/reagent_holder/glass/paint/red,
		/obj/item/reagent_holder/glass/paint/green,
		/obj/item/reagent_holder/glass/paint/blue,
		/obj/item/reagent_holder/glass/paint/yellow,
		/obj/item/reagent_holder/glass/paint/violet,
		/obj/item/reagent_holder/glass/paint/black,
		/obj/item/reagent_holder/glass/paint/white,
		/obj/item/reagent_holder/glass/paint/remover,
		/obj/item/contraband/poster,
		/obj/item/wrapping_paper,
		/obj/item/wrapping_paper,
		/obj/item/wrapping_paper
	)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "arts and crafts crate"


/decl/hierarchy/supply_pack/operations/contraband
	name = "Contraband crate"
	contains = list(
		/obj/item/seeds/tomato/blood,
		/obj/item/storage/pill_bottle/zoom,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/reagent_holder/food/drinks/bottle/pwine
	)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "unlabeled crate"
	contraband = TRUE
	num_contained = 5
	supply_method = /decl/supply_method/randomised