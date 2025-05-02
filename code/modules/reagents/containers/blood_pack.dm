/obj/item/reagent_holder/blood
	name = "\improper BloodPack"
	desc = "Contains blood used for transfusion."
	icon = 'icons/obj/items/bloodpack.dmi'
	icon_state = "empty"
	volume = 200

	var/blood_type = null

/obj/item/reagent_holder/blood/New()
	..()
	if(blood_type != null)
		name = "\improper BloodPack [blood_type]"
		reagents.add_reagent("blood", 200, list("donor" = null, "viruses" = null, "blood_DNA" = null, "blood_type" = blood_type, "resistances" = null, "trace_chem" = null))
		update_icon()

/obj/item/reagent_holder/blood/on_reagent_change()
	update_icon()

/obj/item/reagent_holder/blood/update_icon()
	var/percent = round((reagents.total_volume / volume) * 100)
	switch(percent)
		if(0 to 9)
			icon_state = "empty"
		if(10 to 50)
			icon_state = "half"
		if(51 to INFINITY)
			icon_state = "full"

/obj/item/reagent_holder/blood/APlus
	blood_type = "A+"

/obj/item/reagent_holder/blood/AMinus
	blood_type = "A-"

/obj/item/reagent_holder/blood/BPlus
	blood_type = "B+"

/obj/item/reagent_holder/blood/BMinus
	blood_type = "B-"

/obj/item/reagent_holder/blood/OPlus
	blood_type = "O+"

/obj/item/reagent_holder/blood/OMinus
	blood_type = "O-"

/obj/item/reagent_holder/blood/empty
	name = "empty BloodPack"
	desc = "Seems pretty useless... Maybe if there were a way to fill it?"
	icon_state = "empty"