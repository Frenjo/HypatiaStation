/obj/item/paintkit //Please don't use this for anything, it's a base type for custom mech paintjobs.
	name = "mecha customisation kit"
	desc = "A generic kit containing all the needed tools and parts to turn a mech into another mech."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "royce_kit"

	var/new_name = "mech"		//What is the variant called?
	var/new_desc = "A mech."	//How is the new mech described?
	var/new_icon = "ripley"		//What base icon will the new mech use?
	var/removable = null		//Can the kit be removed?
	var/list/allowed_types = list() //Types of mech that the kit will work on.