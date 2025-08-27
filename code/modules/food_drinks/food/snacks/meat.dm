/obj/item/reagent_holder/food/snacks/meat
	var/subjectname = ""
	var/subjectjob = null

/obj/item/reagent_holder/food/snacks/meat/slab
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	health = 180
	starting_reagents = alist("nutriment" = 3)
	filling_color = "#FF1C1C"
	bitesize = 3

/obj/item/reagent_holder/food/snacks/meat/slab/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/kitchenknife))
		new /obj/item/reagent_holder/food/snacks/meat/rawcutlet(src)
		new /obj/item/reagent_holder/food/snacks/meat/rawcutlet(src)
		new /obj/item/reagent_holder/food/snacks/meat/rawcutlet(src)
		to_chat(user, "You cut the meat in thin strips.")
		qdel(src)
	else
		..()

/obj/item/reagent_holder/food/snacks/meat/slab/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

/obj/item/reagent_holder/food/snacks/meat/slab/human
	name = "-meat"

/obj/item/reagent_holder/food/snacks/meat/slab/monkey
	//same as plain meat

/obj/item/reagent_holder/food/snacks/meat/slab/corgi
	name = "Corgi meat"
	desc = "Tastes like... well you know..."