// These may have some say.dm bugs regarding understanding common,
// might be worth adapting the bugs into a feature and using these
// subtypes as a basis for non-common-speaking alien foreigners. ~ Z

/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

/mob/living/carbon/human/skrell/New(var/new_loc)
	h_style = "Skrell Male Tentacles"
	..(new_loc, "Skrell")

/mob/living/carbon/human/tajaran/New(var/new_loc)
	h_style = "Tajaran Ears"
	..(new_loc, "Tajaran")

/mob/living/carbon/human/soghun/New(var/new_loc)
	h_style = "Soghun Horns"
	..(new_loc, "Soghun")

/mob/living/carbon/human/vox/New(var/new_loc)
	h_style = "Short Vox Quills"
	..(new_loc, "Vox")

/mob/living/carbon/human/diona/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, "Diona")

/mob/living/carbon/human/machine/New(var/new_loc)
	h_style = "blue IPC screen"
	..(new_loc, "Machine")

/mob/living/carbon/human/obsedai/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, "Obsedai")

/mob/living/carbon/human/plasmaperson/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, "Plasmapeople")