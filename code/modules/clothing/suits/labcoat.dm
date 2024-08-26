/obj/item/clothing/suit/storage/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_open"
	item_state = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS
	allowed = list(
		/obj/item/gas_analyser, /obj/item/stack/medical, /obj/item/dnainjector,
		/obj/item/reagent_holder/dropper, /obj/item/reagent_holder/syringe, /obj/item/reagent_holder/hypospray,
		/obj/item/health_analyser, /obj/item/flashlight/pen, /obj/item/reagent_holder/glass/bottle,
		/obj/item/reagent_holder/glass/beaker, /obj/item/reagent_holder/pill, /obj/item/storage/pill_bottle,
		/obj/item/paper
	)
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/suit/storage/labcoat/verb/toggle()
	set category = PANEL_OBJECT
	set name = "Toggle Labcoat Buttons"
	set src in usr

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	switch(icon_state)
		if("labcoat_open")
			src.icon_state = "labcoat"
			to_chat(usr, "You button up the labcoat.")
		if("labcoat")
			src.icon_state = "labcoat_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("red_labcoat_open")
			src.icon_state = "red_labcoat"
			to_chat(usr, "You button up the labcoat.")
		if("red_labcoat")
			src.icon_state = "red_labcoat_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("blue_labcoat_open")
			src.icon_state = "blue_labcoat"
			to_chat(usr, "You button up the labcoat.")
		if("blue_labcoat")
			src.icon_state = "blue_labcoat_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("purple_labcoat_open")
			src.icon_state = "purple_labcoat"
			to_chat(usr, "You button up the labcoat.")
		if("purple_labcoat")
			src.icon_state = "purple_labcoat_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("green_labcoat_open")
			src.icon_state = "green_labcoat"
			to_chat(usr, "You button up the labcoat.")
		if("green_labcoat")
			src.icon_state = "green_labcoat_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("orange_labcoat_open")
			src.icon_state = "orange_labcoat"
			to_chat(usr, "You button up the labcoat.")
		if("orange_labcoat")
			src.icon_state = "orange_labcoat_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("labcoat_cmo_open")
			src.icon_state = "labcoat_cmo"
			to_chat(usr, "You button up the labcoat.")
		if("labcoat_cmo")
			src.icon_state = "labcoat_cmo_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("labcoat_gen_open")
			src.icon_state = "labcoat_gen"
			to_chat(usr, "You button up the labcoat.")
		if("labcoat_gen")
			src.icon_state = "labcoat_gen_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("labcoat_chem_open")
			src.icon_state = "labcoat_chem"
			to_chat(usr, "You button up the labcoat.")
		if("labcoat_chem")
			src.icon_state = "labcoat_chem_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("labcoat_vir_open")
			src.icon_state = "labcoat_vir"
			to_chat(usr, "You button up the labcoat.")
		if("labcoat_vir")
			src.icon_state = "labcoat_vir_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("labcoat_tox_open")
			src.icon_state = "labcoat_tox"
			to_chat(usr, "You button up the labcoat.")
		if("labcoat_tox")
			src.icon_state = "labcoat_tox_open"
			to_chat(usr, "You unbutton the labcoat.")
		if("labgreen_open")
			src.icon_state = "labgreen"
			to_chat(usr, "You button up the labcoat.")
		if("labgreen")
			src.icon_state = "labgreen_open"
			to_chat(usr, "You unbutton the labcoat.")
		else
			to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how retarded you are.")
			return
	usr.update_inv_wear_suit()	//so our overlays update

/obj/item/clothing/suit/storage/labcoat/red
	name = "red labcoat"
	desc = "A suit that protects against minor chemical spills. This one is red."
	icon_state = "red_labcoat_open"
	item_state = "red_labcoat"

/obj/item/clothing/suit/storage/labcoat/blue
	name = "blue labcoat"
	desc = "A suit that protects against minor chemical spills. This one is blue."
	icon_state = "blue_labcoat_open"
	item_state = "blue_labcoat"

/obj/item/clothing/suit/storage/labcoat/purple
	name = "purple labcoat"
	desc = "A suit that protects against minor chemical spills. This one is purple."
	icon_state = "purple_labcoat_open"
	item_state = "purple_labcoat"

/obj/item/clothing/suit/storage/labcoat/orange
	name = "orange labcoat"
	desc = "A suit that protects against minor chemical spills. This one is orange."
	icon_state = "orange_labcoat_open"
	item_state = "orange_labcoat"

/obj/item/clothing/suit/storage/labcoat/green
	name = "green labcoat"
	desc = "A suit that protects against minor chemical spills. This one is green."
	icon_state = "green_labcoat_open"
	item_state = "green_labcoat"

/obj/item/clothing/suit/storage/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo_open"
	item_state = "labcoat_cmo"

/obj/item/clothing/suit/storage/labcoat/mad
	name = "The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen_open"
	item_state = "labgreen"

/obj/item/clothing/suit/storage/labcoat/genetics
	name = "geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen_open"

/obj/item/clothing/suit/storage/labcoat/chemist
	name = "chemist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem_open"

/obj/item/clothing/suit/storage/labcoat/virologist
	name = "virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir_open"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 60, rad = 0)

/obj/item/clothing/suit/storage/labcoat/science
	name = "scientist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a purple stripe on the shoulder."
	icon_state = "labcoat_tox_open"