// These may have some say.dm bugs regarding understanding common,
// might be worth adapting the bugs into a feature and using these
// subtypes as a basis for non-common-speaking alien foreigners. ~ Z

/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE | CANPUSH

/mob/living/carbon/human/soghun/New(new_loc)
	h_style = "Soghun Horns"
	..(new_loc, SPECIES_SOGHUN)

/mob/living/carbon/human/tajaran/New(new_loc)
	h_style = "Tajaran Ears"
	..(new_loc, SPECIES_TAJARAN)

/mob/living/carbon/human/skrell/New(new_loc)
	h_style = "Skrell Male Tentacles"
	..(new_loc, SPECIES_SKRELL)

/mob/living/carbon/human/machine/New(new_loc)
	h_style = "blue IPC screen"
	..(new_loc, SPECIES_MACHINE)

/mob/living/carbon/human/vox/New(new_loc)
	h_style = "Short Vox Quills"
	..(new_loc, SPECIES_VOX)

/mob/living/carbon/human/voxarmalis/New(new_loc)
	h_style = "Bald"
	..(new_loc, SPECIES_VOX_ARMALIS)

/mob/living/carbon/human/diona/New(new_loc)
	h_style = "Bald"
	..(new_loc, SPECIES_DIONA)

/mob/living/carbon/human/obsedai/New(new_loc)
	h_style = "Bald"
	..(new_loc, SPECIES_OBSEDAI)

/mob/living/carbon/human/plasmalin/New(new_loc)
	h_style = "Bald"
	..(new_loc, SPECIES_PLASMALIN)