/obj/machinery/seed_extractor
	name = "seed extractor"
	desc = "Extracts and bags seeds from produce."
	icon = 'icons/obj/flora/hydroponics.dmi'
	icon_state = "sextractor"
	density = TRUE
	anchored = TRUE

/obj/machinery/seed_extractor/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food/snacks/grown))
		var/obj/item/reagent_containers/food/snacks/grown/F = O
		user.drop_item()
		to_chat(user, SPAN_NOTICE("You extract some seeds from the [F.name]."))
		var/seed = F.seed
		var/t_amount = 0
		var/t_max = rand(1, 4)
		while(t_amount < t_max)
			var/obj/item/seeds/t_prod = new seed(loc)
			t_prod.species = F.species
			t_prod.lifespan = F.lifespan
			t_prod.endurance = F.endurance
			t_prod.maturation = F.maturation
			t_prod.production = F.production
			t_prod.yield = F.yield
			t_prod.potency = F.potency
			t_amount++
		qdel(O)

	else if(istype(O, /obj/item/grown))
		var/obj/item/grown/F = O
		user.drop_item()
		to_chat(user, SPAN_NOTICE("You extract some seeds from the [F.name]."))
		var/seed = F.seed
		var/t_amount = 0
		var/t_max = rand(1, 4)
		while(t_amount < t_max)
			var/obj/item/seeds/t_prod = new seed(loc)
			t_prod.species = F.species
			t_prod.lifespan = F.lifespan
			t_prod.endurance = F.endurance
			t_prod.maturation = F.maturation
			t_prod.production = F.production
			t_prod.yield = F.yield
			t_prod.potency = F.potency
			t_amount++
		qdel(O)

	else if(istype(O, /obj/item/stack/tile/grass))
		var/obj/item/stack/tile/grass/S = O
		to_chat(user, SPAN_NOTICE("You extract some seeds from the [S.name]."))
		S.use(1)
		new /obj/item/seeds/grass(loc)

	return