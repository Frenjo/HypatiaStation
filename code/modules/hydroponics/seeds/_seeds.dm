/obj/item/seeds
	name = "pack of seeds"
	icon = 'icons/obj/flora/seeds.dmi'
	icon_state = "seed" // unknown plant seed - these shouldn't exist in-game
	w_class = 1.0 // Makes them pocketable

	var/plantname = "Plants"
	var/productname
	var/species = ""
	var/lifespan = 0
	var/endurance = 0
	var/maturation = 0
	var/production = 0
	var/yield = 0 // If is -1, the plant/shroom/weed is never meant to be harvested
	var/oneharvest = 0
	var/potency = -1
	var/growthstages = 0
	var/plant_type = 0 // 0 = 'normal plant'; 1 = weed; 2 = shroom

/obj/item/seeds/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/plant_analyser))
		to_chat(user, "*** <B>[plantname]</B> ***")
		to_chat(user, "-Plant Endurance: \blue [endurance]")
		to_chat(user, "-Plant Lifespan: \blue [lifespan]")
		if(yield != -1)
			to_chat(user, "-Plant Yield: \blue [yield]")
		to_chat(user, "-Plant Production: \blue [production]")
		if(potency != -1)
			to_chat(user, "-Plant Potency: \blue [potency]")
		return
	..() // Fallthrough to item/attackby() so that bags can pick seeds up