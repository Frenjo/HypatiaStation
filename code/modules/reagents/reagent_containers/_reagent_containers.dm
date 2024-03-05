/obj/item/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = 1
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5, 10, 15, 25, 30)
	var/volume = 30

/obj/item/reagent_containers/verb/set_APTFT() //set amount_per_transfer_from_this
	set category = PANEL_OBJECT
	set name = "Set transfer amount"
	set src in range(0)

	var/N = input("Amount per transfer from this:", "[src]") as null | anything in possible_transfer_amounts
	if(N)
		amount_per_transfer_from_this = N

/obj/item/reagent_containers/New()
	..()
	if(!possible_transfer_amounts)
		src.verbs -= /obj/item/reagent_containers/verb/set_APTFT
	var/datum/reagents/R = new/datum/reagents(volume)
	reagents = R
	R.my_atom = src

/obj/item/reagent_containers/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/attack(mob/M as mob, mob/user as mob, def_zone)
	return

// this prevented pills, food, and other things from being picked up by bags.
// possibly intentional, but removing it allows us to not duplicate functionality.
// -Sayu (storage conslidation)
/*
/obj/item/reagent_containers/attackby(obj/item/I as obj, mob/user as mob)
	return
*/
/obj/item/reagent_containers/afterattack(obj/target, mob/user , flag)
	return

/obj/item/reagent_containers/proc/reagentlist(obj/item/reagent_containers/snack) //Attack logs for regents in pills
	var/data
	if(length(snack.reagents.reagent_list)) //find a reagent list if there is and check if it has entries
		for(var/datum/reagent/R in snack.reagents.reagent_list) //no reagents will be left behind
			data += "[R.id]([R.volume] units); " //Using IDs because SOME chemicals(I'm looking at you, chlorhydrate-beer) have the same names as other chemicals.
		return data
	else
		return "No reagents"