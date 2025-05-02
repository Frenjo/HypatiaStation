/obj/item/reagent_holder/glass/bottle/robot
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25, 30, 50, 100)
	volume = 60
	var/reagent = ""


/obj/item/reagent_holder/glass/bottle/robot/inaprovaline
	name = "internal inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	reagent = "inaprovaline"

/obj/item/reagent_holder/glass/bottle/robot/inaprovaline/New()
	..()
	reagents.add_reagent("inaprovaline", 60)
	return


/obj/item/reagent_holder/glass/bottle/robot/antitoxin
	name = "internal anti-toxin bottle"
	desc = "A small bottle of Anti-toxins. Counters poisons, and repairs damage, a wonder drug."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"
	reagent = "anti_toxin"

/obj/item/reagent_holder/glass/bottle/robot/antitoxin/New()
	..()
	reagents.add_reagent("anti_toxin", 60)
	return