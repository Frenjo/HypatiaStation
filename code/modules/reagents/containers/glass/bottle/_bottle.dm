
//Not to be confused with /obj/item/reagent_holder/food/drinks/bottle
/obj/item/reagent_holder/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25, 30)
	volume = 30

/obj/item/reagent_holder/glass/bottle/New()
	. = ..()
	if(!icon_state)
		icon_state = "bottle[rand(1, 20)]"

/obj/item/reagent_holder/glass/bottle/update_icon()
	cut_overlays()
	if(!is_open_container())
		add_overlay(mutable_appearance(icon, "lid_bottle"))


/obj/item/reagent_holder/glass/bottle/inaprovaline
	name = "inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

/obj/item/reagent_holder/glass/bottle/inaprovaline/New()
	. = ..()
	reagents.add_reagent("inaprovaline", 30)


/obj/item/reagent_holder/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle12"

/obj/item/reagent_holder/glass/bottle/toxin/New()
	. = ..()
	reagents.add_reagent("toxin", 30)


/obj/item/reagent_holder/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle12"

/obj/item/reagent_holder/glass/bottle/cyanide/New()
	. = ..()
	reagents.add_reagent("cyanide", 30)


/obj/item/reagent_holder/glass/bottle/stoxin
	name = "sleep-toxin bottle"
	desc = "A small bottle of sleep toxins. Just the fumes make you sleepy."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

/obj/item/reagent_holder/glass/bottle/stoxin/New()
	. = ..()
	reagents.add_reagent("stoxin", 30)


/obj/item/reagent_holder/glass/bottle/chloralhydrate
	name = "Chloral Hydrate Bottle"
	desc = "A small bottle of Choral Hydrate. Mickey's Favorite!"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

/obj/item/reagent_holder/glass/bottle/chloralhydrate/New()
	. = ..()
	reagents.add_reagent("chloralhydrate", 15)		//Intentionally low since it is so strong. Still enough to knock someone out.


/obj/item/reagent_holder/glass/bottle/antitoxin
	name = "anti-toxin bottle"
	desc = "A small bottle of Anti-toxins. Counters poisons, and repairs damage, a wonder drug."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

/obj/item/reagent_holder/glass/bottle/antitoxin/New()
	. = ..()
	reagents.add_reagent("anti_toxin", 30)


/obj/item/reagent_holder/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

/obj/item/reagent_holder/glass/bottle/mutagen/New()
	. = ..()
	reagents.add_reagent("mutagen", 30)


/obj/item/reagent_holder/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle20"

/obj/item/reagent_holder/glass/bottle/ammonia/New()
	. = ..()
	reagents.add_reagent("ammonia", 30)


/obj/item/reagent_holder/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

/obj/item/reagent_holder/glass/bottle/diethylamine/New()
	. = ..()
	reagents.add_reagent("diethylamine", 30)


/obj/item/reagent_holder/glass/bottle/flu_virion
	name = "Flu virion culture bottle"
	desc = "A small bottle. Contains H13N1 flu virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	volume = 20

/obj/item/reagent_holder/glass/bottle/flu_virion/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/advance/flu(0))))


/obj/item/reagent_holder/glass/bottle/epiglottis_virion
	name = "Epiglottis virion culture bottle"
	desc = "A small bottle. Contains Epiglottis virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	volume = 20

/obj/item/reagent_holder/glass/bottle/epiglottis_virion/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/advance/voice_change(0))))


/obj/item/reagent_holder/glass/bottle/liver_enhance_virion
	name = "Liver enhancement virion culture bottle"
	desc = "A small bottle. Contains liver enhancement virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	volume = 20

/obj/item/reagent_holder/glass/bottle/liver_enhance_virion/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/advance/heal(0))))


/obj/item/reagent_holder/glass/bottle/hullucigen_virion
	name = "Hullucigen virion culture bottle"
	desc = "A small bottle. Contains hullucigen virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	volume = 20

/obj/item/reagent_holder/glass/bottle/hullucigen_virion/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/advance/hullucigen(0))))


/obj/item/reagent_holder/glass/bottle/pierrot_throat
	name = "Pierrot's Throat culture bottle"
	desc = "A small bottle. Contains H0NI<42 virion culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	volume = 20

/obj/item/reagent_holder/glass/bottle/pierrot_throat/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/pierrot_throat(0))))


/obj/item/reagent_holder/glass/bottle/cold
	name = "Rhinovirus culture bottle"
	desc = "A small bottle. Contains XY-rhinovirus culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	volume = 20

/obj/item/reagent_holder/glass/bottle/cold/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/advance/cold(0))))


/obj/item/reagent_holder/glass/bottle/random
	name = "Random culture bottle"
	desc = "A small bottle. Contains a random disease."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	volume = 20

/obj/item/reagent_holder/glass/bottle/random/New()
	. = ..()
	var/datum/disease/advance/F = new(0)
	reagents.add_reagent("blood", 20, list("viruses" = list(F)))


/obj/item/reagent_holder/glass/bottle/retrovirus
	name = "Retrovirus culture bottle"
	desc = "A small bottle. Contains a retrovirus culture in a synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	volume = 20

/obj/item/reagent_holder/glass/bottle/retrovirus/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/dna_retrovirus(0))))


/obj/item/reagent_holder/glass/bottle/gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS+ culture in synthblood medium."//Or simply - General BullShit
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	amount_per_transfer_from_this = 5
	volume = 20

/obj/item/reagent_holder/glass/bottle/gbs/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/gbs())))


/obj/item/reagent_holder/glass/bottle/fake_gbs
	name = "GBS culture bottle"
	desc = "A small bottle. Contains Gravitokinetic Bipotential SADS- culture in synthblood medium."//Or simply - General BullShit
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	volume = 20

/obj/item/reagent_holder/glass/bottle/fake_gbs/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/fake_gbs(0))))

/*
/obj/item/reagent_holder/glass/bottle/rhumba_beat
	name = "Rhumba Beat culture bottle"
	desc = "A small bottle. Contains The Rhumba Beat culture in synthblood medium."//Or simply - General BullShit
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	amount_per_transfer_from_this = 5

	New()
		create_reagents(20)
		var/datum/disease/F = new /datum/disease/rhumba_beat
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 20, data)
*/

/obj/item/reagent_holder/glass/bottle/brainrot
	name = "Brainrot culture bottle"
	desc = "A small bottle. Contains Cryptococcus Cosmosis culture in synthblood medium."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"

/obj/item/reagent_holder/glass/bottle/brainrot/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/brainrot(0))))


/obj/item/reagent_holder/glass/bottle/magnitis
	name = "Magnitis culture bottle"
	desc = "A small bottle. Contains a small dosage of Fukkos Miracos."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"

/obj/item/reagent_holder/glass/bottle/magnitis/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/magnitis(0))))


/obj/item/reagent_holder/glass/bottle/wizarditis
	name = "Wizarditis culture bottle"
	desc = "A small bottle. Contains a sample of Rincewindus Vulgaris."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"

/obj/item/reagent_holder/glass/bottle/wizarditis/New()
	. = ..()
	reagents.add_reagent("blood", 20, list("viruses" = list(new /datum/disease/wizarditis(0))))


/obj/item/reagent_holder/glass/bottle/pacid
	name = "Polytrinic Acid Bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

/obj/item/reagent_holder/glass/bottle/pacid/New()
	. = ..()
	reagents.add_reagent("pacid", 30)


/obj/item/reagent_holder/glass/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/items/drinks.dmi'
	icon_state = "holyflask"

/obj/item/reagent_holder/glass/bottle/adminordrazine/New()
	. = ..()
	reagents.add_reagent("adminordrazine", 30)


/obj/item/reagent_holder/glass/bottle/capsaicin
	name = "Capsaicin Bottle"
	desc = "A small bottle. Contains hot sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"

/obj/item/reagent_holder/glass/bottle/capsaicin/New()
	. = ..()
	reagents.add_reagent("capsaicin", 30)


/obj/item/reagent_holder/glass/bottle/frostoil
	name = "Frost Oil Bottle"
	desc = "A small bottle. Contains cold sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle17"

/obj/item/reagent_holder/glass/bottle/frostoil/New()
	. = ..()
	reagents.add_reagent("frostoil", 30)