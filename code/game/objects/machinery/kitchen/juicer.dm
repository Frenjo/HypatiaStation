/obj/machinery/juicer
	name = "juicer"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "juicer1"
	layer = 2.9
	density = FALSE
	anchored = FALSE

	power_usage = list(
		USE_POWER_IDLE = 5,
		USE_POWER_ACTIVE = 100
	)

	var/obj/item/reagent_containers/beaker = null
	var/static/list/allowed_items = list (
		/obj/item/reagent_containers/food/snacks/grown/tomato = "tomatojuice",
		/obj/item/reagent_containers/food/snacks/grown/carrot = "carrotjuice",
		/obj/item/reagent_containers/food/snacks/grown/berries = "berryjuice",
		/obj/item/reagent_containers/food/snacks/grown/banana = "banana",
		/obj/item/reagent_containers/food/snacks/grown/potato = "potato",
		/obj/item/reagent_containers/food/snacks/grown/lemon = "lemonjuice",
		/obj/item/reagent_containers/food/snacks/grown/orange = "orangejuice",
		/obj/item/reagent_containers/food/snacks/grown/lime = "limejuice",
		/obj/item/reagent_containers/food/snacks/watermelonslice = "watermelonjuice",
		/obj/item/reagent_containers/food/snacks/grown/grapes = "grapejuice",
		/obj/item/reagent_containers/food/snacks/grown/poisonberries = "poisonberryjuice",
	)

/obj/machinery/juicer/New()
	beaker = new /obj/item/reagent_containers/glass/beaker/large(src)
	. = ..()

/obj/machinery/juicer/update_icon()
	icon_state = "juicer" + num2text(isnotnull(beaker))
	return


/obj/machinery/juicer/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/glass) || \
		istype(O, /obj/item/reagent_containers/food/drinks/drinkingglass))
		if(beaker)
			return 1
		else
			user.before_take_item(O)
			O.loc = src
			beaker = O
			src.verbs += /obj/machinery/juicer/verb/detach
			update_icon()
			src.updateUsrDialog()
			return 0
	if(!is_type_in_list(O, allowed_items))
		user << "It looks as not containing any juice."
		return 1
	user.before_take_item(O)
	O.loc = src
	src.updateUsrDialog()
	return 0

/obj/machinery/juicer/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/juicer/attack_ai(mob/user as mob)
	return 0

/obj/machinery/juicer/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/juicer/interact(mob/user as mob) // The microwave Menu
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""

	for(var/i in allowed_items)
		for(var/obj/item/O in src.contents)
			if(!istype(O, i))
				continue
			processing_chamber+= "some <B>[O]</B><BR>"
			break
	if(!processing_chamber)
		is_chamber_empty = 1
		processing_chamber = "Nothing."
	if(!beaker)
		beaker_contents = "\The [src] has no beaker attached."
	else if(!beaker.reagents.total_volume)
		beaker_contents = "\The [src]  has attached an empty beaker."
		is_beaker_ready = 1
	else if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
		beaker_contents = "\The [src]  has attached a beaker with something."
		is_beaker_ready = 1
	else
		beaker_contents = "\The [src]  has attached a beaker and beaker is full!"

	var/dat = {"
<b>Processing chamber contains:</b><br>
[processing_chamber]<br>
[beaker_contents]<hr>
"}
	if(is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
		dat += "<A href='byond:://?src=\ref[src];action=juice'>Turn on!<BR>"
	if(beaker)
		dat += "<A href='byond:://?src=\ref[src];action=detach'>Detach a beaker!<BR>"
	user << browse("<HEAD><TITLE>Juicer</TITLE></HEAD><TT>[dat]</TT>", "window=juicer")
	onclose(user, "juicer")
	return


/obj/machinery/juicer/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	switch(href_list["action"])
		if("juice")
			juice()

		if("detach")
			detach()
	src.updateUsrDialog()
	return

/obj/machinery/juicer/verb/detach()
	set category = PANEL_OBJECT
	set name = "Detach Beaker from the juicer"
	set src in oview(1)

	if(usr.stat != 0)
		return
	if(!beaker)
		return
	src.verbs -= /obj/machinery/juicer/verb/detach
	beaker.loc = src.loc
	beaker = null
	update_icon()

/obj/machinery/juicer/proc/get_juice_id(obj/item/reagent_containers/food/snacks/grown/O)
	for(var/i in allowed_items)
		if(istype(O, i))
			return allowed_items[i]

/obj/machinery/juicer/proc/get_juice_amount(obj/item/reagent_containers/food/snacks/grown/O)
	if(!istype(O))
		return 5
	else if(O.potency == -1)
		return 5
	else
		return round(5 * sqrt(O.potency))

/obj/machinery/juicer/proc/juice()
	power_change() //it is a portable machine
	if(stat & (NOPOWER|BROKEN))
		return
	if(!beaker || beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
		return
	playsound(src, 'sound/machines/juicer.ogg', 50, 1)
	for(var/obj/item/reagent_containers/food/snacks/O in src.contents)
		var/r_id = get_juice_id(O)
		beaker.reagents.add_reagent(r_id, get_juice_amount(O))
		qdel(O)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break

/obj/structure/closet/crate/juice
	starts_with = list(
		/obj/machinery/juicer,
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/grown/berries,
		/obj/item/reagent_containers/food/snacks/grown/banana,
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/grown/berries,
		/obj/item/reagent_containers/food/snacks/grown/banana,
		/obj/item/reagent_containers/food/snacks/grown/tomato,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/grown/berries,
		/obj/item/reagent_containers/food/snacks/grown/banana
	)