///jar
/obj/item/reagent_holder/food/drinks/jar
	name = "empty jar"
	desc = "A jar. You're not sure what it's supposed to hold."
	icon_state = "jar"
	item_state = "beaker"

/obj/item/reagent_holder/food/drinks/jar/New()
	..()
	reagents.add_reagent("slime", 50)

/obj/item/reagent_holder/food/drinks/jar/on_reagent_change()
	if(length(reagents.reagent_list))
		switch(reagents.get_master_reagent_id())
			if("slime")
				icon_state = "jar_slime"
				name = "slime jam"
				desc = "A jar of slime jam. Delicious!"
			else
				icon_state ="jar_what"
				name = "jar of something"
				desc = "You can't really tell what this is."
	else
		icon_state = "jar"
		name = "empty jar"
		desc = "A jar. You're not sure what it's supposed to hold."
		return