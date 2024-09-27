//////Kitchen Spike

#define MEAT_TYPE_NOTHING 0
#define MEAT_TYPE_MONKEY 1
#define MEAT_TYPE_ALIEN 2

/obj/structure/kitchenspike
	name = "a meat spike"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collecting meat from animals"
	density = TRUE
	anchored = TRUE
	var/meat = 0
	var/occupied = 0
	var/meattype = MEAT_TYPE_NOTHING

/obj/structure/kitchenspike/attack_paw(mob/user)
	return src.attack_hand(usr)

/obj/structure/kitchenspike/attack_grab(obj/item/grab/grab, mob/user, mob/grabbed)
	if(ismonkey(grabbed))
		if(!occupied)
			icon_state = "spikebloody"
			occupied = TRUE
			meat = 5
			meattype = MEAT_TYPE_MONKEY
			visible_message(SPAN_WARNING("[user] has forced [grabbed] onto the spike, killing them instantly!"))
			qdel(grabbed)
			qdel(grab)
		else
			to_chat(user, SPAN_WARNING("The spike already has something on it, finish collecting its meat first!"))
		return TRUE

	if(isalien(grabbed))
		if(!occupied)
			icon_state = "spikebloodygreen"
			occupied = TRUE
			meat = 5
			meattype = MEAT_TYPE_ALIEN
			visible_message(SPAN_WARNING("[user] has forced [grabbed] onto the spike, killing them instantly!"))
			qdel(grabbed)
			qdel(grab)
		else
			to_chat(user, SPAN_WARNING("The spike already has something on it, finish collecting its meat first!"))
		return TRUE

	to_chat(user, SPAN_WARNING("\The [grabbed] is too big for the spike, try something smaller!"))
	return TRUE

//	MouseDrop_T(var/atom/movable/C, mob/user)
//		if(istype(C, /obj/mob/carbon/monkey)
//		else if(istype(C, /obj/mob/carbon/alien) && !istype(C, /mob/living/carbon/alien/larva/slime))
//		else if(istype(C, /obj/livestock/spesscarp

/obj/structure/kitchenspike/attack_hand(mob/user)
	if(..())
		return
	if(src.occupied)
		if(src.meattype == MEAT_TYPE_MONKEY)
			if(src.meat > 1)
				src.meat--
				new /obj/item/reagent_holder/food/snacks/meat/monkey(src.loc)
				to_chat(user, "You remove some meat from the monkey.")
			else if(src.meat == 1)
				src.meat--
				new /obj/item/reagent_holder/food/snacks/meat/monkey(src.loc)
				to_chat(user, "You remove the last piece of meat from the monkey!")
				src.icon_state = "spike"
				src.occupied = 0
		else if(src.meattype == MEAT_TYPE_ALIEN)
			if(src.meat > 1)
				src.meat--
				new /obj/item/reagent_holder/food/snacks/xenomeat(src.loc)
				to_chat(user, "You remove some meat from the alien.")
			else if(src.meat == 1)
				src.meat--
				new /obj/item/reagent_holder/food/snacks/xenomeat(src.loc)
				to_chat(user, "You remove the last piece of meat from the alien!")
				src.icon_state = "spike"
				src.occupied = 0

#undef MEAT_TYPE_NOTHING
#undef MEAT_TYPE_MONKEY
#undef MEAT_TYPE_ALIEN