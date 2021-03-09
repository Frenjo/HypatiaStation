// These may have some say.dm bugs regarding understanding common,
// might be worth adapting the bugs into a feature and using these
// subtypes as a basis for non-common-speaking alien foreigners. ~ Z

/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

/mob/living/carbon/human/skrell/New()
	h_style = "Skrell Male Tentacles"
	set_species("Skrell")
	..()

/mob/living/carbon/human/tajaran/New()
	h_style = "Tajaran Ears"
	set_species("Tajaran")
	..()

/mob/living/carbon/human/soghun/New()
	h_style = "Soghun Horns"
	set_species("Soghun")
	..()

/mob/living/carbon/human/vox/New()
	h_style = "Short Vox Quills"
	set_species("Vox")
	..()

/mob/living/carbon/human/diona/New()
	species = new /datum/species/diona(src)
	..()

/mob/living/carbon/human/machine/New()
	species = new /datum/species/machine(src)
	h_style = "blue IPC screen"
	set_species("Machine")
	..()

/mob/living/carbon/human/obsedai/New()
	species = new /datum/species/obsedai(src)
	set_species("Obsedai")
	..()

/mob/living/carbon/human/plasmaperson/New()
	species = new /datum/species/plasmapeople(src)
	set_species("Plasmapeople")
	..()