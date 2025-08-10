/obj/machinery/biogenerator
	name = "biogenerator"
	desc = ""
	icon = 'icons/obj/machines/biogenerator.dmi'
	icon_state = "biogen-stand"
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 40
	)

	var/processing = 0
	var/obj/item/reagent_holder/glass/beaker = null
	var/points = 0
	var/menustat = "menu"

/obj/machinery/biogenerator/initialise()
	. = ..()
	create_reagents(1000)
	beaker = new /obj/item/reagent_holder/glass/beaker/large(src)

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(!src.beaker)
		icon_state = "biogen-empty"
	else if(!src.processing)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/biogenerator/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/reagent_holder/glass))
		if(beaker)
			to_chat(user, SPAN_WARNING("The biogenerator is already loaded."))
		else
			user.before_take_item(O)
			O.forceMove(src)
			beaker = O
			updateUsrDialog()
	else if(processing)
		to_chat(user, SPAN_WARNING("The biogenerator is currently processing."))
	else if(istype(O, /obj/item/storage/bag/plants))
		var/i = 0
		for(var/obj/item/reagent_holder/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, SPAN_WARNING("The biogenerator is already full! Activate it."))
		else
			for(var/obj/item/reagent_holder/food/snacks/grown/G in O.contents)
				G.forceMove(src)
				i++
				if(i >= 10)
					to_chat(user, SPAN_INFO("You fill the biogenerator to its capacity."))
					break
			if(i < 10)
				to_chat(user, SPAN_INFO("You empty the plant bag into the biogenerator."))

	else if(!istype(O, /obj/item/reagent_holder/food/snacks/grown))
		to_chat(user, SPAN_WARNING("You cannot put this in [src.name]."))
	else
		var/i = 0
		for(var/obj/item/reagent_holder/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, SPAN_WARNING("The biogenerator is full! Activate it."))
		else
			user.before_take_item(O)
			O.forceMove(src)
			to_chat(user, SPAN_INFO("You put [O.name] in [src.name]."))
	update_icon()
	return

/obj/machinery/biogenerator/interact(mob/user)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	var/dat = "<TITLE>Biogenerator</TITLE>Biogenerator:<BR>"
	if(processing)
		dat += "<FONT COLOR=red>Biogenerator is processing! Please wait...</FONT>"
	else
		dat += "Biomass: [points] points.<HR>"
		switch(menustat)
			if("menu")
				if(beaker)
					dat += "<A href='byond://?src=\ref[src];action=activate'>Activate Biogenerator!</A><BR>"
					dat += "<A href='byond://?src=\ref[src];action=detach'>Detach Container</A><BR><BR>"
					dat += "Food<BR>"
					dat += "<A href='byond://?src=\ref[src];action=create;item=milk;cost=20'>10 milk</A> <FONT COLOR=blue>(20)</FONT><BR>"
					dat += "<A href='byond://?src=\ref[src];action=create;item=meat;cost=50'>Slab of meat</A> <FONT COLOR=blue>(50)</FONT><BR>"
					dat += "Nutrient<BR>"
					dat += "<A href='byond://?src=\ref[src];action=create;item=ez;cost=10'>E-Z-Nutrient</A> <FONT COLOR=blue>(10)</FONT> | <A href='byond://?src=\ref[src];action=create;item=ez5;cost=50'>x5</A><BR>"
					dat += "<A href='byond://?src=\ref[src];action=create;item=l4z;cost=20'>Left 4 Zed</A> <FONT COLOR=blue>(20)</FONT> | <A href='byond://?src=\ref[src];action=create;item=l4z5;cost=100'>x5</A><BR>"
					dat += "<A href='byond://?src=\ref[src];action=create;item=rh;cost=25'>Robust Harvest</A> <FONT COLOR=blue>(25)</FONT> | <A href='byond://?src=\ref[src];action=create;item=rh5;cost=125'>x5</A><BR>"
					dat += "Leather<BR>"
					dat += "<A href='byond://?src=\ref[src];action=create;item=wallet;cost=100'>Wallet</A> <FONT COLOR=blue>(100)</FONT><BR>"
					dat += "<A href='byond://?src=\ref[src];action=create;item=gloves;cost=250'>Botanical gloves</A> <FONT COLOR=blue>(250)</FONT><BR>"
					dat += "<A href='byond://?src=\ref[src];action=create;item=tbelt;cost=300'>Utility belt</A> <FONT COLOR=blue>(300)</FONT><BR>"
					dat += "<A href='byond://?src=\ref[src];action=create;item=satchel;cost=400'>Leather Satchel</A> <FONT COLOR=blue>(400)</FONT><BR>"
					dat += "<A href='byond://?src=\ref[src];action=create;item=cashbag;cost=400'>Cash Bag</A> <FONT COLOR=blue>(400)</FONT><BR>"
					//dat += "Other<BR>"
					//dat += "<A href='byond://?src=\ref[src];action=create;item=monkey;cost=500'>Monkey</A> <FONT COLOR=blue>(500)</FONT><BR>"
				else
					dat += "<BR><FONT COLOR=red>No beaker inside. Please insert a beaker.</FONT><BR>"
			if("nopoints")
				dat += "You do not have biomass to create products.<BR>Please, put growns into reactor and activate it.<BR>"
				dat += "<A href='byond://?src=\ref[src];action=menu'>Return to menu</A>"
			if("complete")
				dat += "Operation complete.<BR>"
				dat += "<A href='byond://?src=\ref[src];action=menu'>Return to menu</A>"
			if("void")
				dat += "<FONT COLOR=red>Error: No growns inside.</FONT><BR>Please, put growns into reactor.<BR>"
				dat += "<A href='byond://?src=\ref[src];action=menu'>Return to menu</A>"
	SHOW_BROWSER(user, dat, "window=biogenerator")
	onclose(user, "biogenerator")
	return

/obj/machinery/biogenerator/attack_hand(mob/user)
	interact(user)

/obj/machinery/biogenerator/proc/activate()
	if(usr.stat != CONSCIOUS)
		return
	if(stat & (NOPOWER|BROKEN)) //NOPOWER etc
		return
	if(src.processing)
		to_chat(usr, SPAN_WARNING("The biogenerator is in the process of working."))
		return
	var/S = 0
	for(var/obj/item/reagent_holder/food/snacks/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount("nutriment") < 0.1)
			points += 1
		else
			points += I.reagents.get_reagent_amount("nutriment") * 10
		qdel(I)
	if(S)
		processing = 1
		update_icon()
		updateUsrDialog()
		playsound(src, 'sound/machines/blender.ogg', 50, 1)
		use_power(S * 30)
		sleep(S + 15)
		processing = 0
		update_icon()
	else
		menustat = "void"
	return

/obj/machinery/biogenerator/proc/create_product(item, cost)
	if(cost > points)
		menustat = "nopoints"
		return 0
	processing = 1
	update_icon()
	updateUsrDialog()
	points -= cost
	sleep(30)
	switch(item)
		if("milk")
			beaker.reagents.add_reagent("milk", 10)
		if("meat")
			new/obj/item/reagent_holder/food/snacks/meat(src.loc)
		if("ez")
			new/obj/item/nutrient/ez(src.loc)
		if("l4z")
			new/obj/item/nutrient/l4z(src.loc)
		if("rh")
			new/obj/item/nutrient/rh(src.loc)
		if("ez5") //It's not an elegant method, but it's safe and easy. -Cheridan
			new/obj/item/nutrient/ez(src.loc)
			new/obj/item/nutrient/ez(src.loc)
			new/obj/item/nutrient/ez(src.loc)
			new/obj/item/nutrient/ez(src.loc)
			new/obj/item/nutrient/ez(src.loc)
		if("l4z5")
			new/obj/item/nutrient/l4z(src.loc)
			new/obj/item/nutrient/l4z(src.loc)
			new/obj/item/nutrient/l4z(src.loc)
			new/obj/item/nutrient/l4z(src.loc)
			new/obj/item/nutrient/l4z(src.loc)
		if("rh5")
			new/obj/item/nutrient/rh(src.loc)
			new/obj/item/nutrient/rh(src.loc)
			new/obj/item/nutrient/rh(src.loc)
			new/obj/item/nutrient/rh(src.loc)
			new/obj/item/nutrient/rh(src.loc)
		if("wallet")
			new/obj/item/storage/wallet(src.loc)
		if("gloves")
			new/obj/item/clothing/gloves/botanic_leather(src.loc)
		if("tbelt")
			new/obj/item/storage/belt/utility(src.loc)
		if("satchel")
			new/obj/item/storage/satchel(src.loc)
		if("cashbag")
			new/obj/item/storage/bag/cash(src.loc)
		if("monkey")
			new/mob/living/carbon/monkey(src.loc)
	processing = 0
	menustat = "complete"
	update_icon()
	return 1

/obj/machinery/biogenerator/Topic(href, href_list)
	. = ..()
	if(stat & (NOPOWER|BROKEN))
		return
	if(usr.stat || usr.restrained())
		return
	if(!in_range(src, usr))
		return

	usr.set_machine(src)

	switch(href_list["action"])
		if("activate")
			activate()
		if("detach")
			if(beaker)
				beaker.forceMove(loc)
				beaker = null
				update_icon()
		if("create")
			create_product(href_list["item"], text2num(href_list["cost"]))
		if("menu")
			menustat = "menu"
	updateUsrDialog()