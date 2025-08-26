/obj/item/reagent_holder/glass/beaker
	name = "beaker"
	desc = "A beaker. Can hold up to 50 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	matter_amounts = /datum/design/autolathe/beaker::materials

/obj/item/reagent_holder/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/reagent_holder/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_holder/glass/beaker/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_holder/glass/beaker/attack_hand()
	..()
	update_icon()

/obj/item/reagent_holder/glass/beaker/update_icon()
	cut_overlays()

	if(reagents.total_volume)
		var/mutable_appearance/filling_overlay = mutable_appearance('icons/obj/reagentfillings.dmi', "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)
				filling_overlay.icon_state = "[icon_state]-10"
			if(10 to 24)
				filling_overlay.icon_state = "[icon_state]10"
			if(25 to 49)
				filling_overlay.icon_state = "[icon_state]25"
			if(50 to 74)
				filling_overlay.icon_state = "[icon_state]50"
			if(75 to 79)
				filling_overlay.icon_state = "[icon_state]75"
			if(80 to 90)
				filling_overlay.icon_state = "[icon_state]80"
			if(91 to INFINITY)
				filling_overlay.icon_state = "[icon_state]100"

		filling_overlay.icon += mix_colour_from_reagents(reagents.reagent_list)
		add_overlay(filling_overlay)

	if(!is_open_container())
		add_overlay(mutable_appearance(icon, "lid_[initial(icon_state)]"))

/obj/item/reagent_holder/glass/beaker/cryoxadone
	starting_reagents = alist("cryoxadone" = 30)

/obj/item/reagent_holder/glass/beaker/sulphuric
	starting_reagents = alist("sacid" = 50)

/obj/item/reagent_holder/glass/beaker/slime
	starting_reagents = alist("slimejelly" = 50)

/obj/item/reagent_holder/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker. Can hold up to 100 units."
	icon_state = "beakerlarge"
	matter_amounts = /datum/design/autolathe/large_beaker::materials
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25, 30, 50, 100)

/obj/item/reagent_holder/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	icon_state = "beakernoreact"
	matter_amounts = /datum/design/medical/noreactbeaker::materials
	origin_tech = /datum/design/medical/noreactbeaker::req_tech
	volume = 50
	amount_per_transfer_from_this = 10
	atom_flags = parent_type::atom_flags | ATOM_FLAG_NO_REACT

/obj/item/reagent_holder/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology. Can hold up to 300 units."
	icon_state = "beakerbluespace"
	matter_amounts = /datum/design/medical/bluespacebeaker::materials
	origin_tech = /datum/design/medical/bluespacebeaker::req_tech
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25, 30, 50, 100, 300)