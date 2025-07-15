/obj/item/clothing/under/chameleon
//starts off as black
	name = "black jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "black"

	matter_amounts = /datum/design/illegal/chameleon::materials
	origin_tech = /datum/design/illegal/chameleon::req_tech

	siemens_coefficient = 0.8
	var/list/clothing_choices = list()

/obj/item/clothing/under/chameleon/initialise()
	. = ..()
	for(var/path in SUBTYPESOF(/obj/item/clothing/under/color))
		var/obj/item/clothing/under/new_under = new path()
		clothing_choices.Add(new_under)

	for(var/path in SUBTYPESOF(/obj/item/clothing/under/rank))
		var/obj/item/clothing/under/new_under = new path()
		clothing_choices.Add(new_under)

/obj/item/clothing/under/chameleon/attackby(obj/item/clothing/under/U, mob/user)
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