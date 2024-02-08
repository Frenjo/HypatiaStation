/*
 * Reishi
 */
/obj/item/reagent_containers/food/snacks/grown/mushroom/reishi
	seed = /obj/item/seeds/reishimycelium
	name = "reishi"
	desc = "<I>Ganoderma lucidum</I>: A special fungus believed to help relieve stress."
	icon_state = "reishi"
	potency = 10
	filling_color = "#FF4800"

/obj/item/reagent_containers/food/snacks/grown/mushroom/reishi/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1)
	reagents.add_reagent("stoxin", 3 + round(potency / 3, 1))
	reagents.add_reagent("space_drugs", 1 + round(potency / 25, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/mushroom/reishi/attackby(obj/item/O as obj, mob/user as mob)
	. = ..()
	if(istype(O, /obj/item/plant_analyser))
		to_chat(user, SPAN_INFO("- Sleep Toxin: <i>[reagents.get_reagent_amount("stoxin")]%</i>"))
		to_chat(user, SPAN_INFO("- Space Drugs: <i>[reagents.get_reagent_amount("space_drugs")]%</i>"))

/*
 * Fly Amanita
 */
/obj/item/reagent_containers/food/snacks/grown/mushroom/amanita
	seed = /obj/item/seeds/amanitamycelium
	name = "fly amanita"
	desc = "<I>Amanita Muscaria</I>: Learn poisonous mushrooms by heart. Only pick mushrooms you know."
	icon_state = "amanita"
	potency = 10
	filling_color = "#FF0000"

/obj/item/reagent_containers/food/snacks/grown/mushroom/amanita/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1)
	reagents.add_reagent("amatoxin", 3 + round(potency / 3, 1))
	reagents.add_reagent("psilocybin", 1 + round(potency / 25, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/mushroom/amanita/attackby(obj/item/O as obj, mob/user as mob)
	. = ..()
	if(istype(O, /obj/item/plant_analyser))
		to_chat(user, SPAN_INFO("- Amatoxins: <i>[reagents.get_reagent_amount("amatoxin")]%</i>"))
		to_chat(user, SPAN_INFO("- Psilocybin: <i>[reagents.get_reagent_amount("psilocybin")]%</i>"))

/*
 * Destroying Angel
 */
/obj/item/reagent_containers/food/snacks/grown/mushroom/angel
	seed = /obj/item/seeds/angelmycelium
	name = "destroying angel"
	desc = "<I>Amanita Virosa</I>: Deadly poisonous basidiomycete fungus filled with alpha amatoxins."
	icon_state = "angel"
	potency = 35
	filling_color = "#FFDEDE"

/obj/item/reagent_containers/food/snacks/grown/mushroom/angel/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 50), 1))
	reagents.add_reagent("amatoxin", 13 + round(potency / 3, 1))
	reagents.add_reagent("psilocybin", 1 + round(potency / 25, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/mushroom/angel/attackby(obj/item/O as obj, mob/user as mob)
	. = ..()
	if(istype(O, /obj/item/plant_analyser))
		to_chat(user, SPAN_INFO("- Amatoxins: <i>[reagents.get_reagent_amount("amatoxin")]%</i>"))
		to_chat(user, SPAN_INFO("- Psilocybin: <i>[reagents.get_reagent_amount("psilocybin")]%</i>"))

/*
 * Liberty Cap
 */
/obj/item/reagent_containers/food/snacks/grown/mushroom/libertycap
	seed = /obj/item/seeds/libertymycelium
	name = "liberty-cap"
	desc = "<I>Psilocybe Semilanceata</I>: Liberate yourself!"
	icon_state = "libertycap"
	potency = 15
	filling_color = "#F714BE"

/obj/item/reagent_containers/food/snacks/grown/mushroom/libertycap/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 50), 1))
	reagents.add_reagent("psilocybin", 3 + round(potency / 5, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/mushroom/libertycap/attackby(obj/item/O as obj, mob/user as mob)
	. = ..()
	if(istype(O, /obj/item/plant_analyser))
		to_chat(user, SPAN_INFO("- Psilocybin: <i>[reagents.get_reagent_amount("psilocybin")]%</i>"))
		to_chat(user, SPAN_INFO("- Mineral Content: <i>[reagents.get_reagent_amount("gold")]%</i>"))

/*
 * Chanterelle
 */
/obj/item/reagent_containers/food/snacks/grown/mushroom/chanterelle
	seed = /obj/item/seeds/chantermycelium
	name = "chanterelle cluster"
	desc = "<I>Cantharellus Cibarius</I>: These jolly yellow little shrooms sure look tasty!"
	icon_state = "chanterelle"
	filling_color = "#FFE991"

/obj/item/reagent_containers/food/snacks/grown/mushroom/chanterelle/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 25), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Glowshroom
 */
/obj/item/reagent_containers/food/snacks/grown/mushroom/glowshroom
	seed = /obj/item/seeds/glowshroom
	name = "glowshroom cluster"
	desc = "<I>Mycena Bregprox</I>: This species of mushroom glows in the dark. Or does it?"
	icon_state = "glowshroom"
	filling_color = "#DAFF91"

	lifespan = 120 //ten times that is the delay
	endurance = 30
	maturation = 15
	production = 1
	yield = 3
	potency = 30
	plant_type = 2

/obj/item/reagent_containers/food/snacks/grown/mushroom/glowshroom/initialize()
	. = ..()
	reagents.add_reagent("radium", 1 + round((potency / 20), 1))
	if(ismob(src.loc))
		pickup(src.loc)
	else
		src.set_light(round(potency / 10, 1))

/obj/item/reagent_containers/food/snacks/grown/mushroom/glowshroom/attack_self(mob/user as mob)
	if(isspace(user.loc))
		return

	var/obj/effect/glowshroom/planted = new /obj/effect/glowshroom(user.loc)

	planted.delay = lifespan * 50
	planted.endurance = endurance
	planted.yield = yield
	planted.potency = potency
	qdel(src)

	to_chat(user, SPAN_NOTICE("You plant the glowshroom."))

/obj/item/reagent_containers/food/snacks/grown/mushroom/glowshroom/Destroy()
	if(ismob(loc))
		loc.set_light(round(loc.luminosity - potency / 10, 1))
	return ..()

/obj/item/reagent_containers/food/snacks/grown/mushroom/glowshroom/pickup(mob/user)
	set_light(0)
	user.set_light(round(user.luminosity + (potency / 10), 1))

/obj/item/reagent_containers/food/snacks/grown/mushroom/glowshroom/dropped(mob/user)
	user.set_light(round(user.luminosity - (potency / 10), 1))
	set_light(round(potency / 10, 1))

/*
 * Plump-Helmet
 */
/obj/item/reagent_containers/food/snacks/grown/mushroom/plumphelmet
	seed = /obj/item/seeds/plumpmycelium
	name = "plump-helmet"
	desc = "<I>Plumus Hellmus</I>: Plump, soft and s-so inviting~"
	icon_state = "plumphelmet"
	filling_color = "#F714BE"

/obj/item/reagent_containers/food/snacks/grown/mushroom/plumphelmet/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2 + round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Walking Mushroom
 */
/obj/item/reagent_containers/food/snacks/grown/mushroom/walkingmushroom
	seed = /obj/item/seeds/walkingmushroommycelium
	name = "walking mushroom"
	desc = "<I>Plumus Locomotus</I>: The beginning of the great walk."
	icon_state = "walkingmushroom"
	filling_color = "#FFBFEF"

	lifespan = 120
	endurance = 30
	maturation = 15
	production = 1
	yield = 3
	potency = 30
	plant_type = 2

/obj/item/reagent_containers/food/snacks/grown/mushroom/walkingmushroom/initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2 + round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)
	if(ismob(src.loc))
		pickup(src.loc)

/obj/item/reagent_containers/food/snacks/grown/mushroom/walkingmushroom/attack_self(mob/user as mob)
	if(isspace(user.loc))
		return

	new /mob/living/simple_animal/mushroom(user.loc)
	qdel(src)

	to_chat(user, SPAN_NOTICE("You plant the walking mushroom."))