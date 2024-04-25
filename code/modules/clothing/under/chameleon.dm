/obj/item/clothing/under/chameleon
//starts off as black
	name = "black jumpsuit"
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "black"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	origin_tech = list(RESEARCH_TECH_SYNDICATE = 3)
	siemens_coefficient = 0.8
	var/list/clothing_choices = list()

/obj/item/clothing/under/chameleon/New()
	..()
	for(var/U in SUBTYPESOF(/obj/item/clothing/under/color))
		var/obj/item/clothing/under/V = new U
		src.clothing_choices += V

	for(var/U in SUBTYPESOF(/obj/item/clothing/under/rank))
		var/obj/item/clothing/under/V = new U
		src.clothing_choices += V
	return

/obj/item/clothing/under/chameleon/attackby(obj/item/clothing/under/U as obj, mob/user as mob)
	..()
	if(istype(U, /obj/item/clothing/under/chameleon))
		to_chat(user, SPAN_WARNING("Nothing happens."))
		return
	if(istype(U, /obj/item/clothing/under))
		if(src.clothing_choices.Find(U))
			to_chat(user, SPAN_WARNING("Pattern is already recognised by the suit."))
			return
		src.clothing_choices += U
		to_chat(user, SPAN_WARNING("Pattern absorbed by the suit."))

/obj/item/clothing/under/chameleon/emp_act(severity)
	name = "psychedelic"
	desc = "Groovy!"
	icon_state = "psyche"
	item_color = "psyche"
	spawn(200)
		name = "Black Jumpsuit"
		icon_state = "bl_suit"
		item_color = "black"
		desc = null
	..()

/obj/item/clothing/under/chameleon/verb/change()
	set category = PANEL_OBJECT
	set name = "Change Color"
	set src in usr

	if(icon_state == "psyche")
		to_chat(usr, SPAN_WARNING("Your suit is malfunctioning."))
		return

	var/obj/item/clothing/under/A
	A = input("Select Colour to change it to", "BOOYEA", A) in clothing_choices
	if(!A)
		return

	desc = null
	permeability_coefficient = 0.90

	desc = A.desc
	name = A.name
	icon_state = A.icon_state
	item_state = A.item_state
	item_color = A.item_color
	usr.update_inv_wear_uniform()	//so our overlays update.


/obj/item/clothing/under/chameleon/all/New()
	..()
	var/blocked = list(/obj/item/clothing/under/chameleon, /obj/item/clothing/under/chameleon/all)
	//to prevent an infinite loop
	for(var/U in typesof(/obj/item/clothing/under)-blocked)
		var/obj/item/clothing/under/V = new U
		src.clothing_choices += V