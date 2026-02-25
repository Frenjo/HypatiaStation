/obj/item/reagent_holder
	name = "container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = WEIGHT_CLASS_TINY

	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5, 10, 15, 25, 30)
	var/volume = 30

	var/alist/starting_reagents = null

/obj/item/reagent_holder/verb/set_APTFT() //set amount_per_transfer_from_this
	set category = null
	set name = "Set Transfer Amount"

	var/N = input("Amount per transfer from this:", "[src]") as null | anything in possible_transfer_amounts
	if(isnotnull(N))
		amount_per_transfer_from_this = N

/obj/item/reagent_holder/initialise()
	. = ..()
	if(!possible_transfer_amounts)
		verbs.Remove(/obj/item/reagent_holder/verb/set_APTFT)
	create_reagents(volume)
	if(isnotnull(starting_reagents))
		for(var/id in starting_reagents)
			reagents.add_reagent(id, starting_reagents[id])
		update_icon()

/obj/item/reagent_holder/attack_self(mob/user)
	return

/obj/item/reagent_holder/attack(mob/M, mob/user, def_zone)
	return

// this prevented pills, food, and other things from being picked up by bags.
// possibly intentional, but removing it allows us to not duplicate functionality.
// -Sayu (storage conslidation)
/*
/obj/item/reagent_holder/attackby(obj/item/I, mob/user)
	return
*/
/obj/item/reagent_holder/afterattack(obj/target, mob/user, flag)
	return

/obj/item/reagent_holder/proc/reagentlist(obj/item/reagent_holder/snack) //Attack logs for regents in pills
	var/data
	if(length(snack.reagents.reagent_list)) //find a reagent list if there is and check if it has entries
		for_no_type_check(var/datum/reagent/R, snack.reagents.reagent_list) //no reagents will be left behind
			data += "[R.type]([R.volume] units); "
		return data
	else
		return "No reagents"