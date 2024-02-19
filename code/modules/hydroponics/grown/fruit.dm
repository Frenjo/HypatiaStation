/*
 * Chili Pepper
 */
/obj/item/reagent_containers/food/snacks/grown/chili
	seed = /obj/item/seeds/chili
	name = "chili"
	desc = "It's spicy! Wait... IT'S BURNING ME!!"
	icon_state = "chilipepper"
	filling_color = "#FF0000"

/obj/item/reagent_containers/food/snacks/grown/chili/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 25), 1))
	reagents.add_reagent("capsaicin", 3 + round(potency / 5, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/chili/attackby(obj/item/O as obj, mob/user as mob)
	. = ..()
	if(istype(O, /obj/item/plant_analyser))
		to_chat(user, SPAN_INFO("- Capsaicin: <i>[reagents.get_reagent_amount("capsaicin")]%</i>"))

/*
 * Ice Pepper
 */
/obj/item/reagent_containers/food/snacks/grown/icepepper
	seed = /obj/item/seeds/icepepper
	name = "ice-pepper"
	desc = "It's a mutant strain of chili"
	icon_state = "icepepper"
	potency = 20
	filling_color = "#66CEED"

/obj/item/reagent_containers/food/snacks/grown/icepepper/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 50), 1))
	reagents.add_reagent("frostoil", 3 + round(potency / 5, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/icepepper/attackby(obj/item/O as obj, mob/user as mob)
	. = ..()
	if(istype(O, /obj/item/plant_analyser))
		to_chat(user, SPAN_INFO("- Frostoil: <i>[reagents.get_reagent_amount("frostoil")]%</i>"))

/*
 * Grape
 */
/obj/item/reagent_containers/food/snacks/grown/grapes
	seed = /obj/item/seeds/grape
	name = "bunch of grapes"
	desc = "Nutritious!"
	icon_state = "grapes"
	filling_color = "#A332AD"

/obj/item/reagent_containers/food/snacks/grown/grapes/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	reagents.add_reagent("sugar", 1 + round((potency / 5), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Green Grape
 */
/obj/item/reagent_containers/food/snacks/grown/greengrapes
	seed = /obj/item/seeds/grape/green
	name = "bunch of green grapes"
	desc = "Nutritious!"
	icon_state = "greengrapes"
	potency = 25
	filling_color = "#A6FFA3"

/obj/item/reagent_containers/food/snacks/grown/greengrapes/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	reagents.add_reagent("kelotane", 3 + round((potency / 5), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Berry
 */
/obj/item/reagent_containers/food/snacks/grown/berries
	seed = /obj/item/seeds/berry
	name = "bunch of berries"
	desc = "Nutritious!"
	icon_state = "berrypile"
	filling_color = "#C2C9FF"

/obj/item/reagent_containers/food/snacks/grown/berries/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Glow Berry
 */
/obj/item/reagent_containers/food/snacks/grown/glowberries
	seed = /obj/item/seeds/berry/glow
	name = "bunch of glow-berries"
	desc = "Nutritious!"
	var/light_on = 1
	var/brightness_on = 2 //luminosity when on
	filling_color = "#D3FF9E"
	icon_state = "glowberrypile"

/obj/item/reagent_containers/food/snacks/grown/glowberries/initialise()
	. = ..()
	reagents.add_reagent("nutriment", round((potency / 10), 1))
	reagents.add_reagent("uranium", 3 + round(potency / 5, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/glowberries/Destroy()
	if(ismob(loc))
		loc.set_light(round(loc.luminosity - potency / 5, 1))
	return ..()

/obj/item/reagent_containers/food/snacks/grown/glowberries/pickup(mob/user)
	src.set_light(0)
	user.set_light(round(user.luminosity + (potency / 5), 1))

/obj/item/reagent_containers/food/snacks/grown/glowberries/dropped(mob/user)
	user.set_light(round(user.luminosity - (potency / 5), 1))
	src.set_light(round(potency / 5, 1))

/*
 * Poison Berry
 */
/obj/item/reagent_containers/food/snacks/grown/poisonberries
	seed = /obj/item/seeds/berry/poison
	name = "bunch of poison-berries"
	desc = "Taste so good, you could die!"
	icon_state = "poisonberrypile"
	gender = PLURAL
	potency = 15
	filling_color = "#B422C7"

/obj/item/reagent_containers/food/snacks/grown/poisonberries/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1)
	reagents.add_reagent("toxin", 3 + round(potency / 5, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Death Berry
 */
/obj/item/reagent_containers/food/snacks/grown/deathberries
	seed = /obj/item/seeds/berry/death
	name = "bunch of death-berries"
	desc = "Taste so good, you could die!"
	icon_state = "deathberrypile"
	gender = PLURAL
	potency = 50
	filling_color = "#4E0957"

/obj/item/reagent_containers/food/snacks/grown/deathberries/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1)
	reagents.add_reagent("toxin", 3 + round(potency / 3, 1))
	reagents.add_reagent("lexorin", 1 + round(potency / 5, 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Banana
 */
/obj/item/reagent_containers/food/snacks/grown/banana
	seed = /obj/item/seeds/banana
	name = "banana"
	desc = "It's an excellent prop for a comedy."
	icon = 'icons/obj/items.dmi'
	icon_state = "banana"
	item_state = "banana"
	filling_color = "#FCF695"
	trash = /obj/item/bananapeel

/obj/item/reagent_containers/food/snacks/grown/banana/New()
	..()
	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)

/obj/item/reagent_containers/food/snacks/grown/banana/initialise()
	. = ..()
	reagents.add_reagent("banana", 1 + round((potency / 10), 1))
	bitesize = 5

/*
 * Eggplant (Aubergine)
 */
/obj/item/reagent_containers/food/snacks/grown/eggplant
	seed = /obj/item/seeds/eggplant
	name = "eggplant"
	desc = "Maybe there's a chicken inside?"
	icon_state = "eggplant"
	filling_color = "#550F5C"

/obj/item/reagent_containers/food/snacks/grown/eggplant/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Apple
 */
/obj/item/reagent_containers/food/snacks/grown/apple
	seed = /obj/item/seeds/apple
	name = "apple"
	desc = "It's a little piece of Eden."
	icon_state = "apple"
	potency = 15
	filling_color = "#DFE88B"

/obj/item/reagent_containers/food/snacks/grown/apple/initialise()
	. = ..()
	reagents.maximum_volume = 20
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	bitesize = reagents.maximum_volume // Always eat the apple in one

/*
 * Poisoned Apple
 */
/obj/item/reagent_containers/food/snacks/grown/apple/poisoned
	seed = /obj/item/seeds/apple/poisoned
	name = "apple"
	desc = "It's a little piece of Eden."
	icon_state = "apple"
	potency = 15
	filling_color = "#B3BD5E"

/obj/item/reagent_containers/food/snacks/grown/apple/poisoned/initialise()
	. = ..()
	reagents.maximum_volume = 20
	reagents.add_reagent("cyanide", 1 + round((potency / 5), 1))
	bitesize = reagents.maximum_volume // Always eat the apple in one

/*
 * Golden Apple
 */
/obj/item/reagent_containers/food/snacks/grown/goldapple
	seed = /obj/item/seeds/apple/golden
	name = "golden apple"
	desc = "Emblazoned upon the apple is the word 'Kallisti'."
	icon_state = "goldapple"
	potency = 15
	filling_color = "#F5CB42"

/obj/item/reagent_containers/food/snacks/grown/goldapple/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	reagents.add_reagent("gold", 1 + round((potency / 5), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Watermelon
 */
/obj/item/reagent_containers/food/snacks/grown/watermelon
	seed = /obj/item/seeds/watermelon
	name = "watermelon"
	desc = "It's full of watery goodness."
	icon_state = "watermelon"
	potency = 10
	filling_color = "#FA2863"
	slice_path = /obj/item/reagent_containers/food/snacks/watermelonslice
	slices_num = 5

/obj/item/reagent_containers/food/snacks/grown/watermelon/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 6), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Pumpkin
 */
/obj/item/reagent_containers/food/snacks/grown/pumpkin
	seed = /obj/item/seeds/pumpkin
	name = "pumpkin"
	desc = "It's large and scary."
	icon_state = "pumpkin"
	potency = 10
	filling_color = "#FAB728"

/obj/item/reagent_containers/food/snacks/grown/pumpkin/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 6), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/pumpkin/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/circular_saw) || istype(W, /obj/item/hatchet) \
	|| istype(W, /obj/item/twohanded/fireaxe) || istype(W, /obj/item/kitchen/utensil/knife) \
	|| istype(W, /obj/item/kitchenknife) || istype(W, /obj/item/melee/energy))
		user.show_message(SPAN_NOTICE("You carve a face into [src]!"), 1)
		new /obj/item/clothing/head/pumpkinhead (user.loc)
		qdel(src)
		return

/*
 * Lime
 */
/obj/item/reagent_containers/food/snacks/grown/lime
	seed = /obj/item/seeds/lime
	name = "lime"
	desc = "It's so sour, your face will twist."
	icon_state = "lime"
	potency = 20
	filling_color = "#28FA59"

/obj/item/reagent_containers/food/snacks/grown/lime/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 20), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Lemon
 */
/obj/item/reagent_containers/food/snacks/grown/lemon
	seed = /obj/item/seeds/lemon
	name = "lemon"
	desc = "When life gives you lemons, be grateful they aren't limes."
	icon_state = "lemon"
	potency = 20
	filling_color = "#FAF328"

/obj/item/reagent_containers/food/snacks/grown/lemon/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 20), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Orange
 */
/obj/item/reagent_containers/food/snacks/grown/orange
	seed = /obj/item/seeds/orange
	name = "orange"
	desc = "It's an tangy fruit."
	icon_state = "orange"
	potency = 20
	filling_color = "#FAAD28"

/obj/item/reagent_containers/food/snacks/grown/orange/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 20), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Cocoa Pod
 */
/obj/item/reagent_containers/food/snacks/grown/cocoapod
	seed = /obj/item/seeds/cocoapod
	name = "cocoa pod"
	desc = "Fattening... Mmmmm... chucklate."
	icon_state = "cocoapod"
	potency = 50
	filling_color = "#9C8E54"

/obj/item/reagent_containers/food/snacks/grown/cocoapod/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	reagents.add_reagent("coco", 4 + round((potency / 5), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/*
 * Cherry
 */
/obj/item/reagent_containers/food/snacks/grown/cherries
	seed = /obj/item/seeds/cherry
	name = "cherries"
	desc = "Great for toppings!"
	icon_state = "cherry"
	filling_color = "#FF0000"
	gender = PLURAL

/obj/item/reagent_containers/food/snacks/grown/cherries/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 15), 1))
	reagents.add_reagent("sugar", 1 + round((potency / 15), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)