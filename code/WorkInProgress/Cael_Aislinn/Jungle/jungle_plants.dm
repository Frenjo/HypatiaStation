//*********************//
// Generic undergrowth //
//*********************//

/obj/structure/bush
	name = "foliage"
	desc = "Pretty thick scrub, it'll take something sharp and a lot of determination to clear away."
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "bush1"
	density = TRUE
	anchored = TRUE
	layer = 3.2

	var/indestructible = 0
	var/stump = 0

/obj/structure/bush/initialise()
	. = ..()
	if(prob(20))
		set_opacity(1)

/obj/structure/bush/Bumped(M as mob)
	if(issimple(M))
		var/mob/living/simple/A = M
		A.forceMove(GET_TURF(src))
	else if(ismonkey(M))
		var/mob/living/carbon/monkey/A = M
		A.forceMove(GET_TURF(src))

/obj/structure/bush/attack_tool(obj/item/tool, mob/user)
	// Hatchets can clear away undergrowth.
	if(istype(tool, /obj/item/hatchet) && !stump)
		if(indestructible) // You can't destroy bushes that mark the edge of the map.
			to_chat(user, SPAN_WARNING("You flail away at the undergrowth, but it's too thick here."))
			return TRUE

		user.visible_message(
			SPAN_NOTICE("[user] begins clearing away \the [src]..."),
			SPAN_NOTICE("You begin clearing away \the [src]...")
		)
		if(do_after(user, rand(1.5 SECONDS, 3 SECONDS)))
			user.visible_message(
				SPAN_NOTICE("[user] clears away \the [src]."),
				SPAN_NOTICE("You clear away \the [src].")
			)
			new /obj/item/stack/sheet/wood(loc, rand(3, 15))
			if(prob(50))
				// TODO: Make this into a subtype or a new type entirely.
				icon_state = "stump[rand(1, 2)]"
				name = "cleared foliage"
				desc = "There used to be dense undergrowth here."
				density = FALSE
				stump = 1
				pixel_x = rand(-6, 6)
				pixel_y = rand(-6, 6)
			else
				qdel(src)
		return TRUE

	return ..()

//*******************************//
// Strange, fruit-bearing plants //
//*******************************//

var/list/fruit_icon_states = list("badrecipe", "kudzupod", "reishi", "lime", "grapes", "boiledrorocore", "chocolateegg")
var/list/reagent_effects = list("toxin", "anti_toxin", "stoxin", "space_drugs", "mindbreaker", "zombiepowder", "impedrezene")
var/jungle_plants_init = 0

/proc/init_jungle_plants()
	jungle_plants_init = 1
	fruit_icon_states = shuffle(fruit_icon_states)
	reagent_effects = shuffle(reagent_effects)

/obj/item/reagent_holder/food/snacks/grown/jungle_fruit
	seed
	name = "jungle fruit"
	desc = "It smells weird and looks off."
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "orange"
	potency = 1

/obj/structure/jungle_plant
	icon = 'code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi'
	icon_state = "plant1"
	desc = "Looks like some of that fruit might be edible."
	var/fruits_left = 3
	var/fruit_type = -1
	var/icon/fruit_overlay
	var/plant_strength = 1
	var/fruit_r
	var/fruit_g
	var/fruit_b


/obj/structure/jungle_plant/initialise()
	. = ..()
	if(!jungle_plants_init)
		init_jungle_plants()

	fruit_type = rand(1, 7)
	icon_state = "plant[fruit_type]"
	fruits_left = rand(1, 5)
	fruit_overlay = icon('code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi', "fruit[fruits_left]")
	fruit_r = 255 - fruit_type * 36
	fruit_g = rand(1, 255)
	fruit_b = fruit_type * 36
	fruit_overlay.Blend(rgb(fruit_r, fruit_g, fruit_b), ICON_ADD)
	add_overlay(fruit_overlay)
	plant_strength = rand(20, 200)

/obj/structure/jungle_plant/attack_hand(mob/user as mob)
	if(fruits_left > 0)
		fruits_left--
		to_chat(user, SPAN_INFO("You pick a fruit off [src]."))

		var/obj/item/reagent_holder/food/snacks/grown/jungle_fruit/J = new(src.loc)
		J.potency = plant_strength
		J.icon_state = fruit_icon_states[fruit_type]
		J.reagents.add_reagent(reagent_effects[fruit_type], 1+round((plant_strength / 20), 1))
		J.bitesize = 1+round(J.reagents.total_volume / 2, 1)
		J.attack_hand(user)

		remove_overlay(fruit_overlay)
		fruit_overlay = icon('code/WorkInProgress/Cael_Aislinn/Jungle/jungle.dmi', "fruit[fruits_left]")
		fruit_overlay.Blend(rgb(fruit_r, fruit_g, fruit_b), ICON_ADD)
		add_overlay(fruit_overlay)
	else
		to_chat(user, SPAN_WARNING("There are no fruit left on [src]."))
