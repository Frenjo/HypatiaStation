
//chemistry stuff here so that it can be easily viewed/modified
/datum/reagent/tungsten
	name = "Tungsten"
	id = "tungsten"
	description = "A chemical element, and a strong oxidising agent."
	reagent_state = REAGENT_SOLID
	color = "#DCDCDC"  // rgb: 220, 220, 220, silver

/datum/reagent/lithiumsodiumtungstate
	name = "Lithium Sodium Tungstate"
	id = "lithiumsodiumtungstate"
	description = "A reducing agent for geological compounds."
	reagent_state = REAGENT_LIQUID
	color = "#C0C0C0"	// rgb: 192, 192, 192, darker silver

/datum/reagent/ground_rock
	name = "Ground Rock"
	id = "ground_rock"
	description = "A fine dust made of ground up rock."
	reagent_state = REAGENT_SOLID
	color = "#A0522D"	//rgb: 160, 82, 45, brown

/datum/reagent/density_separated_sample
	name = "Density separated sample"
	id = "density_separated_sample"
	description = "A watery paste used in chemical analysis, there are some chunks floating in it."
	reagent_state = REAGENT_LIQUID
	color = "#DEB887"	//rgb: 222, 184, 135, light brown

/datum/reagent/analysis_sample
	name = "Analysis liquid"
	id = "analysis_sample"
	description = "A watery paste used in chemical analysis."
	reagent_state = REAGENT_LIQUID
	color = "#F5FFFA"	//rgb: 245, 255, 250, almost white

/datum/reagent/chemical_waste
	name = "Chemical Waste"
	id = "chemical_waste"
	description = "A viscous, toxic liquid left over from many chemical processes."
	reagent_state = REAGENT_LIQUID
	color = "#ADFF2F"	//rgb: 173, 255, 47, toxic green


/datum/chemical_reaction/lithiumsodiumtungstate	//LiNa2WO4, not the easiest chem to mix
	name = "Lithium Sodium Tungstate"
	result = /datum/reagent/lithiumsodiumtungstate
	required_reagents = alist("lithium" = 1, "sodium" = 2, "tungsten" = 1, "oxygen" = 4)
	result_amount = 8

/datum/chemical_reaction/density_separated_liquid
	name = "Density separated sample"
	result = /datum/reagent/density_separated_sample
	required_reagents = alist("ground_rock" = 1, "lithiumsodiumtungstate" = 2)
	result_amount = 2
	secondary_results = alist("chemical_waste" = 1)

/datum/chemical_reaction/analysis_liquid
	name = "Analysis sample"
	result = /datum/reagent/analysis_sample
	required_reagents = alist("density_separated_sample" = 5)
	result_amount = 4
	secondary_results = alist("chemical_waste" = 1)
	requires_heating = 1


/obj/item/reagent_holder/glass/solution_tray
	name = "solution tray"
	desc = "A small, open-topped glass container for delicate research samples. It sports a re-useable strip for labelling with a pen."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "solution_tray"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	matter_amounts = alist(/decl/material/glass = 5)
	w_class = 1.0
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1, 2)
	volume = 2

/obj/item/reagent_holder/glass/solution_tray/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/pen))
		var/new_label = input("What should the new label be?", "Label Solution Tray")
		if(isnotnull(new_label))
			name = "solution tray ([new_label])"
			to_chat(user, SPAN_INFO("You label the solution tray using \the [I]."))
		return TRUE

	return ..()


/obj/item/storage/box/solution_trays
	name = "solution tray box"
	icon_state = "solution_trays"

	starts_with = list(
		/obj/item/reagent_holder/glass/solution_tray = 7
	)

/obj/item/reagent_holder/glass/beaker/tungsten
	name = "beaker 'tungsten'"
	starting_reagents = alist("tungsten" = 50)

/obj/item/reagent_holder/glass/beaker/oxygen
	name = "beaker 'oxygen'"
	starting_reagents = alist("oxygen" = 50)

/obj/item/reagent_holder/glass/beaker/sodium
	name = "beaker 'sodium'"
	starting_reagents = alist("sodium" = 50)

/obj/item/reagent_holder/glass/beaker/lithium
	name = "beaker 'lithium'"
	starting_reagents = alist("lithium" = 50)

/obj/item/reagent_holder/glass/beaker/water
	name = "beaker 'water'"
	starting_reagents = alist("water" = 50)

/obj/item/reagent_holder/glass/beaker/fuel
	name = "beaker 'fuel'"
	starting_reagents = alist("fuel" = 50)