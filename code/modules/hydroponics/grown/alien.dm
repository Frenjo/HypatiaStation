/*
 * S'Rendarr's Hand
 */
/obj/item/reagent_holder/food/snacks/grown/shand
	seed = /obj/item/seeds/shand
	name = "\improper S'Rendarr's Hand leaf"
	desc = "A leaf sample from a lowland thicket shrub, often hid in by prey and predator to staunch their wounds and conceal their scent, allowing the plant to spread far on its native Ahdomai. Smells strongly like wax."
	icon_state = "shand"
	filling_color = "#70C470"

/obj/item/reagent_holder/food/snacks/grown/shand/initialise()
	. = ..()
	reagents.add_reagent("bicaridine", round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_holder/food/snacks/grown/shand/attack_self(mob/user)
	if(isspace(user.loc))
		return

	var/obj/item/stack/medical/bruise_pack/tajaran/poultice = new /obj/item/stack/medical/bruise_pack/tajaran(user.loc)

	poultice.heal_brute = potency
	qdel(src)

	to_chat(user, SPAN_NOTICE("You mash the leaves into a poultice."))

/*
 * Messa's Tear
 */
/obj/item/reagent_holder/food/snacks/grown/mtear
	seed = /obj/item/seeds/mtear
	name = "sprig of Messa's Tear"
	desc = "A mountain climate herb with a soft, cold blue flower, known to contain an abundance of chemicals in it's flower useful to treating burns- Bad for the allergic to pollen."
	icon_state = "mtear"
	filling_color = "#70C470"

/obj/item/reagent_holder/food/snacks/grown/mtear/initialise()
	. = ..()
	reagents.add_reagent("honey", 1 + round((potency / 10), 1))
	reagents.add_reagent("kelotane", 3 + round((potency / 5), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_holder/food/snacks/grown/mtear/attack_self(mob/user)
	if(isspace(user.loc))
		return

	var/obj/item/stack/medical/ointment/tajaran/poultice = new /obj/item/stack/medical/ointment/tajaran(user.loc)

	poultice.heal_burn = potency
	qdel(src)

	to_chat(user, SPAN_NOTICE("You mash the petals into a poultice."))