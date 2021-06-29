/decl/hierarchy/supply_pack/hospitality
	name = "Hospitality"
	hierarchy_type = /decl/hierarchy/supply_pack/hospitality


/decl/hierarchy/supply_pack/hospitality/party
	name = "Party equipment"
	contains = list(
		/obj/item/weapon/storage/box/drinkingglasses,
		/obj/item/weapon/reagent_containers/food/drinks/shaker,
		/obj/item/weapon/reagent_containers/food/drinks/flask/barflask,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/patron,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager,
		/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
		/obj/item/weapon/lipstick/random,
		/obj/item/weapon/reagent_containers/food/drinks/cans/ale,
		/obj/item/weapon/reagent_containers/food/drinks/cans/ale,
		/obj/item/weapon/reagent_containers/food/drinks/cans/beer,
		/obj/item/weapon/reagent_containers/food/drinks/cans/beer,
		/obj/item/weapon/reagent_containers/food/drinks/cans/beer,
		/obj/item/weapon/reagent_containers/food/drinks/cans/beer
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Party equipment"


/decl/hierarchy/supply_pack/hospitality/pizza
	num_contained = 5
	contains = list(
		/obj/item/pizzabox/margherita,
		/obj/item/pizzabox/mushroom,
		/obj/item/pizzabox/meat,
		/obj/item/pizzabox/vegetable
	)
	name = "Surprise pack of five pizzas"
	cost = 15
	containertype = /obj/structure/closet/crate/freezer
	containername = "Pizza crate"
	supply_method = /decl/supply_method/randomised