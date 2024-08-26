/*
 * Poppy
 */
/obj/item/reagent_holder/food/snacks/grown/poppy
	seed = /obj/item/seeds/poppy
	name = "poppy"
	desc = "Long-used as a symbol of rest, peace, and death."
	icon_state = "poppy"
	potency = 30
	filling_color = "#CC6464"

/obj/item/reagent_holder/food/snacks/grown/poppy/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 20), 1))
	reagents.add_reagent("bicaridine", 1 + round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 3, 1)

/*
 * Harebell
 */
/obj/item/reagent_holder/food/snacks/grown/harebell
	seed = /obj/item/seeds/harebell
	name = "harebell"
	desc = "\"I'll sweeten thy sad grave: thou shalt not lack the flower that's like thy face, pale primrose, nor the azured hare-bell, like thy veins; no, nor the leaf of eglantine, whom not to slander, out-sweeten�d not thy breath.\""
	icon_state = "harebell"
	potency = 1
	filling_color = "#D4B2C9"

/obj/item/reagent_holder/food/snacks/grown/harebell/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 20), 1))
	bitesize = 1 + round(reagents.total_volume / 3, 1)

/*
 * Sunflower
 */
/*
 * Sunflower
 */
/obj/item/grown/sunflower // FLOWER POWER!
	name = "sunflower"
	desc = "It's beautiful! A certain person might beat you to death if you trample these."
	icon = 'icons/obj/flora/harvest.dmi'
	icon_state = "sunflower"
	damtype = "fire"
	force = 0
	throwforce = 1
	w_class = 1.0
	throw_speed = 1
	throw_range = 3
	plant_type = 1
	seed = /obj/item/seeds/sunflower

/obj/item/grown/sunflower/attack(mob/M, mob/user)
	to_chat(M, "<font color='green'><b>[user] smacks you with a sunflower!</font><font color='yellow'><b>FLOWER POWER<b></font>")
	to_chat(user, "<font color='green'>Your sunflower's </font><font color='yellow'><b>FLOWER POWER</b></font><font color='green'> strikes [M]</font>")